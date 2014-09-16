//
//  PRMSettingsController.h
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PRMAccountController;

@interface PRMSettingsController : NSWindowController

@property (strong, nonatomic) PRMAccountController* accountController;

- (void)show;

@end
