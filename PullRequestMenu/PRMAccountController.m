//
//  PRMAccountController.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMAccountController.h"

#import "PRMKeychainHelper.h"

NSString* const PRMAccountControllerChangedAccountNotification = @"PRMAccountControllerChangedAccountNotification";

@interface PRMAccountInfo () <NSCoding>

@end

@implementation PRMAccountInfo

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.baseURL = [aDecoder decodeObjectForKey:@"baseURL"];
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.enterprise = [aDecoder decodeBoolForKey:@"enterprise"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.baseURL forKey:@"baseURL"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeBool:self.enterprise forKey:@"enterprise"];
}

@end

@interface PRMAccountController ()

@property (strong, nonatomic) PRMAccountInfo* accountInfo;
@property (strong, nonatomic) PRMKeychainHelper* keychainHelper;

@end

@implementation PRMAccountController

- (id)init {
    self = [super init];
    if(self != nil) {
        NSString* serviceName = [NSString stringWithFormat:@"%@.account", [[NSBundle mainBundle] bundleIdentifier]];
        self.keychainHelper = [[PRMKeychainHelper alloc] initWithServiceName:serviceName];
        [self loadAccountInfoIfPossible];
    }
    return self;
}

- (void)loadAccountInfoIfPossible {
    OSStatus error = 0;
    NSData* data = [self.keychainHelper loadWithError:&error];
    if(data) {
        self.accountInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    if(error != errSecSuccess && error != errSecItemNotFound) {
        NSLog(@"Error loading keychain %ld", (long)error);
    }
}

- (void)saveAccountInfo:(PRMAccountInfo *)accountInfo {
    self.accountInfo = accountInfo;
    if(accountInfo) {
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:accountInfo];
        OSStatus error = [self.keychainHelper saveData:data];
        if(error != errSecSuccess) {
            NSLog(@"Error saving keychain %ld", (long)error);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:PRMAccountControllerChangedAccountNotification object:nil];
    }
}

- (void)clearAccountInfo {
    self.accountInfo = nil;
    OSStatus error = [self.keychainHelper clearData];
    if(error != errSecSuccess && error != errSecItemNotFound) {
        NSLog(@"Error clearing keychain %ld", (long)error);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PRMAccountControllerChangedAccountNotification object:nil];
}

- (NSString*)accessToken {
    return self.accountInfo.accessToken;
}

- (NSString*)apiURL {
    if(self.accountInfo.isEnterprise) {
        return [NSString stringWithFormat:@"https://%@/api/v3", self.accountInfo.baseURL];
    }
    else {
        return [NSString stringWithFormat:@"https://api.%@", self.accountInfo.baseURL];
    }
}

- (NSString*)baseURL {
    return self.accountInfo.baseURL;
}

- (BOOL)hasAccount {
    return self.accountInfo.accessToken != nil;
}

@end
