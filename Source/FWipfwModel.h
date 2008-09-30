//
//  FWipfwModel.h
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Security/Authorization.h>


@class FWPrefPane;
@class FWRule;


#ifdef __cplusplus
	#include <vector>
	typedef std::vector<FWRule*> FWipfwRuleContainer;
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
	AuthorizationRef mAuthRef;
}

/**
 *	The number of rules which get maintained
 */
- (unsigned int)numberOfRules;

/**
 *	Returns the rule at the given index.
 */
- (FWRule*)ruleForIndex:(unsigned int)index;

/**
 *	Adds new rule.
 */
- (void)addRule:(FWRule*)newRule;

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
- (void)setAuthorizationRef:(AuthorizationRef)authRef;

/**
 *	Enables or disables the firewall, this also creates the startup item
 *	or removes it.
 */
- (void)setFirewallEnabled:(BOOL)enable;

/**
 *	
 */
- (BOOL)firewallEnabled;

@end


@interface FWipfwModel (Private)

/**
 *	
 */
- (void)getRuleList;

/**
 *	Runs ipfw with the given arguments and returns the output as a string.
 *	The list is terminated by a NULL pointer.
 *
 *	If this method returns nil, something went wrong.
 */
- (NSString*)runIpfwWithArgs:(const char*)arg, ...;

/**
 *	Open a temporary file and return the file descriptor and
 *	the name of the file.
 */
- (void)openTempFileAndSaveFDAt:(int*)fileDesPtr saveNameAt:(NSString**)strPtr;
                                      
/**
 *	
 */
- (void)addRulesToIpfw;

/**
 *	
 */
- (void)writeActiveRulesTo:(int)fd;

@end
