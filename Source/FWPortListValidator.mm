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
 * THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS AS IS'' AND
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
 * FWPortListValidator.mm, created on 04-Oct-2008.
 */

#import "FWPortListValidator.h"

#import "DebugFU.h"

#include <cctype>
#include <string>


@implementation FWPortListValidator

+ (NSString*)validateAndCorrectPorts:(NSString*)pPortList
{
	enum ParseState
	{
		InitialState = 0,
		NumberState = 1,
		GotSpaceState = 2,
		GotRangeState = 3,
		SecondNumberState = 4
	}
	state = InitialState;
	std::string portList([pPortList UTF8String]);
	std::string::iterator iter;
	
	for(iter = portList.begin(); iter != portList.end(); ++iter)
	{
		if(state == InitialState)
		{
			if(isdigit(*iter))
				state = NumberState;
			
			else
				portList.erase(iter--);
			
		}
		else if(state == NumberState)
		{
			if(!isdigit(*iter))
			{
				if(*iter == '-')
					state = GotRangeState;
				
				else
				{
					*iter = ',';
					state = GotSpaceState;
				}
			}
		}
		else if(state == GotSpaceState)
		{
			if(isdigit(*iter))
				state = NumberState;
			
			else
			{
				if(*iter == '-')
				{
					--iter;
					portList.erase(iter);
					state = GotRangeState;
				}
				else
					portList.erase(iter--);
				
			}
		}
		else if(state == GotRangeState)
		{
			if(isdigit(*iter))
				state = SecondNumberState;
			
			else
				portList.erase(iter--);
			
		}
		else if(state == SecondNumberState)
		{
			if(!isdigit(*iter))
			{
				*iter = ',';
				state = GotSpaceState;
			}
		}
		else
		{
			FULog(@"Invalid parse state: %d", state);
			return nil;
		}
	}
	
	// If the last char is not a digit, remove it.
	std::string::size_type len = portList.size();
	
	if(len > 0 && !isdigit(portList[len-1]))
		portList.erase(len-1, 1);
	
	return [NSString stringWithUTF8String:portList.c_str()];
}

@end
