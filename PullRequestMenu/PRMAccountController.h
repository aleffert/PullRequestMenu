//
//  PRMAccountController.h
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRMAccountInfo : NSObject

@property (strong, nonatomic) NSString* baseURL;
@property (strong, nonatomic) NSString* accessToken;
@property (assign, nonatomic, getter=isEnterprise) BOOL enterprise;

@end


@interface PRMAccountController : NSObject

- (void)saveAccountInfo:(PRMAccountInfo*)accountInfo;
- (void)clearAccountInfo;

@property (readonly, assign, nonatomic) BOOL hasAccount;

@property (readonly, nonatomic) NSString* baseURL;
@property (readonly, nonatomic) NSString* apiURL;
@property (readonly, nonatomic) NSString* accessToken;

@end

extern NSString* const PRMAccountControllerChangedAccountNotification;