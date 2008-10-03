/*
 * Copyright (C) 2008 Torsten Becker. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * FWConfigHandler.mm, created on 01.10.2008.
 */

#import "FWConfigHandler.h"
#import "FWipfwModel.h"
#import "FWRule.h"

#import "DebugFU.h"

#include <string>
#include <vector>

#include <string.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>


#define FW_RULE_MARKER "#<FWRule:"


@interface FWConfigHandler (Private)
- (void)parseLine:(std::string&)string;
- (void)appendString:(NSString*)nsString inQuotesTo:(std::string&)stdString;

@end


@implementation FWConfigHandler


#pragma mark NSObject


- (id)initWithModel:(FWipfwModel*)pModel
{
	if((self = [super init]))
	{
		mModel = pModel;
	}
	return self;
}


#pragma mark Public Methods


- (void)parseFile:(int)pIpfwConfFd
{
    ssize_t didRead;
	char readBuffer[3000];
	
	std::string currentLine;
	
	// Read from the fd into the readBuffer and then search in this
	// buffer for a newline, then pass each found line to parseLine:.
	for(;;)
	{
		didRead = read(pIpfwConfFd, readBuffer, sizeof(readBuffer));
		
		FULog(@"didRead: %d", didRead);
		
		if(didRead == -1)
		{
			NSLog(@"read(2) error from pipe.");
			return;
		}
		// Just handle lines which did really end with a \n.
		else if(didRead == 0)
			break;
		
		else
			for(ssize_t i = 0; i < didRead; ++i)
			{
				currentLine.push_back(readBuffer[i]);
				
				if(readBuffer[i] == '\n')
				{
					[self parseLine:currentLine];
					currentLine.clear();
				}
			}
	}
}

- (void)writeRulesToFile:(int)pIpfwConfFd
{
	FWRule *rule;
	std::string entry;
	unsigned int numRules = [mModel numberOfRules];
	
	for(unsigned int i = 0; i < numRules; ++i)
	{
		rule = [mModel ruleForIndex:i];
		entry.clear();
		
		entry.append(FW_RULE_MARKER);
		
		[self appendString:rule.description inQuotesTo:entry];
		[self appendString:rule.tcpPorts inQuotesTo:entry];
		[self appendString:rule.udpPorts inQuotesTo:entry];
		
		if(rule.enabled)
			entry.append("\"1\">\n");
		else
			entry.append("\"0\">\n");
		
		// If the rule is disabled do not print any real instructions about it.
		if(rule.enabled)
		{
			if(rule.tcpPorts != nil && [rule.tcpPorts length] > 0)
			{
				entry.append(
						"add 41337 set 23 allow tcp from any to any dst-port ");
				entry.append([rule.tcpPorts UTF8String]);
				entry.append(" in\n");
			}
			
			if(rule.udpPorts != nil && [rule.udpPorts length] > 0)
			{
				entry.append(
						"add 41337 set 23 allow udp from any to any dst-port ");
				entry.append([rule.udpPorts UTF8String]);
				entry.append(" in\n");
			}			
		}
		
		entry.append("\n");
		
		write(pIpfwConfFd, entry.c_str(), entry.size());
	}
}

@end


@implementation FWConfigHandler (Private)

- (void)appendString:(NSString*)pNSString inQuotesTo:(std::string&)pStdString
{
	std::string quoted([pNSString UTF8String]);
	
	const struct
	{
		const char from;
		const char *to;
	}
	replacements[] =
	{
		{'\\', "\\\\"},
		{'"', "\\\""},
		{'\n', "\\n"},
		{'\0', NULL}
	};
	
	for(size_t j = 0; replacements[j].to != NULL; ++j)
	{
		for(size_t i = 0; i < quoted.size();)
		{
			i = quoted.find(replacements[j].from, i);
			
			if(i == std::string::npos)
				break;
			
			quoted.replace(i, 1, replacements[j].to);
			i += strlen(replacements[j].to);
		}
	}
	
	pStdString.append("\"");
	pStdString.append(quoted);
	pStdString.append("\" ");
}

- (void)parseLine:(std::string&)pString
{
	enum ParseState
	{
		InitialState = 0,
		QuotesState = 1,
		BackslashState = 2
	};
	
	if(pString.find(FW_RULE_MARKER) == 0)
	{
		FULog(@"parseLine:%s", pString.c_str());
		
		enum ParseState state = InitialState;
		std::string accu;
		std::vector<NSString*> strings;
		
		// Parse some strings with quotes and backslashes
		for(std::string::size_type i = 0; i < pString.size(); ++i)
		{
			if(state == InitialState)
			{
				// Got a new value
				if(pString[i] == '"')
					state = QuotesState;
			}
			else if(state == QuotesState)
			{
				// End of string
				if(pString[i] == '"')
				{
					strings.push_back(
							[NSString stringWithUTF8String:accu.c_str()]);
					
					accu.clear();
					state = InitialState;
				}
				else if(pString[i] == '\\')
					state = BackslashState;
				
				else
					accu.push_back(pString[i]);
			}
			else if(state == BackslashState)
			{
				if(pString[i] == 'n')
					accu.push_back('\n');
				else
					accu.push_back(pString[i]);
				
				state = QuotesState;
			}
			else
			{
				FULog(@"Invalid ParseState: %d", state);
				return;
			}
		}
		
		if(strings.size() != 4)
		{
			FULog(@"Wrong amount of information, will not create rule.");
			return;
		}
		
		// Initialize the new FWRule with all the data we jsut parsed.
		FWRule *newRule = [[[FWRule alloc] init] autorelease];;
		
		newRule.description = strings[0];
		newRule.tcpPorts = strings[1];
		newRule.udpPorts = strings[2];
		newRule.enabled = [strings[3] boolValue];
		
		[mModel addRule:newRule];
	}
}

@end
