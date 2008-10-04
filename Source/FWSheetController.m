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
 * FWSheetController.m, created on 21.09.2008.
 */

#import <PreferencePanes/PreferencePanes.h>

#import "FWPortListValidator.h"
#import "FWRule.h"
#import "FWSheetController.h"

#import "DebugFU.h"


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

- (void)controlTextDidEndEditing:(NSNotification *)pNotification
{
	if([pNotification object] == oTCPPortsTextField)
		[oTCPPortsTextField setStringValue:
				[FWPortListValidator validateAndCorrectPorts:
					[oTCPPortsTextField stringValue]]];
	
	else if([pNotification object] == oUDPPortsTextField)
		[oUDPPortsTextField setStringValue:
				[FWPortListValidator validateAndCorrectPorts:
					[oUDPPortsTextField stringValue]]];
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
		
		newRule.tcpPorts = [FWPortListValidator validateAndCorrectPorts:
				[oTCPPortsTextField stringValue]];
		newRule.udpPorts = [FWPortListValidator validateAndCorrectPorts:
				[oUDPPortsTextField stringValue]];
		
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
		
		mRuleInEdit.tcpPorts = [FWPortListValidator validateAndCorrectPorts:
				[oTCPPortsTextField stringValue]];
		mRuleInEdit.udpPorts = [FWPortListValidator validateAndCorrectPorts:
				[oUDPPortsTextField stringValue]];
		
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
