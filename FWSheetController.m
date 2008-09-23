//
//  FWSheetController.m
//  ipfwPane
//
//  Created by Torsten Becker on 21.09.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FWSheetController.h"


@implementation FWSheetController

- (void)addRule
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
