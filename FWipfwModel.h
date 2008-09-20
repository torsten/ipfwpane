//
//  FWipfwModel.h
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class FWPrefPane;


typedef struct
{
	BOOL enabled;
	NSString *description;
} FWipfwRule;


@interface FWipfwModel : NSObject
{
	IBOutlet FWPrefPane *oPrefPane;
}

- (unsigned int)numberOfRules;

- (FWipfwRule*)ruleForIndex:(unsigned int)index;

- (void)addRule:(FWipfwRule*)newRule;

- (void)removeRuleAtIndex:(unsigned int)index;

- (void)loadRules;

- (void)saveRules;

@end
