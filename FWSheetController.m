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
	[oPopUpButton addItemWithTitle:@"FTP Server"];
	[oPopUpButton addItemWithTitle:@"iChat AV"];
	[oPopUpButton addItemWithTitle:@"ICQ File Transfer"];
	[oPopUpButton addItemWithTitle:@"SMB"];
	[oPopUpButton addItemWithTitle:@"SSH"];
	[oPopUpButton addItemWithTitle:@"Webserver (HTTP)"];
	

	[[oPopUpButton menu] addItem:[NSMenuItem separatorItem]];


	NSMenuItem *item;
	NSImage *smartBadge = [NSImage imageNamed:@"NSSmartBadgeTemplate"];
	
	
	item = [[[NSMenuItem alloc] init] autorelease];
	[item setImage:smartBadge];
	[item setTitle:@"ShakesPeer"];
	
	[[oPopUpButton menu] addItem:item];

	
	item = [[[NSMenuItem alloc] init] autorelease];
	[item setImage:smartBadge];
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
	NSLog(@"CHANGE");
}

- (void)didEndSheet:(NSWindow *)pSheet returnCode:(int)pReturnCode contextInfo:(void *)pContextInfo
{
	NSLog(@"DID END");
	
    [pSheet orderOut:self];
}

@end
