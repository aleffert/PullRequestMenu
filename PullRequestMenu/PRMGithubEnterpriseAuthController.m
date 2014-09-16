//
//  PRMGithubEnterpriseAuthController.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/16/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMGithubEnterpriseAuthController.h"

#import "PRMAccountController.h"

@interface PRMGithubEnterpriseAuthController () <NSTextFieldDelegate>

@property (strong, nonatomic) IBOutlet NSButton* saveButton;
@property (strong, nonatomic) IBOutlet NSButton* tokenButton;
@property (strong, nonatomic) IBOutlet NSTextField* tokenField;
@property (strong, nonatomic) IBOutlet NSTextField* serverField;

@end

@implementation PRMGithubEnterpriseAuthController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.saveButton setEnabled:NO];
}

- (IBAction)saveToken:(id)sender {
    PRMAccountInfo* accountInfo = [[PRMAccountInfo alloc] init];
    accountInfo.baseURL = self.serverField.stringValue;
    accountInfo.accessToken = self.tokenField.stringValue;
    accountInfo.enterprise = YES;
    
    [self.delegate authController:self collectedAccountInfo:accountInfo];
    
    [self dismiss];
}

- (IBAction)cancel:(id)sender {
    [self dismiss];
}

- (IBAction)getToken:(id)sender {
    [self showGetTokenWithBaseURL:self.serverField.stringValue];
}

- (void)validateButtons {
    [self.tokenButton setEnabled:self.serverField.stringValue.length > 0];
    [self.saveButton setEnabled:self.tokenButton.isEnabled && self.tokenField.stringValue.length > 0];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [self validateButtons];
}

@end
