/*
 * Copyright (C) 2008 Torsten Becker. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * FWTableController.m, created on 20.09.2008.
 */

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
