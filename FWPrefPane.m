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
		[self setModifyButtonsAreEnabled:NO];
}


- (void)mainViewDidLoad
{
	[oAuthorizationView setString:"system.privilege.admin"];
	[oAuthorizationView updateStatus:self];
	[oAuthorizationView setDelegate:self];
	
	[self setUpIcon];
	
	[self enableUI:NO];
	
	// TODO: remove this:
	[self authorizationViewDidAuthorize:nil];
}

- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)pView
{
	[self enableUI:YES];
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)pView
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
	// ...
}

- (void)disableFirewall
{
	// ...
}


- (IBAction)addItem:(id)pSender
{
	[NSApp beginSheet:oAddSheet
			modalForWindow:[NSApp mainWindow]
			modalDelegate:self
            didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
            contextInfo:nil];
	
	
}

- (IBAction)closeSheet:(id)pSender
{
	NSLog(@"END");
    [NSApp endSheet:oAddSheet];
}

- (void)didEndSheet:(NSWindow *)pSheet returnCode:(int)pReturnCode contextInfo:(void *)pContextInfo
{
    [pSheet orderOut:self];
}


@end
