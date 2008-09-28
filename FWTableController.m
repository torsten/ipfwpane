//
//  FWTableController.m
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FWPrefPane.h"
#import "FWRule.h"
#import "FWSheetController.h"
#import "FWTableController.h"
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
	FWRule *rule = [oModel ruleForIndex:pRow];
	
	if(pTableColumn == oBoolColumn)
		return [NSNumber numberWithBool:rule.enabled];
	
	else
		return rule.description;
}

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
	FWRule *rule = [oModel ruleForIndex:pRowIndex];
	
	if(pTableColumn == oBoolColumn)
		rule.enabled = [pValue boolValue];
}

- (IBAction)removeSelectedRow:(id)pSender
{
	if([oTableView selectedRow] != -1)
		[oModel removeRuleAtIndex:[oTableView selectedRow]];
	
	[oTableView reloadData];

}

- (BOOL)tableView:(NSTableView *)pTableView
	shouldEditTableColumn:(NSTableColumn *)pTableColumn
	row:(NSInteger)pRowIndex
{
	NSLog(@"EDIT");
	
	if(pTableColumn == oStringColumn)
		return NO;
	
	else
		return YES;
}

- (IBAction)editSelectedRow:(id)pSender
{
	// [oSheetController editRule:rule andCallback:self];
}

- (IBAction)addItem:(id)pSender
{
	[oSheetController createRuleAndCallback:self];
}

- (void)sheetCreatedNewRule:(FWRule*)pRule
{
	[oModel addRule:pRule];
	[oTableView reloadData];
}


@end
