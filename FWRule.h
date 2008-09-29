//
//  FWRule.h
//  ipfwPane
//
//  Created by Torsten Becker on 28.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


/**
 *	Just a POO for keeping the rule-data,
 *	
 *	TODO:
 *	- present
 *	- smart-rule? [none/nil oder app-domain aka org.m0k.transmission]
 */
@interface FWRule : NSObject
{
	/**
	 *	If it is currently enabled or not.
	 */
	BOOL enabled;
	
	/**
	 *	The string shown in the UI
	 */
	NSString *description;
	
	/**
	 *	
	 */
	NSString *tcpPorts;
	
	/**
	 *	
	 */
	NSString *udpPorts;
}

@property BOOL enabled;
@property(retain) NSString *description;
@property(retain) NSString *tcpPorts;
@property(retain) NSString *udpPorts;

- (id)initEnabled:(BOOL)enabled
	description:(NSString*)desc
	tcpPorts:(NSString*)tcp
	udpPorts:(NSString*)udp;


@end
