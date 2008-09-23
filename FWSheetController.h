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
	
	IBOutlet NSButton *oTCPButton;
	IBOutlet NSButton *oUDPButton;
	
	IBOutlet NSTextField *oPortsTextField;
	IBOutlet NSTextField *oDescriptionTextField;
	
	IBOutlet NSPopUpButton *oPopUpButton;
}

- (IBAction)saveSheet:(id)sender;
- (IBAction)cancelSheet:(id)sender;

- (IBAction)popUpButtonChanged:(id)sender;

- (void)addRule;

@end
