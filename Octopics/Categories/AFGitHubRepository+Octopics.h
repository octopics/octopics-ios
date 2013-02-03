//
//  AFGitHubRepository+Octopics.h
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "AFGitHubRepository.h"

@interface AFGitHubRepository (Octopics)

- (NSURL *)indexJSONURL;
- (NSURL *)indexHTMLURL;

- (void)postImage:(UIImage *)image
      withMessage:(NSString *)message
          success:(void (^)(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject))success
          failure:(void (^)(AFGitHubAPIRequestOperation *operation, NSError *error))failure;

@end
