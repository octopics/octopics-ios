//
//  AFGitHubAPIClient+Octopics.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "AFGitHubAPIClient+Octopics.h"
#import "AFGitHub.h"

@implementation AFGitHubAPIClient (Octopics)

- (void)initRepository:(AFGitHubRepository *)repo
               success:(void (^)(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject))success
               failure:(void (^)(AFGitHubAPIRequestOperation *operation, NSError *error))failure {
  [self
   createRepository:repo
   withTeamId:0
   autoInit:YES
   gitIgnoreTemplate:nil
   success:^(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject) {
     AFGitHubTree *tree = [[AFGitHubTree alloc] init];
     tree.objects =
     @[
       [[AFGitHubBlob alloc] initWithContent:@"[]" mode:nil path:@"octopics.json"],
       [[AFGitHubBlob alloc] initWithContent:@"<h1>It works</h1>" mode:nil path:@"index.html"]
       ].mutableCopy;
     AFGitHubRepository *repo = responseObject.first;
     [self
      createCommitWithTree:tree
      forRef:repo.gitHubPageRefString
      message:@"Initial commit from [Octopics](http://octopics.org/)."
      force:YES repository:repo
      success:success failure:failure];
   }
   failure:failure];
}

- (void)postPictureBlob:(AFGitHubBlob *)blob withMessage:(NSString *)message {
  
}


@end
