//
//  FWPrefPane.h
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>


@class SFAuthorizationView;
@class FWTableController;
@class FWipfwModel;


@interface FWPrefPane : NSPreferencePane 
{
	IBOutlet NSImageView *oIconView;
	IBOutlet SFAuthorizationView *oAuthorizationView;
	
	IBOutlet NSTableView *oTableView;
	
	IBOutlet FWTableController *oTableController;
	IBOutlet FWipfwModel *oModel;
	// IBOutlet FWSheetController *oSheetController;
	
	BOOL uiIsEnabled;
	BOOL tableIsEnabled;
	BOOL modifyButtonsAreEnabled;
	
	NSMutableDictionary *defaultsDict;
}

@property BOOL uiIsEnabled;
@property BOOL tableIsEnabled;
@property BOOL modifyButtonsAreEnabled;
@property(readonly) NSMutableDictionary *defaultsDict;


- (void)enableUI:(BOOL)enabled;

- (void)enableTable:(BOOL)enabled;

- (void)enableModifyButtons:(BOOL)enabled;


- (void)mainViewDidLoad;

- (void)setUpIcon;

- (IBAction)toggleFirewall:(id)sender;

- (void)enableFirewall;

- (void)disableFirewall;


@end
