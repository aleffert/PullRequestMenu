//
//  PRMPullsTracker.h
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRMPullsTracker;

@class PRMAccountController;
@class PRMSettingsController;

extern NSString* const PRMPullNotificationURL;

@protocol PRMPullsTrackerDelegate <NSObject>

- (void)pullTrackerChangedState:(PRMPullsTracker*)tracker;

@end

typedef NS_ENUM(NSUInteger, PRMPullsTrackerStatus) {
    PRMPullsTrackerStatusUnconfigured,
    PRMPullsTrackerStatusLoading,
    PRMPullsTrackerStatusLoaded,
    PRMPullsTrackerStatusBadCredentials,
    PRMPullsTrackerStatusParseError,
    PRMPullsTrackerStatusConnectionError
};


@interface PRMPullsTracker : NSObject

- (id)initWithAccountController:(PRMAccountController*)accountController settingsController:(PRMSettingsController*)settingsController;

@property (weak, nonatomic) id <PRMPullsTrackerDelegate> delegate;

- (void)fetchRequests;

@property (assign, readonly, nonatomic) PRMPullsTrackerStatus status;

/// Array of PRMPullRequest
@property (readonly, nonatomic) NSArray* requests;

@end
