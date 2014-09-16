//
//  PRMPublicGithubAuthController.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMPublicGithubAuthController.h"

#import "PRMAccountController.h"

@interface PRMPublicGithubAuthController () <NSTextFieldDelegate>

@property (strong, nonatomic) IBOutlet NSButton* saveButton;
@property (strong, nonatomic) IBOutlet NSTextField* tokenField;

@end

@implementation PRMPublicGithubAuthController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.saveButton setEnabled:NO];
}

- (IBAction)saveToken:(id)sender {
    PRMAccountInfo* accountInfo = [[PRMAccountInfo alloc] init];
    accountInfo.baseURL = @"github.com";
    accountInfo.accessToken = self.tokenField.stringValue;
    accountInfo.enterprise = NO;
    
    [self.delegate authController:self collectedAccountInfo:accountInfo];
    
    [self dismiss];
}

- (IBAction)cancel:(id)sender {
    [self dismiss];
}

- (IBAction)getToken:(id)sender {
    NSURL* tokenURL = [NSURL URLWithString:@"https://github.com/settings/applications#personal-access-tokens"];
    [[NSWorkspace sharedWorkspace] openURL:tokenURL];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [self.saveButton setEnabled:self.tokenField.stringValue.length > 0];
}

@end
