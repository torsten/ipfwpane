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


#pragma mark NSTableDataSource


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

- (void)tableView:(NSTableView *)pTableView
	setObjectValue:(id)pValue
	forTableColumn:(NSTableColumn *)pTableColumn
	row:(NSInteger)pRowIndex
{
	FWRule *rule = [oModel ruleForIndex:pRowIndex];
	
	if(pTableColumn == oBoolColumn)
		rule.enabled = [pValue boolValue];
	
	[oModel saveRules];
}


#pragma mark NSTableView Delegate


- (void)tableViewSelectionDidChange:(NSNotification *)pNotification
{
	if([oTableView selectedRow] == -1)
		[oPrefPane enableModifyButtons:NO];
	
	else
		[oPrefPane enableModifyButtons:YES];
}

// This is the double click on a row
- (BOOL)tableView:(NSTableView *)pTableView
	shouldEditTableColumn:(NSTableColumn *)pTableColumn
	row:(NSInteger)pRowIndex
{
	if(pTableColumn == oStringColumn)
	{
		[self editSelectedRow:nil];
		
		return NO;
	}
	else
		return YES;
}


#pragma mark IBActions


- (IBAction)removeSelectedRow:(id)pSender
{
	if([oTableView selectedRow] != -1)
		[oModel removeRuleAtIndex:[oTableView selectedRow]];
	
	[oModel saveRules];
	
	[oTableView reloadData];

}

- (IBAction)editSelectedRow:(id)pSender
{
	if([oTableView selectedRow] != -1)
		[oSheetController editRule:
				[oModel ruleForIndex:[oTableView selectedRow]]andCallback:self];
}

- (IBAction)addItem:(id)pSender
{
	[oSheetController createRuleAndCallback:self];
}


#pragma mark FWSheetControllerCallback


- (void)sheetCreatedNewRule:(FWRule*)pRule
{
	[oModel addRule:pRule];
	[oModel saveRules];
	
	[oTableView reloadData];
}

- (void)sheetDidEditRule:(FWRule*)pRule
{
	[oModel saveRules];
	
	[oTableView reloadData];
}

- (void)sheetCanceledEditRule:(FWRule*)pRule
{
}


#pragma mark Public Methods


- (void)refreshTable
{
	[oModel reloadRules];
	[oTableView reloadData];
}


@end
