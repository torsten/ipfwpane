//
//  FWSheetController.m
//  ipfwPane
//
//  Created by Torsten Becker on 21.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

#import "FWSheetController.h"



@interface FWSheetController(Private)
@end


NSInteger FWSheetControllerSortDefaultRules(
		NSMutableDictionary *a, NSMutableDictionary *b, void *context);


@implementation FWSheetController

- (void)awakeFromNib
{
	// Initialize the combo Box
	
	NSString *defaultRulesFile = [[oPrefPane bundle] pathForResource:
			@"DefaultRules" ofType:@"plist"];
	
	NSMutableArray *rules =
			[NSMutableArray arrayWithContentsOfFile:defaultRulesFile];
	
	[rules sortUsingFunction:FWSheetControllerSortDefaultRules context:nil];
	
	NSMenuItem *item;
	NSImage *smartBadge = [NSImage imageNamed:@"NSSmartBadgeTemplate"];
	BOOL gotFirstSmart = NO;
	
	for(NSDictionary *dict in rules)
	{
		item = [[[NSMenuItem alloc] init] autorelease];
		[item setRepresentedObject:dict];
		
		if([dict objectForKey:@"IsSmart"])
		{
			[item setImage:smartBadge];
			[item setToolTip:@"Updates automatically if you change the port."];
			
			// Add the seperator for smart items if we get the first one
			if(!gotFirstSmart)
			{
				gotFirstSmart = YES;
				[[oPopUpButton menu] addItem:[NSMenuItem separatorItem]];
			}
		}
		
		[item setTitle:[dict objectForKey:@"Title"]];
		[[oPopUpButton menu] addItem:item];
	}
	
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
	[oDescriptionTextField setStringValue:[[oPopUpButton selectedItem] title]];
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


NSInteger FWSheetControllerSortDefaultRules(
		NSMutableDictionary *pA, NSMutableDictionary *pB, void *pContext)
{
	BOOL aIsSmart = NO, bIsSmart = NO;
	
	if([pA objectForKey:@"TCPSmartPorts"] != nil ||
	   [pA objectForKey:@"UDPSmartPorts"] != nil)
	{
		[pA setObject:[NSNumber numberWithBool:YES] forKey:@"IsSmart"];
		aIsSmart = YES;
	}

	if([pB objectForKey:@"TCPSmartPorts"] != nil ||
	   [pB objectForKey:@"UDPSmartPorts"] != nil)
	{
		[pB setObject:[NSNumber numberWithBool:YES] forKey:@"IsSmart"];
		bIsSmart = YES;
	}

	
	if(aIsSmart == bIsSmart)
		return [[pA objectForKey:@"Title"] caseInsensitiveCompare:
				[pB objectForKey:@"Title"]];
	
	else
	{
		if(aIsSmart)
			return NSOrderedDescending;
		
		else
			return NSOrderedAscending;
	}
}
