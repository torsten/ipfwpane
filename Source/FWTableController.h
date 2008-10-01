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
 * FWTableController.h, created on 20.09.2008.
 */

#import <Cocoa/Cocoa.h>


@class FWPrefPane;
@class FWipfwModel;
@class FWSheetController;


@interface FWTableController : NSObject
{
	IBOutlet NSTableColumn *oBoolColumn;
	IBOutlet NSTableColumn *oStringColumn;
	
	IBOutlet NSTableView *oTableView;
	
	IBOutlet FWPrefPane *oPrefPane;
	IBOutlet FWipfwModel *oModel;
	
	IBOutlet FWSheetController *oSheetController;
}

- (IBAction)removeSelectedRow:(id)sender;
- (IBAction)editSelectedRow:(id)sender;
- (IBAction)addItem:(id)sender;

/**
 *	Forces the model to reload its data and then reloads the table view.
 */
- (void)refreshTable;


@end
