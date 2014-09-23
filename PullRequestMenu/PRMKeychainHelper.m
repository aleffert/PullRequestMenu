//
//  PRMKeychainHelper.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMKeychainHelper.h"

@interface PRMKeychainHelper ()

@property (strong, nonatomic) NSString* serviceName;
@property (strong, nonatomic) NSString* account;

@end

@implementation PRMKeychainHelper

- (id)initWithServiceName:(NSString*)serviceName account:(NSString*)account {
    self = [super init];
    self.serviceName = serviceName;
    self.account = account;
    return self;
}

- (OSStatus)clearData {
    
    CFDictionaryRef keychainQuery = (__bridge_retained CFDictionaryRef)
    @{
      (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
      (__bridge id)kSecAttrService : self.serviceName,
      (__bridge id)kSecAttrAccount : self.account,
      (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne,
      };
    
    OSStatus status = SecItemDelete(keychainQuery);
    
    CFRelease(keychainQuery);
    return status;
}

- (OSStatus)saveData:(NSData*)data {
    OSStatus status = [self clearData];
    if(status != errSecSuccess && status != errSecItemNotFound) {
        return status;
    }
    
    CFDictionaryRef keychainQuery = (__bridge_retained CFDictionaryRef)
    @{
      (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
      (__bridge id)kSecAttrService : self.serviceName,
      (__bridge id)kSecAttrAccount : self.account,
      (__bridge id)kSecValueData : data
      };
    status = SecItemAdd(keychainQuery, nil);
    if(status != errSecSuccess) {
        CFRelease(keychainQuery);
        return status;
    }
    
    CFRelease(keychainQuery);
    return errSecSuccess;
}

- (NSData*)loadWithError:(OSStatus*)errorPtr {
    CFDictionaryRef keychainQuery = (__bridge_retained CFDictionaryRef)
    @{
      (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
      (__bridge id)kSecAttrService : self.serviceName,
      (__bridge id)kSecAttrAccount : self.account,
      (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue,
      (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne
      };
    
    CFTypeRef result = NULL;
    OSStatus error = SecItemCopyMatching(keychainQuery, &result);
    
    if(errorPtr != nil) {
        *errorPtr = error;
    }
    
    return (__bridge_transfer NSData*)result;
}

@end
