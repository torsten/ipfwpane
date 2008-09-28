//
//  FWipfwRule.h
//  ipfwPane
//
//  Created by Torsten Becker on 23.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// @interface FWipfwRule : NSObject {
// 	
// }
// 
// @end


/**
 *	A struct to get the data out of the class in a structured way.
 *
 *	- TCP ports
 *	- UDP ports
 *	- present
 *	- desciption
 *	- smart-rule? [none/nil oder app-domain aka org.m0k.transmission]
 */
struct FWipfwRuleStruct
{
	/**
	 *	If it is currently enabled or not.
	 */
	BOOL enabled;
	
	/**
	 *	The string shown in the UI
	 */
	NSString *title;
	
	/**
	 *	Which ports are actually meant
	 */
	NSString *body;
	
};

typedef struct FWipfwRuleStruct FWipfwRule;
