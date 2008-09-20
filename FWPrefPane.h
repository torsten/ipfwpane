//
//  FWPrefPane.h
//  FWPrefPane
//
//  Created by Torsten Becker on 20.09.08.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>


@interface FWPrefPane : NSPreferencePane 
{
	IBOutlet NSImageView *oIconView;
}

- (void)mainViewDidLoad;

- (void)setUpIcon;

@end
