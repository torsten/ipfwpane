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
 * FWPrefPane.h, created on 20.09.2008.
 */

#import <PreferencePanes/PreferencePanes.h>


@class SFAuthorizationView;
@class FWTableController;
@class FWipfwModel;


@interface FWPrefPane : NSPreferencePane 
{
	IBOutlet NSImageView *oIconView;
	IBOutlet SFAuthorizationView *oAuthorizationView;
	
	IBOutlet NSTableView *oTableView;
	
	IBOutlet FWTableController *oTableController;
	IBOutlet FWipfwModel *oModel;
	
	IBOutlet NSTextField *oCreditsField;
	
	BOOL uiIsEnabled;
	BOOL tableIsEnabled;
	BOOL modifyButtonsAreEnabled;
}

@property BOOL uiIsEnabled;
@property BOOL tableIsEnabled;
@property BOOL modifyButtonsAreEnabled;

/**
 *	This method just toggle the UI enable/disable status, the actions on
 *	the model are triggered through the connection in interface builder.
 */
- (IBAction)toggleFirewall:(id)sender;

@end


@interface FWPrefPane (Private)
- (void)enableUI:(BOOL)enabled;
- (void)enableTable:(BOOL)enabled;
- (void)enableModifyButtons:(BOOL)enabled;
- (void)setUpIcon;
- (void)patchVersionStrings;

@end
