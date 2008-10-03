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
 * FWipfwConfHandler.mm, created on 01.10.2008.
 */

#import "FWipfwConfHandler.h"
#import "FWipfwModel.h"
#import "FWRule.h"

#import "DebugFU.h"

#include <string>
#include <vector>

#include <string.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>


@interface FWipfwConfHandler (Private)
- (void)parseLine:(std::string&)string;

@end


// TODO: maybe rename to FWConfigHandler
@implementation FWipfwConfHandler


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
	// FWRule *rule;
	// 
	// rule = [[[FWRule alloc] initEnabled:YES
	// 	description:@"Bonjour (mDNS)"
	// 	tcpPorts:@""
	// 	udpPorts:@"5353"] autorelease];
	// [mModel addRule:rule];
	// 
	// rule = [[[FWRule alloc] initEnabled:YES
	// 	description:@"Transmission"
	// 	tcpPorts:@"17328"
	// 	udpPorts:@""] autorelease];
	// [mModel addRule:rule];
	// 
	// rule = [[[FWRule alloc] initEnabled:YES
	// 	description:@"Navajo"
	// 	tcpPorts:@"8008"
	// 	udpPorts:@""] autorelease];
	// [mModel addRule:rule];
	
	
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
			NSLog(@"read error from pipe.");
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
	const char *testData =
	"#\n"
	"add 41337 set 23 allow tcp from any to any dst-port 8008 in\n"
	"#\n"
	"add 41337 set 23 allow tcp from any to any dst-port 17328 in\n"
	"#+#\"Bonjour (mDNS)\" \"BS:\\\\QT:\\\"NL:\\np:\\p\" \"5353\" \"0\"\n"
	"add 41337 set 23 allow udp from any to any dst-port 5353 in\n";
	
	write(pIpfwConfFd, testData, strlen(testData));
}

@end


@implementation FWipfwConfHandler (Private)

- (void)parseLine:(std::string&)pString
{
	enum ParseState
	{
		InitialState = 0,
		QuotesState = 1,
		BackslashState = 2
	};
	
	struct ConversionDescription
	{
		SEL ruleSelector;
		SEL stringSelector;
	}
	deserializationTable[] =
	{
		{@selector(setDescription:), nil},
		{@selector(setTcpPorts:), nil},
		{@selector(setUdpPorts:), nil},
		{@selector(setEnabled:), @selector(boolValue)},
		{nil, nil}
	};
	
	if(pString.find("#+#") == 0)
	{
		FULog(@"parseLine:'%s'", pString.c_str());
		
		// Erase the start marker
		pString.erase(0, 3);
		
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
		
		// Initialize the new FWRule with all the data we jsut parsed in
		// the order which is specified in deserializationTable.
		FWRule *newRule = [[[FWRule alloc] init] autorelease];;
		for(size_t i = 0; deserializationTable[i].ruleSelector != nil; ++i)
		{
			if(i >= strings.size())
			{
				FULog(@"OMG, TMI: Too much information. (%u)", i);
				return;
			}
			
			// If stringSelector is nil, just take the string as argument
			if(deserializationTable[i].stringSelector == nil)
				[newRule performSelector:(deserializationTable[i].ruleSelector)
						withObject:strings[i]];
			
			// Else call first a conversion selector on the string.
			else
			{
				id value = [strings[i] performSelector:
						(deserializationTable[i].stringSelector)];
				
				[newRule performSelector:(deserializationTable[i].ruleSelector)
						withObject:value];
			}
		}
		
		[mModel addRule:newRule];
	}
}

@end
