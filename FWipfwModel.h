//
//  FWipfwModel.h
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class FWPrefPane;

struct FWipfwRuleStruct;

#ifdef __cplusplus
	#include <vector>
	typedef std::vector<struct FWipfwRuleStruct*> FWipfwRuleContainer;
#else
	typedef int* FWipfwRuleContainer;
#endif


/**
 *	This class is a small abstraction for maintaining a list of ipfw rules
 *	in ipfw itself and having a nice interface to it.
 */
@interface FWipfwModel : NSObject
{
	FWipfwRuleContainer *mRules;
}

/**
 *	The number of rules which get maintained
 */
- (unsigned int)numberOfRules;

/**
 *	Returns the rule at the given index.
 */
- (struct FWipfwRuleStruct*)ruleForIndex:(unsigned int)index;

/**
 *	Adds new rule.
 */
- (void)addRule:(struct FWipfwRuleStruct*)newRule;

/**
 *	First creates a new rule and then it fills the new one with the
 *	values from the old one.  After this it adds the new rule.
 */
- (void)copyAndAddRule:(struct FWipfwRuleStruct*)newRule;

/**
 *	Adds a rule with a more convienient interface.
 */
// - (void)addRuleEnabled:(BOOL)enabled
// 	withTitle:(NSString*)title
// 	body:(NSString*)body;

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
