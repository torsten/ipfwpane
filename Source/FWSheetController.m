//
//  FWSheetController.m
//  ipfwPane
//
//  Created by Torsten Becker on 21.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

#import "FWSheetController.h"
#import "FWRule.h"


NSInteger FWSheetControllerSortDefaultRules(
		NSMutableDictionary *a, NSMutableDictionary *b, void *context);


enum FWSheetControllerReturnCode
{
	FWSheetControllerReturnCancel = 0,
	FWSheetControllerReturnSave = 1
};


@implementation FWSheetController

// - (id)init
// {
// 	if((self = [super init]))
// 	{
// 		
// 	}
// 	return self;
// }
// 
// - (void)dealloc
// {
// 	
// 	
// 	[super dealloc];
// }


#pragma mark NSNibAwaking


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
	
	item = [[[NSMenuItem alloc] init] autorelease];
	[item setRepresentedObject:[NSDictionary dictionary]];
	[item setTitle:@"Other"];
	[[oPopUpButton menu] addItem:item];
}


#pragma mark IBActions


- (IBAction)saveSheet:(id)pSender
{
    [NSApp endSheet:oAddSheet returnCode:FWSheetControllerReturnSave];
}

- (IBAction)cancelSheet:(id)pSender
{
    [NSApp endSheet:oAddSheet returnCode:FWSheetControllerReturnCancel];
	
}

- (IBAction)popUpButtonChanged:(id)pSender
{
	NSDictionary *ruleData = [[oPopUpButton selectedItem] representedObject];
	
	
	if([ruleData objectForKey:@"TCPPorts"])
		[oTCPPortsTextField setStringValue:[ruleData objectForKey:@"TCPPorts"]];
	else
		[oTCPPortsTextField setStringValue:[NSString string]];
	
		
	if([ruleData objectForKey:@"UDPPorts"])
		[oUDPPortsTextField setStringValue:[ruleData objectForKey:@"UDPPorts"]];
	else
		[oUDPPortsTextField setStringValue:[NSString string]];
	
	
	// Yes, there is no else
	if([ruleData objectForKey:@"Title"])
		[oDescriptionTextField setStringValue:[ruleData objectForKey:@"Title"]];
}


#pragma mark NSControl Delegate


- (void)controlTextDidChange:(NSNotification *)pNotification
{
	// If the text in any of the boxes changes, fall back to
	// the "Other" item.
	[oPopUpButton selectItem:[oPopUpButton lastItem]];
}


#pragma mark NSApp Sheet didEndSelectors


- (void)didEndCreateSheet:(NSWindow *)pSheet returnCode:(int)pReturnCode
	contextInfo:(void *)pContextInfo
{
	if(pReturnCode == FWSheetControllerReturnSave)
	{
		FWRule *newRule = [[[FWRule alloc] init] autorelease];
		
		newRule.enabled = YES;
		newRule.description = [oDescriptionTextField stringValue];
		newRule.tcpPorts = [oTCPPortsTextField stringValue];
		newRule.udpPorts = [oUDPPortsTextField stringValue];
		
		id <FWSheetControllerCallback> callback = pContextInfo;
		
		[callback sheetCreatedNewRule:newRule];
	}
	
	
    [pSheet orderOut:self];
}

- (void)didEndEditSheet:(NSWindow *)pSheet returnCode:(int)pReturnCode
	contextInfo:(void *)pContextInfo
{
	id <FWSheetControllerCallback> callback = pContextInfo;
	
	if(pReturnCode == FWSheetControllerReturnSave)
	{
		mRuleInEdit.description = [oDescriptionTextField stringValue];
		mRuleInEdit.tcpPorts = [oTCPPortsTextField stringValue];
		mRuleInEdit.udpPorts = [oUDPPortsTextField stringValue];
		
		[callback sheetDidEditRule:mRuleInEdit];
	}
	else
		[callback sheetCanceledEditRule:mRuleInEdit];
	
	
	[pSheet orderOut:self];
}


#pragma mark Public Methods


- (void)createRuleAndCallback:(id)pCallback
{
	[oPopUpButton selectItem:nil];
	[oAddSheet makeFirstResponder:oPopUpButton];
	
	oDescriptionTextField.stringValue = [NSString string];
	oTCPPortsTextField.stringValue = [NSString string];
	oUDPPortsTextField.stringValue = [NSString string];
	
	[NSApp beginSheet:oAddSheet
			modalForWindow:[NSApp mainWindow]
			modalDelegate:self
            didEndSelector:@selector(didEndCreateSheet:returnCode:contextInfo:)
            contextInfo:pCallback];
}

- (void)editRule:(FWRule*)pRule andCallback:(id)pCallback
{
	[oPopUpButton selectItem:nil];
	[oAddSheet makeFirstResponder:oTCPPortsTextField];
	
	oDescriptionTextField.stringValue = pRule.description;
	oTCPPortsTextField.stringValue = pRule.tcpPorts;
	oUDPPortsTextField.stringValue = pRule.udpPorts;
	
	mRuleInEdit = pRule;
	
	[NSApp beginSheet:oAddSheet
			modalForWindow:[NSApp mainWindow]
			modalDelegate:self
            didEndSelector:@selector(didEndEditSheet:returnCode:contextInfo:)
            contextInfo:pCallback];
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
