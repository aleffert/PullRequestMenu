//
//  PRMPullRequest.h
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRMPullRequest : NSObject

+ (NSDate*)dateWithAPIString:(NSString*)dateString;

@property (copy, nonatomic) NSString* htmlURL;
@property (copy, nonatomic) NSString* url;
@property (copy, nonatomic) NSString* title;
@property (strong, nonatomic) NSDate* creationDate;
@property (strong, nonatomic) NSDate* modificationDate;

/// This is inferred from the URL. Returns nil if the repo can't be determined
@property (strong, nonatomic) NSString* repoName;

@end
