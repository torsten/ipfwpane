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
 * FWSheetController.h, created on 21.09.2008.
 */

#import <Cocoa/Cocoa.h>


@class NSPreferencePane;
@class FWRule;


/**
 *	The protocol you should implement if you use this class and
 *	expect callbacks form it.
 */
@protocol FWSheetControllerCallback
- (void)sheetCreatedNewRule:(FWRule*)rule;
- (void)sheetCanceledEditRule:(FWRule*)rule;
- (void)sheetDidEditRule:(FWRule*)rule;	

@end


/**
 *	Provides an interface for the edit sheet for FWRules.
 */
@interface FWSheetController : NSObject
{
	IBOutlet NSWindow *oAddSheet;
	
	IBOutlet NSPopUpButton *oPopUpButton;
	
	IBOutlet NSTextField *oTCPPortsTextField;
	IBOutlet NSTextField *oUDPPortsTextField;
	IBOutlet NSTextField *oDescriptionTextField;
	
	IBOutlet NSButton *oCanelButton;
	
	IBOutlet NSPreferencePane *oPrefPane;
	
	FWRule *mRuleInEdit;
	BOOL mDirtyFields;
}

- (IBAction)saveSheet:(id)sender;
- (IBAction)cancelSheet:(id)sender;
- (IBAction)popUpButtonChanged:(id)sender;


/**
 *	If OK gets pressed, this results in a callback of the method:
 *	- (void)sheetCreatedNewRule:(FWRule*)rule;
 *
 *	On cancel nothing will happen.
 */ 
- (void)createRuleAndCallback:(id)callback;

/**
 *	If the rule got modified, this will result in the following callback:
 *	- (void)sheetDidEditRule:(FWRule*)rule;
 *	
 *	If the user pressed cancel, this will be called:
 *	- (void)sheetCanceledEditRule:(FWRule*)rule;	
 */
- (void)editRule:(FWRule*)rule andCallback:(id)callback;


@end
