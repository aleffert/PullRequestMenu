//
//  PRMMenuView.h
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PRMMenuView : NSView <NSMenuDelegate>

@property (strong, nonatomic) NSString* text;

- (id)initWithFrame:(NSRect)frameRect statusItem:(NSStatusItem*)item;

@end
