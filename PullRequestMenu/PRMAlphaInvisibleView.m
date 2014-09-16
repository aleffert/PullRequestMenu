//
//  PRMAlphaInvisibleView.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/16/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMAlphaInvisibleView.h"

@implementation PRMAlphaInvisibleView

- (NSView*)hitTest:(NSPoint)aPoint {
    if(self.alphaValue == 0) {
        return nil;
    }
    else {
        return [super hitTest:aPoint];
    }
    
}

@end
