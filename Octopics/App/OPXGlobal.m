//
//  OPXGlobal.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "OPXGlobal.h"

NSString *const kOPXDefaultsAccessTokenKey = @"OPXDefaultsAccessToken";
NSString *const kOPXDefaultsCurrentUserKey = @"OPXDefaultsCurrentUser";
NSString *const kOPXDefaultsCurrentRepositoryKey = @"OPXDefaultsCurrentRepository";
NSString *const kOPXDefaultsCurrentHeadKey = @"OPXDefaultsCurrentHead";
NSString *const kOPXNotificationNewPicture = @"OPXNotificationNewPicture";

void OPXSetDefaultCacheOff() {
  [NSURLCache setSharedURLCache:[[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil]];
}

void OPXSetDefaultCacheOn() {
  [NSURLCache setSharedURLCache:[[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil]];
}