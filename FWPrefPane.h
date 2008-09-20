//
//  FWPrefPane.h
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>


@class SFAuthorizationView;


@interface FWPrefPane : NSPreferencePane 
{
	IBOutlet NSImageView *oIconView;
	IBOutlet SFAuthorizationView *oAuthorizationView;
	
	IBOutlet NSTableView *oTableView;
	IBOutlet NSButton *oAddButton;
	IBOutlet NSButton *oRemoveButton;
}

- (void)mainViewDidLoad;

- (void)setUpIcon;

- (IBAction)toggleFirewall:(id)sender;

- (IBAction)addItem:(id)sender;

- (IBAction)removeItem:(id)sender;

- (void)enableFirewall;

- (void)disableFirewall;

@end
