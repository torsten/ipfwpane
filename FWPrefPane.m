//
//  FWPrefPane.m
//  ipfwPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

#import "FWPrefPane.h"


@implementation FWPrefPane

- (void)mainViewDidLoad
{
	[self setUpIcon];
}

- (void)setUpIcon
{
	NSLog(@"setUpIcon");
	
	// NSImage *img = [NSImage imageNamed:@"ipfwPanePref.png"];
	
	NSString* path = [[self bundle] pathForResource:@"ipfwPanePref" ofType:@"png"];
	
	// NSString *path = [[NSBundle mainBundle] pathForResource:@"ipfwPanePref"
	// 	ofType:@"png"];
	
	NSLog(@"path: %@", path);
	
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:path];
	[img setScalesWhenResized:YES];
	
	
	NSLog(@"width: %f", [img size].width);
	
	// INFO((@"...", ...))
	
	[oIconView setImageScaling:NSScaleToFit];
	
	[oIconView setImage:img];
}

- (IBAction)toggleFirewall:(id)pSender
{
	
}

- (IBAction)addItem:(id)pSender
{
	
}

- (IBAction)removeItem:(id)pSender
{
	
}



@end
