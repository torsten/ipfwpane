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


@interface FWTableController : NSObject
{
	IBOutlet NSTableColumn *oBoolColumn;
	IBOutlet NSTableColumn *oStringColumn;
	
	IBOutlet NSTableView *oTableView;
	
	IBOutlet FWPrefPane *oPrefPane;
	IBOutlet FWipfwModel *oModel;
}

- (IBAction)removeSelectedRow:(id)sender;

@end
