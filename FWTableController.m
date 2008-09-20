//
//  FWTableController.m
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FWTableController.h"


@implementation FWTableController

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 2;
}

- (id)tableView:(NSTableView *)tableView
      objectValueForTableColumn:(NSTableColumn *)tableColumn
      row:(int)row
{
	return @"HMM";
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectTableColumn:(NSTableColumn *)aTableColumn
{
	return NO;
}


@end
