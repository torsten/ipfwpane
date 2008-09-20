//
//  FWipfwModel.h
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class FWPrefPane;


/**
 *	A struct to get the data out of the class in a structured way.
 */
typedef struct
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
	
} FWipfwRule;


/**
 *	A work around to have c++ containers as members without telling
 *	the Obj-C runtime about this...
 */
struct FWipfwModelCppMembers;


/**
 *	This class is a small abstraction for maintaining a list of ipfw rules
 *	in ipfw itself and having a nice interface to it.
 */
@interface FWipfwModel : NSObject
{
	struct FWipfwModelCppMembers *m;
}

/**
 *	The number of rules which get maintained
 */
- (unsigned int)numberOfRules;

/**
 *	Returns the rule at the given index.
 */
- (FWipfwRule*)ruleForIndex:(unsigned int)index;

/**
 *	Adds new rule.
 */
- (void)addRule:(FWipfwRule*)newRule;

/**
 *	Adds a rule with a more convienient interface.
 */
- (void)addRuleEnabled:(BOOL)enabled
	withTitle:(NSString*)title
	body:(NSString*)body;

/**
 *	Removed the rule at the index.
 */
- (void)removeRuleAtIndex:(unsigned int)index;

/**
 *	Load all rules from ipfw into the class.
 */
- (void)reloadRules;

/**
 *	Saves all pending rules back to ipfw.
 */
- (void)saveRules;

/**
 *	TODO: rename this
 *
 *	With this method you can set an authorization struct so the model can
 *	use sudo, without it, it will not be able to return data as you need
 *	root access to play around with ipfw.
 */
- (void)setAuthStuff:(void*)someAuthStuff;

@end
