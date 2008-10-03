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
 * FWipfwModel.h, created on 20.09.2008.
 */

#import <Cocoa/Cocoa.h>
#import <Security/Authorization.h>


@class FWPrefPane;
@class FWRule;
@class FWConfigHandler;
@class FWRootRunner;


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
	FWConfigHandler *mConfHandler;
	FWRootRunner *mRunner;
}

/**
 *	To make this accessible from interface builder.
 */
@property BOOL firewallEnabled;

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
 *
 *	Does not require a valid AuthorizationRef.
 */
- (void)reloadRules;

/**
 *	Saves all pending rules back to ipfw.
 *
 *	REQUIRES a valid AuthorizationRef.
 */
- (void)saveRules;

/**
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
 *	Uses stat(2) to find out if FW_LAUNCH_DAEMON_FILENAME does exist or not.
 */
- (BOOL)firewallEnabled;

@end


@interface FWipfwModel (Private)

/**
 *	Open a temporary file and return the file descriptor and
 *	the name of the file.
 */
- (void)openTempFileAndSaveFDAt:(int*)fileDesPtr saveNameAt:(NSString**)strPtr;

/**
 *	
 */
- (void)writeFrameworkRulesToFile:(int)fd;

/**
 *	Installs the launch daemon in /Library/LaunchDaemons
 */
- (void)installLaunchDaemon;

/**
 *	Removes the launch daemon.
 */
- (void)removeLaunchDaemon;

/**
 *	Lets the ipfw forget all rules
 */
- (void)flushRules;

/**
 *	This is very different from flushRules, as this only clears the internal
 *	rules to enable a reload but this method does not affect the ipfw.
 */
- (void)clearRules;

@end
