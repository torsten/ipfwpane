//
//  FWipfwModel.mm
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FWipfwModel.h"
#import "FWPrefPane.h"

#include <vector>


struct FWipfwModelCppMembers
{
	std::vector<FWipfwRule*> rules;
};


@implementation FWipfwModel

- (id)init
{
	if(self = [super init])
	{
		m = new FWipfwModelCppMembers;
		
		FWipfwRule *rule = new FWipfwRule;
		rule->enabled = YES;
		rule->title = @"Test";
		rule->body = nil;
		
		m->rules.push_back(rule);
	}
	return self;
}

- (void)dealloc
{
	delete m;
	
	[super dealloc];
}


- (unsigned int)numberOfRules
{
	return m->rules.size();
}

- (FWipfwRule*)ruleForIndex:(unsigned int)pIndex
{
	return m->rules[pIndex];
}

- (void)addRule:(FWipfwRule*)pNewRule
{
	
}

- (void)removeRuleAtIndex:(unsigned int)pIndex
{
	
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
