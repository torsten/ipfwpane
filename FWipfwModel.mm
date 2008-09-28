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

// #include <vector>  --  has already been done in FWipfwModel.h


@implementation FWipfwModel

- (id)init
{
	if((self = [super init]))
	{
		mRules = new FWipfwRuleContainer();
		
		// FWRule *rule = [[FWRule alloc] initEnabled:YES description:@"TEST"
		// 		tcpPorts:nil udpPorts:nil];
		// 
		// mRules->push_back(rule);
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
	
}

- (void)saveRules
{
	
}

- (void)setAuthStuff:(void*)someAuthStuff
{
	
}


@end
