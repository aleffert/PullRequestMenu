//
//  PRMKeychainHelper.h
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRMKeychainHelper : NSObject

- (id)initWithServiceName:(NSString*)serviceName;

- (OSStatus)saveData:(NSData*)data;
- (NSData*)loadWithError:(OSStatus*)errorPtr;
- (OSStatus)clearData;

@end
