//
//  PRMAppDelegate.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMAppDelegate.h"

#import "PRMAccountController.h"
#import "PRMLoginLaunchController.h"
#import "PRMMenuView.h"
#import "PRMPullRequest.h"
#import "PRMPullsTracker.h"
#import "PRMSettingsController.h"

static CGFloat PRMNormalPollInterval = 5 * 60; // default is five minutes

@interface PRMAppDelegate () <PRMPullsTrackerDelegate, NSApplicationDelegate>

@property (strong, nonatomic) NSMenu* statusMenu;
@property (strong, nonatomic) NSStatusItem* item;
@property (strong, nonatomic) PRMMenuView* itemView;

@property (strong, nonatomic) PRMAccountController* accountController;
@property (strong, nonatomic) PRMLoginLaunchController* launchController;

@property (strong, nonatomic) PRMSettingsController* settingsController;

@property (strong, nonatomic) PRMPullsTracker* pullsTracker;

@end

@implementation PRMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.itemView = [[PRMMenuView alloc] initWithFrame:NSMakeRect(0, 0, 20, 20) statusItem:self.item];
    [self.item setView:self.itemView];
    
    self.launchController = [[PRMLoginLaunchController alloc] init];
    [self.launchController.launchOnLoginItem setAction:@selector(toggleActivateOnLogin:)];
    
    self.accountController = [[PRMAccountController alloc] init];
    
    self.pullsTracker = [[PRMPullsTracker alloc] initWithAccountController:self.accountController];
    self.pullsTracker.delegate = self;
    
    
    self.statusMenu = [[NSMenu alloc] initWithTitle:@""];
    [self.item setMenu:self.statusMenu];
    
    self.itemView.text = @" ";
    [self rebuildMenu];
    
    self.settingsController = [[PRMSettingsController alloc] initWithWindowNibName:@"PRMSettingsController"];
    self.settingsController.accountController = self.accountController;
    
    [self spawnTimer];
}

// This is kind of a terrible way to solve this problem. We should really listen to account changed notifications
- (void)spawnTimer {
    NSTimeInterval interval = PRMNormalPollInterval;
    if(self.accountController.hasAccount && self.pullsTracker.status == PRMPullsTrackerStatusUnconfigured) {
        interval = 1;
    }
    else if(!self.accountController.hasAccount) {
        interval = 10;
    }
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(poll:) userInfo:nil repeats:NO];
}

- (void)poll:(NSTimer*)timer {
    [self.pullsTracker fetchRequests];
    [self spawnTimer];
}

#pragma mark Menu Actions


- (void)toggleActivateOnLogin:(NSMenuItem*)sender {
    self.launchController.launchOnLogin = !self.launchController.launchOnLogin;
}

- (void)configure:(NSMenuItem*)sender {
    [self.settingsController show];
}

- (void)openURLForRequestItem:(NSMenuItem*)item {
    PRMPullRequest* request = item.representedObject;
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:request.htmlURL]];
}

#pragma mark Menu Control

- (void)addRequests:(NSArray*)requests toMenu:(NSMenu*)menu {
    NSArray* sortedRequests = [requests sortedArrayUsingComparator:^NSComparisonResult(PRMPullRequest* request, PRMPullRequest* otherRequest) {
        return [otherRequest.modificationDate compare: request.modificationDate];
    }];
    for(PRMPullRequest* request in sortedRequests) {
        NSMutableString* title = [[NSMutableString alloc] init];
        
        NSString* repoName = request.repoName;
        if(repoName != nil) {
            [title appendString:repoName];
            [title appendString:@": "];
        }
        
        [title appendString:[request.title substringToIndex:MIN(40, request.title.length)]];
        if(title.length < request.title.length) {
            [title appendString:@"…"];
        }
        NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:title action:@selector(openURLForRequestItem:) keyEquivalent:@""];
        item.representedObject = request;
        [menu addItem:item];
    }
}

- (void)rebuildMenu {
    [self.statusMenu removeAllItems];
    
    [self.statusMenu addItemWithTitle:@"Configure…" action:@selector(configure:) keyEquivalent:@""];
    [self.statusMenu addItem:self.launchController.launchOnLoginItem];
    [self.statusMenu addItemWithTitle:@"Quit PullRequestMenu" action:@selector(terminate:) keyEquivalent:@""];
    
    switch (self.pullsTracker.status) {
        case PRMPullsTrackerStatusUnconfigured:
            break;
        case PRMPullsTrackerStatusBadCredentials:
            [self.statusMenu addItemWithTitle:@"Bad Credentials" action:nil keyEquivalent:@""];
            [self.statusMenu addItem:[NSMenuItem separatorItem]];
            break;
        case PRMPullsTrackerStatusConnectionError:
            [self.statusMenu addItemWithTitle:@"Connection Error" action:nil keyEquivalent:@""];
            [self.statusMenu addItem:[NSMenuItem separatorItem]];
            break;
        case PRMPullsTrackerStatusLoading:
            [self.statusMenu addItemWithTitle:@"Loading…" action:nil keyEquivalent:@""];
            [self.statusMenu addItem:[NSMenuItem separatorItem]];
            break;
        case PRMPullsTrackerStatusParseError:
            [self.statusMenu addItemWithTitle:@"Response Error" action:nil keyEquivalent:@""];
            [self.statusMenu addItem:[NSMenuItem separatorItem]];
            break;
        case PRMPullsTrackerStatusLoaded: {
            [self.statusMenu addItem:[NSMenuItem separatorItem]];
            if(self.pullsTracker.requests.count == 0) {
                [self.statusMenu addItemWithTitle:@"No Assigned Requests" action:nil keyEquivalent:@""];
            }
            else {
                [self addRequests:self.pullsTracker.requests toMenu:self.statusMenu];
            }
            break;
        }
    }
    
}

- (void)pullTrackerChangedState:(PRMPullsTracker *)tracker {
    [self rebuildMenu];
    NSString* itemText = ^{
        switch (tracker.status) {
            case PRMPullsTrackerStatusUnconfigured: return @" ";
            case PRMPullsTrackerStatusBadCredentials: return @"?";
            case PRMPullsTrackerStatusConnectionError: return @"?";
            case PRMPullsTrackerStatusParseError: return @"?";
            case PRMPullsTrackerStatusLoading: return @" ";
            case PRMPullsTrackerStatusLoaded: return [NSString stringWithFormat:@"%ld", (long)tracker.requests.count];
        }
    }();
    self.itemView.text = itemText;
}

@end
