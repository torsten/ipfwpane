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
	FWRule *rule;
	
	rule = [[[FWRule alloc] initEnabled:YES
		description:@"Bonjour (mDNS)"
		tcpPorts:@""
		udpPorts:@"5353"] autorelease];
	[mModel addRule:rule];
	
	rule = [[[FWRule alloc] initEnabled:YES
		description:@"Transmission"
		tcpPorts:@"17328"
		udpPorts:@""] autorelease];
	[mModel addRule:rule];
	
	rule = [[[FWRule alloc] initEnabled:YES
		description:@"Navajo"
		tcpPorts:@"8008"
		udpPorts:@""] autorelease];
	[mModel addRule:rule];
}

// NSPropertyListSerialization

- (void)writeRulesToFile:(int)pIpfwConfFd
{
	const char *testData =
	"add 41337 set 23 allow tcp from any to any dst-port 8008 in\n"
	"add 41337 set 23 allow tcp from any to any dst-port 17328 in\n"
	"add 41337 set 23 allow udp from any to any dst-port 5353 in\n";
	
	write(pIpfwConfFd, testData, strlen(testData));
}

@end
