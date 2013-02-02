//
//  AFGitHubAPIClient+Octopics.h
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "AFGitHubAPIClient.h"

@interface AFGitHubAPIClient (Octopics)

- (void)initRepository:(AFGitHubRepository *)repo
               success:(void (^)(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject))success
               failure:(void (^)(AFGitHubAPIRequestOperation *operation, NSError *error))failure;

@end
