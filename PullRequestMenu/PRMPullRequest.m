//
//  PRMPullRequest.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMPullRequest.h"

@implementation PRMPullRequest

+ (NSDate*)dateWithAPIString:(NSString*)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    return [formatter dateFromString:dateString];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[PRMPullRequest class]] && [[object url] isEqualToString:self.url];
}

- (NSUInteger)hash {
    return self.url.hash;
}

- (NSString*)repoName {
    NSArray* components = self.htmlURL.pathComponents;
    if(components.count > 3) {
        return components[components.count - 3];
    }
    return nil;
}

@end