//
//  PRMAuthWindowController.h
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/16/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PRMAccountInfo;
@class PRMAuthWindowController;

@protocol PRMAuthControllerDelegate <NSObject>

- (void)authController:(PRMAuthWindowController*)windowController collectedAccountInfo:(PRMAccountInfo*)info;

@end


@interface PRMAuthWindowController : NSWindowController

@property (weak, nonatomic) id <PRMAuthControllerDelegate> delegate;

- (void)showGetTokenWithBaseURL:(NSString*)baseURL;
- (void)dismiss;

@end
