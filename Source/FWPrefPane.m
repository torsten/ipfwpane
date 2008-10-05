/*
 * Copyright (C) 2008 Torsten Becker. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * FWPrefPane.m, created on 20.09.2008.
 */

#import <SecurityInterface/SFAuthorizationView.h>

#import "FWPrefPane.h"
#import "FWTableController.h"
#import "FWipfwModel.h"

#import "DebugFU.h"


@implementation FWPrefPane

@synthesize uiIsEnabled;
@synthesize tableIsEnabled;
@synthesize modifyButtonsAreEnabled;


#pragma mark NSPreferencePane


- (id)initWithBundle:(NSBundle *)pBundle
{
	if((self = [super initWithBundle:pBundle]))
	{
		// Currently no longer needed, because we do not use the
		// common per-user preferences.
		//
		// defaultsDict = [NSMutableDictionary dictionaryWithDictionary:
		// 		[[NSUserDefaults standardUserDefaults]
		// 			persistentDomainForName:[[self bundle] bundleIdentifier]]];
		// 
		// [defaultsDict retain];
	}
	return self;
}

- (void)mainViewDidLoad
{
	[oAuthorizationView setString:"system.privilege.admin"];
	[oAuthorizationView updateStatus:oAuthorizationView];
	[oAuthorizationView setDelegate:self];
	
	[self setUpIcon];
	[self patchVersionStrings];
	
	[self enableUI:NO];
	
	[oTableController refreshTable];
}

// see initWithBundle
//
// - (NSPreferencePaneUnselectReply)shouldUnselect
// {
// 	[[NSUserDefaults standardUserDefaults] setPersistentDomain:defaultsDict
// 			forName:[[self bundle] bundleIdentifier]];
// 	
// 	return NSUnselectNow;
// }


#pragma mark SFAuthorizationView Delegate


- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)pView
{
	FULog(@"authorize");
	
	[self enableUI:YES];
	[oModel setAuthorizationRef:[[pView authorization] authorizationRef]];
	
	// TODO: clean up this
	// if enabled
	// [oModel saveRules]
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)pView
{
	FULog(@"deauthorize");
	
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
		if([oModel firewallEnabled])
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

- (void)patchVersionStrings
{
	NSString *shortVersion =
	[[self bundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	
	NSString *longVersion =
			[[self bundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	
	NSString *gitRevision =
			[[self bundle] objectForInfoDictionaryKey:@"FWGitRevision"];
	
	NSMutableString *toolTip = [NSMutableString stringWithString:@"Version "];
	[toolTip retain];
	[toolTip appendString:longVersion];
	[toolTip appendString:@", Revision "];
	[toolTip appendString:gitRevision];
#ifdef DEBUG
	[toolTip appendString:@", Debug enabled"];
#endif
	
	[oCreditsField addToolTipRect:[oCreditsField bounds]
			owner:toolTip userData:NULL];
	
	NSString *newCreditString =
	[[oCreditsField stringValue] stringByReplacingOccurrencesOfString:@"${REV}"
			withString:shortVersion];
	
	[oCreditsField setStringValue:newCreditString];
}

@end
