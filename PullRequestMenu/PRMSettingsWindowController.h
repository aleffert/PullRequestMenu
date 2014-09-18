//
//  PRMSettingsWindowController.h
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PRMAccountController;
@class PRMSettingsController;

@interface PRMSettingsWindowController : NSWindowController

@property (strong, nonatomic) PRMAccountController* accountController;
@property (strong, nonatomic) PRMSettingsController* settingsController;

- (void)show;

@end
