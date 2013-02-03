//
//  OPXGlobal.h
//  Octopics
//
//  Created by Atsushi Nagase on 2/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFGitHub.h"
#import "AFGitHubGlobal.h"

extern NSString *const kOPXDefaultsAccessTokenKey;
extern NSString *const kOPXDefaultsCurrentUserKey;
extern NSString *const kOPXDefaultsCurrentRepositoryKey;
extern NSString *const kOPXDefaultsCurrentHeadKey;
extern NSString *const kOPXNotificationNewPicture;

void OPXSetDefaultCacheOn();
void OPXSetDefaultCacheOff();