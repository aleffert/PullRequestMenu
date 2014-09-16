//
//  PRMLoginLaunchController.h
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface PRMLoginLaunchController : NSObject

@property (readonly, strong, nonatomic) NSMenuItem* launchOnLoginItem;
@property (assign, nonatomic) BOOL launchOnLogin;


@end
