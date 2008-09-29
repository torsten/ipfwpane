//
//  FWipfwModel.mm
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FWipfwModel.h"
#import "FWPrefPane.h"
#import "FWRule.h"

#include <stdio.h>

// #include <vector>  --  has already been done in FWipfwModel.h


@implementation FWipfwModel


#pragma mark NSObject


- (id)init
{
	if((self = [super init]))
	{
		mRules = new FWipfwRuleContainer();
		mAuthRef = NULL;
	}
	return self;
}

- (void)dealloc
{
	FWipfwRuleContainer::iterator iter(mRules->begin());
	
	// delete/free/dealloc each rule in the container.
	for(; iter != mRules->end(); ++iter)
		[(*iter) release];
	
	
	delete mRules;
	
	[super dealloc];
}


#pragma mark Public Methods


- (unsigned int)numberOfRules
{
	return mRules->size();
}

- (FWRule*)ruleForIndex:(unsigned int)pIndex
{
	return (*mRules)[pIndex];
}

- (void)addRule:(FWRule*)pNewRule
{
	[pNewRule retain];
	mRules->push_back(pNewRule);
}

- (void)removeRuleAtIndex:(unsigned int)pIndex
{
	[((*mRules)[pIndex]) release];
	mRules->erase(mRules->begin()+pIndex);
}

- (void)reloadRules
{
	NSLog(@"LOAD");
}

- (void)saveRules
{
	NSLog(@"SAVE");
}

- (void)setAuthorizationRef:(AuthorizationRef)pAuthRef
{
	NSLog(@"NEW REF");
	
	mAuthRef = pAuthRef;
	
	[self runId];
}

- (void)setFirewallEnabled:(BOOL)enable
{
	
}

- (BOOL)firewallEnabled
{
	return NO;
}


@end


@implementation FWipfwModel (Private)

- (void)runId
{
	NSLog(@"id... %@", [self runRootCommand:"/usr/bin/id"]);
}

- (NSString*)runRootCommand:(char*)pCmd;
{
	OSStatus status;
	FILE *communicationsPipe;
	
	char *nullPtr = 0; // aka argv
	const AuthorizationFlags options = kAuthorizationFlagDefaults;
	
	// TODO: Ensure somehow at this point, that pCmd is not bad.
	
	status = AuthorizationExecuteWithPrivileges(
			mAuthRef, pCmd, options, &nullPtr, &communicationsPipe);
	
	if(status == errAuthorizationSuccess)
	{
#ifdef DEBUG
			NSLog(@"errAuthorizationSuccess, continuing...");
#endif
	}
	else
	{
#ifdef DEBUG
		NSLog(@"NOT errAuthorizationSuccess, STOP.");
#endif
		return nil;
	}
	
	// manpage says: "These functions should not fail [...]"
	int fd = fileno(communicationsPipe);
    
	NSFileHandle *fh = [[[NSFileHandle alloc]
			initWithFileDescriptor:fd] autorelease];
	
	NSData *data = [fh readDataToEndOfFile];
	
	if(fclose(communicationsPipe) != 0)
	{
#ifdef DEBUG
		NSLog(@"fclose() ERROR");
#endif
	}
	
	NSString *str = [[[NSString alloc] 
			initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	return str;
}


@end