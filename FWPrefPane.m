//
//  FWPrefPane.m
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

#import <SecurityInterface/SFAuthorizationView.h>

#import "FWPrefPane.h"
#import "FWTableController.h"
#import "FWipfwModel.h"


@implementation FWPrefPane

@synthesize uiIsEnabled;
@synthesize tableIsEnabled;
@synthesize modifyButtonsAreEnabled;
@synthesize defaultsDict;


#pragma mark NSPreferencePane


- (id)initWithBundle:(NSBundle *)pBundle
{
	if((self = [super initWithBundle:pBundle]))
	{
		defaultsDict = [NSMutableDictionary dictionaryWithDictionary:
				[[NSUserDefaults standardUserDefaults]
					persistentDomainForName:[[self bundle] bundleIdentifier]]];
		
		[defaultsDict retain];
	}
	return self;
}

- (void)mainViewDidLoad
{
	[oAuthorizationView setString:"system.privilege.admin"];
	[oAuthorizationView updateStatus:self];
	[oAuthorizationView setDelegate:self];
	
	[self setUpIcon];
	
	// Replace the placeholder ${REV} by the real version from the Info.plist
	[oCreditsField setStringValue:[[
			oCreditsField stringValue]
			stringByReplacingOccurrencesOfString:@"${REV}"
			withString:[[self bundle]
				objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]];
	
	
	[self enableUI:NO];
	
	// TODO: this enables the UI when the app starts, REMOVE THIS:
	[self authorizationViewDidAuthorize:oAuthorizationView];
	
	[oTableController refreshTable];
}

- (NSPreferencePaneUnselectReply)shouldUnselect
{
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:defaultsDict
			forName:[[self bundle] bundleIdentifier]];
	
	return NSUnselectNow;
}


#pragma mark SFAuthorizationView Delegate


- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)pView
{
	[self enableUI:YES];
	
	[oModel setAuthorizationRef:[[pView authorization] authorizationRef]];
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)pView
{
	[self enableUI:NO];
	
	[oModel setAuthorizationRef:NULL];
}


#pragma mark IBActions


- (IBAction)toggleFirewall:(id)pSender
{
	if([pSender state] == NSOnState)
		[self enableTable:YES];
	
	else
		[self enableTable:NO];
}


@end


@implementation FWPrefPane(Private)

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


- (void)setUpIcon
{
	// No +imageNamed: usage because we are not looking the the
	// app bundle but in the bundle of the prefPane plugin.
	
	NSString* path = [[self bundle] pathForResource:@"ipfwPanePref"
			ofType:@"png"];
	
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
	
	
	[img setScalesWhenResized:YES];
	[oIconView setImageScaling:NSScaleToFit];
	
	
	[oIconView setImage:img];
}

- (void)enableFirewall
{
	// ...
}

- (void)disableFirewall
{
	// ...
}


@end