//
//  PRMSettingsController.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMSettingsController.h"

#import "PRMAccountController.h"
#import "PRMGithubEnterpriseAuthController.h"
#import "PRMPublicGithubAuthController.h"

@interface PRMSettingsController () <PRMAuthControllerDelegate>

@property (strong, nonatomic) IBOutlet NSView* noAccountsView;
@property (strong, nonatomic) IBOutlet NSView* disconnectView;
@property (strong, nonatomic) IBOutlet NSTextField* infoLabel;
@property (strong, nonatomic) NSMutableArray* childControllers;

@end

@implementation PRMSettingsController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.childControllers = [[NSMutableArray alloc] init];
}

- (void)show {
    if(!self.window.isVisible) {
        [self.window.contentView addSubview:self.noAccountsView];
        [self.window.contentView addSubview:self.disconnectView];
        if(!self.accountController.hasAccount) {
            [self transitionBodyToView:self.noAccountsView animated:NO];
        }
        else {
            [self transitionBodyToView:self.disconnectView animated:NO];
        }
    }
    
    
    [self.window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)showAuthController:(PRMAuthWindowController*)controller {
    controller.delegate = self;
    [self.childControllers addObject:controller];
    [self.window beginSheet:controller.window completionHandler:^(NSModalResponse returnCode) {
        [self.childControllers removeObject:controller];
    }];

}

- (IBAction)configurePublicGithub:(id)sender {
    PRMPublicGithubAuthController* controller = [[PRMPublicGithubAuthController alloc] initWithWindowNibName:@"PRMPublicGithubAuthController"];
    [self showAuthController:controller];
}

- (IBAction)configureGithubEnterprise:(id)sender {
    PRMGithubEnterpriseAuthController* controller = [[PRMGithubEnterpriseAuthController alloc] initWithWindowNibName:@"PRMGithubEnterpriseAuthController"];
    [self showAuthController:controller];
}

- (void)authController:(PRMAuthWindowController*)controller collectedAccountInfo:(PRMAccountInfo *)info {
    [self.accountController saveAccountInfo:info];
    [self transitionBodyToView:self.disconnectView animated:YES];
}

- (IBAction)disconnect:(id)sender {
    [self.accountController clearAccountInfo];
    [self transitionBodyToView:self.noAccountsView animated:YES];
}

- (void)transitionBodyToView:(NSView*)view animated:(BOOL)animated {
    self.infoLabel.stringValue = [NSString stringWithFormat:@"Connected to %@", self.accountController.baseURL];
    
    for(NSView* child in [self.window.contentView subviews]) {
        NSView* current = animated ? [child animator] : child;
        [current setAlphaValue:!!(view == child)];
    }
    NSSize contentSize = view.bounds.size;
    
    NSWindow* window = animated ? [self.window animator] : self.window;
    
    [window setContentSize:contentSize];
    [window.contentView addSubview:view];

}

@end
