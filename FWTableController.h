//
//  FWTableController.h
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FWTableController : NSObject
{
	IBOutlet NSTableColumn *oBoolColumn;
	IBOutlet NSTableColumn *oStringColumn;
}

- (IBAction)removeSelectedRow:(id)sender;

@end
