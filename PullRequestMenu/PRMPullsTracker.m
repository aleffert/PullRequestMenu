//
//  PRMPullsTracker.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMPullsTracker.h"

#import "PRMAccountController.h"
#import "PRMPullRequest.h"
#import "PRMSettingsController.h"

@interface PRMPullsTracker ()

@property (assign, nonatomic) PRMPullsTrackerStatus status;
@property (strong, nonatomic) NSSet* knownRequests;
@property (assign, nonatomic) BOOL didInitialFetch;
@property (strong, nonatomic) NSURLSessionDataTask* loadTask;
@property (strong, nonatomic) PRMAccountController* accountController;
@property (strong, nonatomic) PRMSettingsController* settingsController;

@end

@implementation PRMPullsTracker

- (id)initWithAccountController:(PRMAccountController*)accountController settingsController:(PRMSettingsController *)settingsController {
    self = [super init];
    if(self != nil) {
        self.accountController = accountController;
        self.settingsController = settingsController;
        self.knownRequests = [[NSMutableSet alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanged:) name:PRMAccountControllerChangedAccountNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)accountChanged:(NSNotification*)notification {
    [self clearInfo];
}

- (void)clearInfo {
    self.didInitialFetch = NO;
    [self.loadTask cancel];
    [self setStatusNotifyingDelegate:PRMPullsTrackerStatusUnconfigured];
}

- (void)receivedIssues:(NSArray*)issues {
    NSMutableArray* foundRequests = [[NSMutableArray alloc] init];
    for(NSDictionary* issue in issues) {
        NSDictionary* prInfo = issue[@"pull_request"];
        if(prInfo) {
            PRMPullRequest* request = [[PRMPullRequest alloc] init];
            request.title = issue[@"title"];
            request.url = prInfo[@"url"];
            request.htmlURL = prInfo[@"html_url"];
            request.creationDate = [PRMPullRequest dateWithAPIString:issue[@"created_at"]];
            request.modificationDate = [PRMPullRequest dateWithAPIString:issue[@"updated_at"]];
            [foundRequests addObject:request];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL shouldPostNotification = [self.settingsController shouldShowLocalNotifications];
        for(PRMPullRequest* request in foundRequests) {
            if(![self.knownRequests containsObject:request]) {
                if(!self.didInitialFetch && shouldPostNotification) {
                    NSUserNotification* notification = [[NSUserNotification alloc] init];
                    notification.title = @"New Pull Request";
                    notification.informativeText = [NSString stringWithFormat:@"%@: %@", request.repoName, request.title];
                    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
                }
            }
        }
        self.knownRequests = [[NSMutableSet alloc] initWithArray:foundRequests];
        self.didInitialFetch = YES;
        
        [self setStatusNotifyingDelegate:PRMPullsTrackerStatusLoaded];
    });
}

- (void)setStatusNotifyingDelegate:(PRMPullsTrackerStatus)status {
    if([NSThread isMainThread]) {
        self.status = status;
        [self.delegate pullTrackerChangedState:self];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setStatusNotifyingDelegate:status];
        });
    }
}

- (void)fetchRequests {
    
    if(!self.accountController.hasAccount) {
        [self.loadTask cancel];
        [self setStatusNotifyingDelegate:PRMPullsTrackerStatusUnconfigured];
        return;
    }
    
    if(self.loadTask != nil) {
        return;
    }
    
    if(self.didInitialFetch) {
        [self setStatusNotifyingDelegate:PRMPullsTrackerStatusLoaded];
    }
    else {
        [self setStatusNotifyingDelegate:PRMPullsTrackerStatusLoading];
    }
    
    __weak __typeof(self) weakSelf = self;
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/issues?access_token=%@", self.accountController.apiURL, self.accountController.accessToken]];
    NSURLRequest* request = [NSURLRequest requestWithURL:requestURL];
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(weakSelf.loadTask.state == NSURLSessionTaskStateCanceling) {
            // do nothing
        }
        else if(error) {
            [weakSelf setStatusNotifyingDelegate:PRMPullsTrackerStatusConnectionError];
        }
        else {
            NSError* error = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if([result isKindOfClass:[NSDictionary class]]) {
                [weakSelf setStatusNotifyingDelegate:PRMPullsTrackerStatusBadCredentials];
            }
            else if(error) {
                [weakSelf setStatusNotifyingDelegate:PRMPullsTrackerStatusParseError];
            }
            else {
                [weakSelf receivedIssues:result];
            }
        }
        
        weakSelf.loadTask = nil;
    }];
    [task resume];
}

- (NSArray*)requests {
    return self.knownRequests.allObjects;
}

@end
