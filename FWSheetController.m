//
//  FWSheetController.m
//  ipfwPane
//
//  Created by Torsten Becker on 21.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FWSheetController.h"


@implementation FWSheetController

- (void)awakeFromNib
{
	// Initialize the combo Box
	
	[oPopUpButton addItemWithTitle:@"AFP"];
	[oPopUpButton addItemWithTitle:@"Apple Remote Desktop"];
	[oPopUpButton addItemWithTitle:@"FTP Server"];
	[oPopUpButton addItemWithTitle:@"iChat AV"];
	[oPopUpButton addItemWithTitle:@"ICQ File Transfer"];
	[oPopUpButton addItemWithTitle:@"Printer Sharing"];
	[oPopUpButton addItemWithTitle:@"Remote Login (SSH)"];
	[oPopUpButton addItemWithTitle:@"Web Server (HTTP)"];
	[oPopUpButton addItemWithTitle:@"Windows Sharing (SMB)"];
	

	[[oPopUpButton menu] addItem:[NSMenuItem separatorItem]];


	NSMenuItem *item;
	NSImage *smartBadge = [NSImage imageNamed:@"NSSmartBadgeTemplate"];
	
	
	item = [[[NSMenuItem alloc] init] autorelease];
	[item setImage:smartBadge];
	[item setToolTip:@"Updates automatically if you change the port."];
	
	[item setTitle:@"ShakesPeer"];
	[[oPopUpButton menu] addItem:item];

	
	item = [[[NSMenuItem alloc] init] autorelease];
	[item setImage:smartBadge];
	[item setToolTip:@"Updates automatically if you change the port."];
	
	[item setTitle:@"Transmission"];
	[[oPopUpButton menu] addItem:item];


	[[oPopUpButton menu] addItem:[NSMenuItem separatorItem]];

	
	[oPopUpButton addItemWithTitle:@"Other"];
	
	[oPopUpButton selectItem:nil];
}

- (void)addRule
{
	[NSApp beginSheet:oAddSheet
			modalForWindow:[NSApp mainWindow]
			modalDelegate:self
            didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
            contextInfo:nil];
}

- (IBAction)saveSheet:(id)pSender
{
	NSLog(@"SAVE");
    [NSApp endSheet:oAddSheet];
	
}

- (IBAction)cancelSheet:(id)pSender
{
	NSLog(@"CANCEL");
    [NSApp endSheet:oAddSheet];
	
}

- (IBAction)popUpButtonChanged:(id)pSender
{
	[oDescriptionTextField setStringValue:[[pSender selectedItem] title]];
}

- (void)didEndSheet:(NSWindow *)pSheet returnCode:(int)pReturnCode contextInfo:(void *)pContextInfo
{
	NSLog(@"DID END");
	
    [pSheet orderOut:self];
}


- (void)controlTextDidChange:(NSNotification *)pNotification
{
	// If the text in any of the boxes changes, fall back to
	// the "Other" item.
	[oPopUpButton selectItem:[oPopUpButton lastItem]];
}


@end
