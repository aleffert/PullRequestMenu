//
//  PRMLoginLaunchController.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMLoginLaunchController.h"

@interface PRMLoginLaunchController ()

@property (assign, nonatomic) LSSharedFileListRef loginItemsListRef;
@property (strong, nonatomic) NSMenuItem* launchOnLoginItem;

- (void)loginItemsChanged:(LSSharedFileListRef)list;

@end

static void loginItemsChanged(LSSharedFileListRef listRef, void *context)
{
    PRMLoginLaunchController *controller = (__bridge PRMLoginLaunchController*)context;
    
    [controller loginItemsChanged:listRef];
}


@implementation PRMLoginLaunchController

- (id)init {
    self = [super init];
    if(self != nil) {
        self.launchOnLoginItem = [[NSMenuItem alloc] initWithTitle:@"Activate on Login" action:nil keyEquivalent:@""];
        [self setupLaunchServicesChecker];
        self.launchOnLoginItem.state = self.launchOnLogin;
    }
    
    return self;
}

- (NSArray *)loginItems
{
    CFArrayRef snapshotRef = LSSharedFileListCopySnapshot(self.loginItemsListRef, NULL);
    
    // Use toll-free bridging to get an NSArray with nicer API
    // and memory management.
    return (__bridge_transfer NSArray*)snapshotRef;
}

- (void)setupLaunchServicesChecker {
    self.loginItemsListRef = LSSharedFileListCreate(NULL,
                                                    kLSSharedFileListSessionLoginItems,
                                                    NULL);
    if (self.loginItemsListRef) {
        // Add an observer so we can update the UI if changed externally.
        LSSharedFileListAddObserver(self.loginItemsListRef,
                                    CFRunLoopGetMain(),
                                    kCFRunLoopCommonModes,
                                    loginItemsChanged,
                                    (__bridge void*)self);
    }
}

- (LSSharedFileListItemRef)copyMainBundleLoginItem CF_RETURNS_RETAINED
{
    NSArray *loginItems = [self loginItems];
    NSURL *bundleURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    for (id item in loginItems) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
        CFURLRef itemURLRef;
        
        if (LSSharedFileListItemResolve(itemRef, 0, &itemURLRef, NULL) == noErr) {
            // Again, use toll-free bridging.
            NSURL *itemURL = (__bridge_transfer NSURL *)itemURLRef;
            if ([itemURL isEqual:bundleURL]) {
                CFRetain(itemRef);
                return itemRef;
            }
        }
    }
    
    return NULL;
}

- (void)addMainBundleToLoginItems
{
    // We use the URL to the app itself (i.e. the main bundle).
    NSURL *bundleURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    LSSharedFileListItemRef itemRef;
    itemRef = LSSharedFileListInsertItemURL(self.loginItemsListRef,
                                            kLSSharedFileListItemLast,
                                            NULL,
                                            NULL,
                                            (__bridge CFURLRef)bundleURL,
                                            NULL,
                                            NULL);
    if (itemRef) {
        CFRelease(itemRef);
    }
}

- (void)removeMainBundleFromLoginItems
{
    // Try to get the item corresponding to the main bundle URL.
    LSSharedFileListItemRef itemRef = [self copyMainBundleLoginItem];
    if (!itemRef)
        return;
    
    LSSharedFileListItemRemove(self.loginItemsListRef, itemRef);
    
    CFRelease(itemRef);
}

- (BOOL)launchOnLogin
{
    if (!self.loginItemsListRef)
        return NO;
    
    LSSharedFileListItemRef itemRef = [self copyMainBundleLoginItem];
    if (!itemRef)
        return NO;
    
    CFRelease(itemRef);
    return YES;
}

- (void)setLaunchOnLogin:(BOOL)value
{
    if (!self.loginItemsListRef)
        return;
    
    if (!value) {
        [self removeMainBundleFromLoginItems];
    } else {
        [self addMainBundleToLoginItems];
    }
}

- (void)loginItemsChanged:(LSSharedFileListRef)list {
    self.launchOnLoginItem.state = self.launchOnLogin;
}

@end
