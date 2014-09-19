//
//  PRMLoginLaunchController.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMLoginLaunchController.h"

#import <ServiceManagement/ServiceManagement.h>

static NSString* PRMLaunchHelperBundleID = @"com.ognid.PRMLaunchHelper";

@interface PRMLoginLaunchController ()

@property (strong, nonatomic) NSMenuItem* launchOnLoginItem;

@end

@implementation PRMLoginLaunchController

- (id)init {
    self = [super init];
    if(self != nil) {
        self.launchOnLoginItem = [[NSMenuItem alloc] initWithTitle:@"Activate on Login" action:nil keyEquivalent:@""];
        self.launchOnLoginItem.state = self.launchOnLogin;
    }
    
    return self;
}

- (BOOL)launchOnLogin
{
    NSArray* jobs = (__bridge_transfer NSArray*)SMCopyAllJobDictionaries(kSMDomainUserLaunchd);

    for (NSDictionary* job in jobs) {
        NSString* label = job[@"Label"];
        if ([label rangeOfString:PRMLaunchHelperBundleID].location != NSNotFound) {
            return [job[@"OnDemand"] boolValue];
        }
    }
    return NO;
}

- (void)setLaunchOnLogin:(BOOL)value
{
    SMLoginItemSetEnabled((__bridge CFStringRef)PRMLaunchHelperBundleID, value);
    self.launchOnLoginItem.state = value;
}

@end
