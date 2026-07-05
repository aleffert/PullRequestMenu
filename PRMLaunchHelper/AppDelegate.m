//
//  AppDelegate.m
//  PRMLaunchHelper
//
//  Created by Akiva Leffert on 9/18/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    BOOL alreadyRunning = NO;
    NSArray *running = [[NSWorkspace sharedWorkspace] runningApplications];
    for (NSRunningApplication *app in running) {
        if ([[app bundleIdentifier] isEqualToString:@"com.ognid.PullRequestMenu"]) {
            alreadyRunning = YES;
        }
    }
    
    if (!alreadyRunning) {
        // The helper lives at .../PullRequestMenu.app/Contents/Library/LoginItems/PRMLaunchHelper.app.
        // Strip the last four path components to get the main app bundle.
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[path pathComponents]];
        [pathComponents removeLastObject]; // PRMLaunchHelper.app
        [pathComponents removeLastObject]; // LoginItems
        [pathComponents removeLastObject]; // Library
        [pathComponents removeLastObject]; // Contents
        NSString *mainAppPath = [NSString pathWithComponents:pathComponents];
        NSURL *mainAppURL = [NSURL fileURLWithPath:mainAppPath];

        NSWorkspaceOpenConfiguration *configuration = [NSWorkspaceOpenConfiguration configuration];
        [[NSWorkspace sharedWorkspace] openApplicationAtURL:mainAppURL configuration:configuration completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error launching PullRequestMenu: %@", error);
            }
            [NSApp terminate:nil];
        }];
    }
    else {
        [NSApp terminate:nil];
    }
}


@end
