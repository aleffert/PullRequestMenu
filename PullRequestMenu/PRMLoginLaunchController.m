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
    SMAppService* service = [SMAppService loginItemServiceWithIdentifier:PRMLaunchHelperBundleID];
    return service.status == SMAppServiceStatusEnabled;
}

- (void)setLaunchOnLogin:(BOOL)value
{
    SMAppService* service = [SMAppService loginItemServiceWithIdentifier:PRMLaunchHelperBundleID];
    NSError* error = nil;
    BOOL success = value ? [service registerAndReturnError:&error] : [service unregisterAndReturnError:&error];
    if(!success) {
        NSLog(@"Error updating login item: %@", error);
    }
    self.launchOnLoginItem.state = value ? NSControlStateValueOn : NSControlStateValueOff;
}

@end
