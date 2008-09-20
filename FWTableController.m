//
//  FWTableController.m
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FWTableController.h"
#import "FWPrefPane.h"


@implementation FWTableController

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 2;
}

- (id)tableView:(NSTableView *)tableView
      objectValueForTableColumn:(NSTableColumn *)tableColumn
      row:(int)row
{
	// NSLog(@"Col: %d  Row: %d", tableColumn, row);
	
	if(tableColumn == oBoolColumn)
		return [NSNumber numberWithInt:row];
	
	else
		return @"HMM";
}

- (BOOL)tableView:(NSTableView *)pTableView
shouldSelectTableColumn:(NSTableColumn *)pTableColumn
{
	return NO;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	if(aTableColumn == oBoolColumn)
		return YES;
		
	else
		return NO;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	if([oTableView selectedRow] == -1)
		[oPrefPane enableModifyButtons:NO];
	
	else
		[oPrefPane enableModifyButtons:YES];
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	NSLog(@"NEW: %@", anObject);
}

- (IBAction)removeSelectedRow:(id)pSender
{
	NSLog(@"REMOVE");
}


@end
