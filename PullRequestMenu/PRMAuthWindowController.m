//
//  PRMAuthWindowController.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/16/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMAuthWindowController.h"

@interface PRMAuthWindowController ()

@end

@implementation PRMAuthWindowController

- (void)showGetTokenWithBaseURL:(NSString*)baseURL {
    NSString* urlString = [NSString stringWithFormat:@"https://%@/settings/tokens/new", baseURL];
    NSURL* tokenURL = [NSURL URLWithString:urlString];
    [[NSWorkspace sharedWorkspace] openURL:tokenURL];
}

- (void)dismiss {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}

@end
