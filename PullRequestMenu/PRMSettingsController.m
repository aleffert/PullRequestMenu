//
//  PRMSettingsController.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/17/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMSettingsController.h"

static NSString* const PRMHideNotificationsKey = @"PRMHideNotificationsKey";
static NSString* const PRMFilterModeKey = @"PRMFilterModeKey";

static NSString* const PRMGithubFilterAssigned = @"assigned";
static NSString* const PRMGithubFilterCreated = @"created";
static NSString* const PRMGithubFilterMentioned = @"mentioned";
static NSString* const PRMGithubFilterSubscribed = @"subscribed";
static NSString* const PRMGithubFilterAll = @"all";


@implementation PRMSettingsController

- (BOOL)shouldShowLocalNotifications {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:PRMHideNotificationsKey];
}

- (void)setShouldShowLocalNotifications:(BOOL)shouldShowLocalNotifications {
    [[NSUserDefaults standardUserDefaults] setBool:!shouldShowLocalNotifications forKey:PRMHideNotificationsKey];
}

- (NSString*)filterModeString {
    return [[NSUserDefaults standardUserDefaults] objectForKey:PRMFilterModeKey] ?: PRMGithubFilterAssigned;
}

- (NSDictionary*)filterMap {
    
    return @{
             PRMGithubFilterAssigned : @(PRMFilterModeAssigned),
             PRMGithubFilterCreated : @(PRMFilterModeCreated),
             PRMGithubFilterMentioned : @(PRMFilterModeMentioned),
             PRMGithubFilterSubscribed : @(PRMFilterModeSubscribed),
             PRMGithubFilterAll : @(PRMFilterModeAll),
             };
    
}

- (PRMFilterMode)filterMode {
    return [[self filterMap][self.filterModeString] integerValue];
}

- (void)setFilterMode:(PRMFilterMode)filterMode {
    NSDictionary* filterMap = [self filterMap];
    __block NSString* filterModeString = nil;
    [filterMap enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSNumber* value, BOOL *stop) {
        if([value isEqualToNumber:@(filterMode)]) {
            filterModeString = key;
        }
    }];
    [[NSUserDefaults standardUserDefaults] setObject:filterModeString forKey:PRMFilterModeKey];
}

@end
