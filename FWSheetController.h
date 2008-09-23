//
//  FWSheetController.h
//  ipfwPane
//
//  Created by Torsten Becker on 21.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FWSheetController : NSObject
{
	IBOutlet NSWindow *oAddSheet;
}

- (IBAction)closeSheet:(id)sender;

- (void)addRule;

@end
