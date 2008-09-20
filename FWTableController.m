//
//  FWTableController.m
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FWTableController.h"
#import "FWPrefPane.h"
#import "FWipfwModel.h"


@implementation FWTableController

- (int)numberOfRowsInTableView:(NSTableView *)pTableView
{
	return [oModel numberOfRules];
}

- (id)tableView:(NSTableView *)pTableView
      objectValueForTableColumn:(NSTableColumn *)pTableColumn
      row:(int)pRow
{
	FWipfwRule *rule = [oModel ruleForIndex:pRow];
	
	if(pTableColumn == oBoolColumn)
		return [NSNumber numberWithBool:rule->enabled];
	
	else
		return rule->title;
}

// - (BOOL)tableView:(NSTableView *)pTableView
// 	shouldEditTableColumn:(NSTableColumn *)pTableColumn
// 	row:(NSInteger)pRowIndex
// {
// 	if(pTableColumn == oBoolColumn)
// 		return YES;
// 	
// 	else
// 		return NO;
// }

- (void)tableViewSelectionDidChange:(NSNotification *)pNotification
{
	if([oTableView selectedRow] == -1)
		[oPrefPane enableModifyButtons:NO];
	
	else
		[oPrefPane enableModifyButtons:YES];
}

- (void)tableView:(NSTableView *)pTableView
	setObjectValue:(id)pValue
	forTableColumn:(NSTableColumn *)pTableColumn
	row:(NSInteger)pRowIndex
{
	FWipfwRule *rule = [oModel ruleForIndex:pRowIndex];
	
	if(pTableColumn == oBoolColumn)
		rule->enabled = [pValue boolValue];
}

- (IBAction)removeSelectedRow:(id)pSender
{
	NSLog(@"REMOVE");
}


@end
