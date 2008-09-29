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

#include "DebugFU.h"

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
	FULog(@"LOAD");
}

- (void)saveRules
{
	FULog(@"SAVE");
}

- (void)setAuthorizationRef:(AuthorizationRef)pAuthRef
{
	mAuthRef = pAuthRef;
	
	[self getRuleList];
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

- (void)getRuleList
{
	NSLog(@"%@", [self runIpfwAsRootWithArgs:"-S", "list", NULL]);
}

- (NSString*)runIpfwAsRootWithArgs:(char*)pArg, ...
{
	// Count the arguments
	va_list argumentList;
	unsigned int argumentCount;
	char *nextStr;
	
	if(pArg == NULL)
	{
		argumentCount = 0;
	}
	else
	{
		argumentCount = 1;
		va_start(argumentList, pArg);
		
		for(;;)
		{
			nextStr = va_arg(argumentList, char*);
			
			if(nextStr == NULL)
				break;
			
			++argumentCount;
		}
		
		va_end(argumentList);
	}
	
	FULog(@"runIpfwAsRootWithArgs got %d args.", argumentCount);
	
	
	// Collect the arguments into argv
	char *argv[argumentCount+1];
	
	va_start(argumentList, pArg);
	
	for(unsigned int i = 0; i < argumentCount; ++i)
		argv[i] = va_arg(argumentList, char*);
	
	va_end(argumentList);
	
	// This gets changed
	OSStatus status;
	FILE *communicationsPipe;
	
	// Constant stuff
	const char *ipfw = "/sbin/ipfw";
	const AuthorizationFlags options = kAuthorizationFlagDefaults;
	
	// TODO: Ensure somehow at this point, that pCmd is not bad.
	
	status = AuthorizationExecuteWithPrivileges(
			mAuthRef, ipfw, options, argv, &communicationsPipe);
	
	if(status == errAuthorizationSuccess)
	{
		FULog(@"errAuthorizationSuccess, continuing...");
	}
	else
	{
		FULog(@"NOT errAuthorizationSuccess, STOP.");
		return nil;
	}
	
	// manpage says: "These functions should not fail [...]"
	int fd = fileno(communicationsPipe);
    
	NSFileHandle *fh = [[[NSFileHandle alloc]
			initWithFileDescriptor:fd] autorelease];
	
	NSData *data = [fh readDataToEndOfFile];
	
	if(fclose(communicationsPipe) != 0)
	{
		FULog(@"fclose() ERROR");
	}
	
	NSString *str = [[[NSString alloc] 
			initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	return str;
}


@end
