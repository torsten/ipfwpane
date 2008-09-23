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

// #include <vector>  --  has been done already in FWipfwModel.h


@implementation FWipfwModel

- (id)init
{
	if(self = [super init])
	{
		mRules = new FWipfwRuleVector();
		
		FWipfwRule *rule = new FWipfwRule;
		rule->enabled = YES;
		rule->title = @"Transmissionnnnn";
		rule->body = nil;
		
		mRules->push_back(rule);
	}
	return self;
}

- (void)dealloc
{
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
	
}

- (void)addRuleEnabled:(BOOL)enabled
	withTitle:(NSString*)title
	body:(NSString*)body
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
