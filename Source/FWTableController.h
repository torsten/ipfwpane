//
//  FWTableController.h
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class FWPrefPane;
@class FWipfwModel;
@class FWSheetController;


@interface FWTableController : NSObject
{
	IBOutlet NSTableColumn *oBoolColumn;
	IBOutlet NSTableColumn *oStringColumn;
	
	IBOutlet NSTableView *oTableView;
	
	IBOutlet FWPrefPane *oPrefPane;
	IBOutlet FWipfwModel *oModel;
	
	IBOutlet FWSheetController *oSheetController;
}

- (IBAction)removeSelectedRow:(id)sender;
- (IBAction)editSelectedRow:(id)sender;
- (IBAction)addItem:(id)sender;

/**
 *	Forces the model to reload its data and then reloads the table view.
 */
- (void)refreshTable;


@end
