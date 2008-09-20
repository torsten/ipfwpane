//
//  FWPrefPane.m
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

#import "FWPrefPane.h"

#import <SecurityInterface/SFAuthorizationView.h>


@implementation FWPrefPane

- (void)mainViewDidLoad
{
	[oAuthorizationView setString:"system.privilege.admin"];
	[oAuthorizationView updateStatus:self];
	
	[self setUpIcon];
	
	// [oAuthorizationView setAutoupdate:YES];
	// [oAuthorizationView setAuthorizationRights:&authorizationRights];
}

- (void)setUpIcon
{
	NSLog(@"setUpIcon");
	
	// NSImage *img = [NSImage imageNamed:@"ipfwPanePref.png"];
	
	NSString* path = [[self bundle] pathForResource:@"ipfwPanePref"
			ofType:@"png"];
	
	// NSString *path = [[NSBundle mainBundle] pathForResource:@"ipfwPanePref"
	// 	ofType:@"png"];
	
	NSLog(@"path: %@", path);
	
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
	[img setScalesWhenResized:YES];
	
	
	NSLog(@"width: %f", [img size].width);
	
	// INFO((@"...", ...))
	
	[oIconView setImageScaling:NSScaleToFit];
	
	[oIconView setImage:img];
}

- (IBAction)toggleFirewall:(id)pSender
{
	if([pSender state] == NSOnState)
		[self enableFirewall];

	else
		[self disableFirewall];
}

- (void)enableFirewall
{
	[oRemoveButton setEnabled:YES];
	[oAddButton setEnabled:YES];
	[oTableView setEnabled:YES];
	
	// ...
}

- (void)disableFirewall
{
	[oRemoveButton setEnabled:NO];
	[oAddButton setEnabled:NO];
	[oTableView setEnabled:NO];
	
	// ...
}


- (IBAction)addItem:(id)pSender
{
	/*
	The didEndSelector method is optional. If implemented by the modalDelegate, this method is invoked after the modal session has ended and is passed a return code and caller specified in contextInfo. didEndSelector should have the following signature:

	- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
	*/
	
	[NSApp beginSheet:oAddSheet
			modalForWindow:[NSApp mainWindow]
			modalDelegate:nil
			didEndSelector:nil
			contextInfo:NULL];
}

- (IBAction)endSheet:(id)pSender
{
	NSLog(@"END");
	[NSApp endSheet:oAddSheet];
}


@end
