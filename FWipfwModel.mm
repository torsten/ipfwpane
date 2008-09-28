//
//  FWipfwModel.mm
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FWipfwModel.h"
#import "FWPrefPane.h"
#import "FWipfwRule.h"

// #include <vector>  --  has already been done in FWipfwModel.h


@implementation FWipfwModel

- (id)init
{
	if((self = [super init]))
	{
		mRules = new FWipfwRuleContainer();
		
		FWipfwRule *rule = new FWipfwRule;
		rule->enabled = YES;
		rule->title = @"Transmission";
		rule->body = nil;
		
		mRules->push_back(rule);
	}
	return self;
}

- (void)dealloc
{
	FWipfwRuleContainer::iterator iter(mRules->begin());
	
	// delete/free/dealloc each rule in the container.
	for(; iter != mRules->end(); ++iter)
		delete (*iter);
	
	
	delete mRules;
	
	[super dealloc];
}


- (unsigned int)numberOfRules
{
	return mRules->size();
}

- (FWipfwRule*)ruleForIndex:(unsigned int)pIndex
{
	return (*mRules)[pIndex];
}

- (void)addRule:(FWipfwRule*)pNewRule
{
	mRules->push_back(pNewRule);
}

- (void)copyAndAddRule:(FWipfwRule*)pNewRule
{
	FWipfwRule *tmpRule = new FWipfwRule();
	
	tmpRule->enabled = pNewRule->enabled;
	tmpRule->title = pNewRule->title;
	tmpRule->body = pNewRule->body;
	
	[self addRule:tmpRule];
}

- (void)removeRuleAtIndex:(unsigned int)pIndex
{
	delete ((*mRules)[pIndex]);
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
