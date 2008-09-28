//
//  FWSheetController.h
//  ipfwPane
//
//  Created by Torsten Becker on 21.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class NSPreferencePane;
@class FWRule;


@interface FWSheetController : NSObject
{
	IBOutlet NSWindow *oAddSheet;
	
	IBOutlet NSPopUpButton *oPopUpButton;
	
	IBOutlet NSTextField *oTCPPortsTextField;
	IBOutlet NSTextField *oUDPPortsTextField;
	IBOutlet NSTextField *oDescriptionTextField;
	
	IBOutlet NSPreferencePane *oPrefPane;
}

- (IBAction)saveSheet:(id)sender;
- (IBAction)cancelSheet:(id)sender;

- (IBAction)popUpButtonChanged:(id)sender;


/**
 *	If OK gets pressed, this results in a callback of the method:
 *	- (void)sheetCreatedNewRule:(FWRule*)rule;
 *
 *	On cancel nothing will happen.
 */ 
- (void)createRuleAndCallback:(id)callback;

/**
 *	If the rule got modified, this will result in the following callback:
 *	- (void)sheetDidEditRule:(FWRule*)rule;
 *	
 *	If the user pressed cancel, this will be called:
 *	- (void)sheetCanceledEditRule:(FWRule*)rule;	
 */
- (void)editRule:(FWRule*)rule andCallback:(id)callback;


@end


@protocol FWSheetControllerCallback
- (void)sheetCreatedNewRule:(FWRule*)rule;
- (void)sheetCanceledEditRule:(FWRule*)rule;
- (void)sheetDidEditRule:(FWRule*)rule;	

@end
