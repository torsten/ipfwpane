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
	
	[self runId:pAuthRef];
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

- (void)runId:(AuthorizationRef)pAuthRef
{
	NSLog(@"id...");
	
	
	OSStatus status;
	FILE *communicationsPipe;
	
	char *pathToTool = "/usr/bin/id";
	char *nullPtr = 0; // aka argv
	const AuthorizationFlags options = kAuthorizationFlagDefaults;
	
	status = AuthorizationExecuteWithPrivileges(
			pAuthRef, pathToTool, options, &nullPtr, &communicationsPipe);
	
	if(status == errAuthorizationSuccess)
		NSLog(@"errAuthorizationSuccess");
	
	else
	{
		NSLog(@"NOT errAuthorizationSuccess");
		return;
	}
	
	
	int fd = fileno(communicationsPipe);
    
	NSFileHandle *fh = [[[NSFileHandle alloc]
			initWithFileDescriptor:fd] autorelease];
	
	NSData *data = [fh readDataToEndOfFile];
	
	
	if(fclose(communicationsPipe) != 0)
		NSLog(@"fclose error");
	
	
	NSString *str = [[[NSString alloc] 
			initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSLog(@"%@", str);
}


@end