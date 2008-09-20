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

@synthesize uiIsEnabled;
@synthesize tableIsEnabled;
@synthesize modifyButtonsAreEnabled;
@synthesize defaultsDict;

- (id)initWithBundle:(NSBundle *)pBundle
{
	if(self = [super initWithBundle:pBundle])
	{
		defaultsDict = [NSMutableDictionary dictionaryWithDictionary:
				[[NSUserDefaults standardUserDefaults]
					persistentDomainForName:[[self bundle] bundleIdentifier]]];
		
		[defaultsDict retain];
	}
	return self;
}

- (NSPreferencePaneUnselectReply)shouldUnselect
{
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:defaultsDict
			forName:[[self bundle] bundleIdentifier]];
	
	return NSUnselectNow;
}


- (void)enableUI:(BOOL)pEnable
{
	if(pEnable)
	{
		[self setUiIsEnabled:pEnable];
		
		// If the checkbox is toggled
		if([[defaultsDict objectForKey:@"isFirewallEnabled"] boolValue])
			[self setTableIsEnabled:YES];
		
		else
			[self setTableIsEnabled:NO];
		
		
		// if a row is selected
		if([oTableView selectedRow] != -1)
			[self setModifyButtonsAreEnabled:YES];
		
		else
			[self setModifyButtonsAreEnabled:NO];
	}
	else
	{
		[self setUiIsEnabled:NO];
		[self setTableIsEnabled:NO];
		[self setModifyButtonsAreEnabled:NO];
	}
}

- (void)enableTable:(BOOL)pEnable
{
	if(pEnable)
	{
		if([self uiIsEnabled])
		{
			[self setTableIsEnabled:YES];
			
			// if a row is selected
			if([oTableView selectedRow] != -1)
				[self setModifyButtonsAreEnabled:YES];
		
			else
				[self setModifyButtonsAreEnabled:NO];
		}
	}
	else
	{
		[self setTableIsEnabled:NO];
		[self setModifyButtonsAreEnabled:NO];
	}
}

- (void)enableModifyButtons:(BOOL)pEnable
{
	if(pEnable)
	{
		if([self tableIsEnabled])
			[self setModifyButtonsAreEnabled:YES];
	}
	else
	{
		[self setTableIsEnabled:NO];
		[self setModifyButtonsAreEnabled:NO];
	}
}


- (void)mainViewDidLoad
{
	[oAuthorizationView setString:"system.privilege.admin"];
	[oAuthorizationView updateStatus:self];
	[oAuthorizationView setDelegate:self];
	
	[self setUpIcon];
	
	[self enableUI:NO];
}

- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)pView
{
	[self enableUI:YES];
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view
{
	[self enableUI:NO];
}

- (void)setUpIcon
{
	NSString* path = [[self bundle] pathForResource:@"ipfwPanePref"
			ofType:@"png"];
	
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
	
	
	[img setScalesWhenResized:YES];
	[oIconView setImageScaling:NSScaleToFit];
	
	
	[oIconView setImage:img];
}

- (IBAction)toggleFirewall:(id)pSender
{
	if([pSender state] == NSOnState)
		[self enableTable:YES];
	
	else
		[self enableTable:NO];
}

- (void)enableFirewall
{
	// [oRemoveButton setEnabled:YES];
	// [oAddButton setEnabled:YES];
	// [oTableView setEnabled:YES];
	
	// ...
}

- (void)disableFirewall
{
	// [oRemoveButton setEnabled:NO];
	// [oAddButton setEnabled:NO];
	// [oTableView setEnabled:NO];
	
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
