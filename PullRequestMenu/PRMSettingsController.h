//
//  PRMSettingsController.h
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/17/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PRMFilterMode) {
    PRMFilterModeAll,
    PRMFilterModeAssigned,
    PRMFilterModeCreated,
    PRMFilterModeMentioned,
    PRMFilterModeSubscribed,
};

@interface PRMSettingsController : NSObject

@property (assign, nonatomic) BOOL shouldShowLocalNotifications;
@property (assign, nonatomic) PRMFilterMode filterMode;

@property (readonly, nonatomic) NSString* filterModeString;

@end
