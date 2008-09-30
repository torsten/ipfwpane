//
//  FWRule.m
//  ipfwPane
//
//  Created by Torsten Becker on 28.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FWRule.h"


@implementation FWRule
@synthesize enabled;
@synthesize description;
@synthesize tcpPorts;
@synthesize udpPorts;


- (id)init
{
	if((self = [super init]))
	{
		enabled = NO;
		description = [NSString string];
		tcpPorts = [NSString string];
		udpPorts = [NSString string];
	}
	return self;
}


- (id)initEnabled:(BOOL)pEnabled
	description:(NSString*)pDescription
	tcpPorts:(NSString*)pTCPPorts
	udpPorts:(NSString*)pUDPPorts;
{
	if((self = [super init]))
	{
		enabled = pEnabled;
		description = pDescription;
		tcpPorts = pTCPPorts;
		udpPorts = pUDPPorts;
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


@end
