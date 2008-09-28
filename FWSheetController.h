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
	
	IBOutlet NSPopUpButton *oPopUpButton;
	
	IBOutlet NSTextField *oTCPPortsTextField;
	IBOutlet NSTextField *oUDPPortsTextField;
	IBOutlet NSTextField *oDescriptionTextField;
}

- (IBAction)saveSheet:(id)sender;
- (IBAction)cancelSheet:(id)sender;

- (IBAction)popUpButtonChanged:(id)sender;

- (void)addRule;

@end
