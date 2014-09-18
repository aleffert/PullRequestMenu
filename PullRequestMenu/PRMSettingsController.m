//
//  PRMSettingsController.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/17/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMSettingsController.h"

static NSString* const PRMHideNotificationsKey = @"PRMHideNotificationsKey";

@implementation PRMSettingsController

- (BOOL)shouldShowLocalNotifications {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:PRMHideNotificationsKey];
}

- (void)setShouldShowLocalNotifications:(BOOL)shouldShowLocalNotifications {
    [[NSUserDefaults standardUserDefaults] setBool:!shouldShowLocalNotifications forKey:PRMHideNotificationsKey];
}

@end
