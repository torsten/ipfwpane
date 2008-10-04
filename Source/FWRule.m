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
 * FWRule.m, created on 28.09.2008.
 */

#import "FWRule.h"


@implementation FWRule
@synthesize enabled;
@synthesize description;
@synthesize tcpPorts;
@synthesize udpPorts;
@synthesize stillDefault;


#pragma mark NSObject


- (id)init
{
	if((self = [super init]))
	{
		enabled = NO;
		description = [NSString string];
		tcpPorts = [NSString string];
		udpPorts = [NSString string];
		stillDefault = NO;
	}
	return self;
}


- (id)initEnabled:(BOOL)pEnabled
	description:(NSString*)pDescription
	tcpPorts:(NSString*)pTCPPorts
	udpPorts:(NSString*)pUDPPorts
	stillDefault:(BOOL)pDefault;
{
	if((self = [super init]))
	{
		enabled = pEnabled;
		description = pDescription;
		tcpPorts = pTCPPorts;
		udpPorts = pUDPPorts;
		stillDefault = pDefault;
	}
	return self;
}

- (void)dealloc
{
	[description release];
	[tcpPorts release];
	[udpPorts release];
	
	[super dealloc];
}


#pragma mark Public Methods



@end
