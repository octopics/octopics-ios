//
//  AFGitHubRepository+Octopics.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "AFGitHubRepository+Octopics.h"
#import "AFGIthub.h"
#import "OPXAppDelegate.h"
#import "NSDate+InternetDateTime.h"
#import <GRMustache/GRMustache.h>

@implementation AFGitHubRepository (Octopics)

- (NSURL *)indexJSONURL {
  return [NSURL URLWithString:@"octopics.json" relativeToURL:self.gitHubPagesURL];
}

- (NSURL *)indexHTMLURL {
  return [NSURL URLWithString:@"index.html" relativeToURL:self.gitHubPagesURL];
}

- (void)postImage:(UIImage *)image
      withMessage:(NSString *)message
          success:(void (^)(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject))success
          failure:(void (^)(AFGitHubAPIRequestOperation *operation, NSError *error))failure {
  AFGitHubBlob *pictureBlob = [[AFGitHubBlob alloc] init];
  [pictureBlob setJPEGImageContent:image withCompressionQuality:0.7];
  [self
   createBlob:pictureBlob
   success:^(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject) {
     NSMutableDictionary *dict = @{}.mutableCopy;
     pictureBlob.SHA = [[responseObject first] SHA];
     pictureBlob.path = [NSString stringWithFormat:@"pic/%@.jpg", pictureBlob.SHA];
     dict[@"message"] = message;
     dict[@"image_url"] = [[NSURL URLWithString:pictureBlob.path relativeToURL:self.gitHubPagesURL] absoluteString];
     AFGitHubBlob *htmlBlob = [[AFGitHubBlob alloc]
                               initWithContent:nil
                               mode:AFGitHubDataModeFile
                               path:[NSString stringWithFormat:@"%@.html", pictureBlob.SHA]];
     dict[@"permalink"] = [[NSURL URLWithString:htmlBlob.path relativeToURL:self.gitHubPagesURL] absoluteString];
     dict[@"sha"] = pictureBlob.SHA;
     dict[@"created_at"] = [[NSDate date] rfc3339String];
     NSError *error = nil;
     NSString *htmlContent = [GRMustacheTemplate renderObject:dict fromResource:@"Page" bundle:nil error:&error];
     if(error) {
       failure(nil, error);
       return;
     }
     htmlBlob.content = htmlContent;
     NSURLRequest *req = [NSURLRequest requestWithURL:self.indexJSONURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:0];
     AFJSONRequestOperation *op =
     [AFJSONRequestOperation
      JSONRequestOperationWithRequest:req
      success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *buf = nil;
        if([JSON isKindOfClass:[NSArray class]]) {
          buf = [JSON mutableCopy];
        } else {
          buf = @[].mutableCopy;
        }
        [buf insertObject:dict atIndex:0];
        NSError *error;
        AFGitHubBlob *jsonBlob = [self indexJSONBlobWithArray:buf error:&error];
        [self commitBlobs:@[pictureBlob, jsonBlob, htmlBlob] withMessage:message success:success failure:failure];
      }
      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        AFGitHubBlob *jsonBlob = [self indexJSONBlobWithArray:@[dict] error:&error];
        [self commitBlobs:@[pictureBlob, jsonBlob, htmlBlob] withMessage:message success:success failure:failure];
      }];
     [op setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
       return nil;
     }];
     [op start];
   } failure:failure];
}

- (AFGitHubBlob *)indexJSONBlobWithArray:(NSArray *)array error:(NSError **)error {
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:error];
  NSString *jsonString = jsonData ? [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] : @"[]";
  AFGitHubBlob *jsonBlob = [[AFGitHubBlob alloc] initWithContent:jsonString
                                                            mode:AFGitHubDataModeFile
                                                            path:@"octopics.json"];
  return jsonBlob;
}

- (void)commitBlobs:(NSArray *)blobs withMessage:(NSString *)message
            success:(void (^)(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject))success
            failure:(void (^)(AFGitHubAPIRequestOperation *operation, NSError *error))failure {
  [self
   getReference:self.gitHubPageRefString
   success:^(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject) {
     AFGitHubReference *ref = responseObject.first;
     [self getCommitWithSHA:ref.object.SHA success:^(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject) {
       AFGitHubCommit *baseCommit =responseObject.first;
       AFGitHubTree *tree = [baseCommit.tree createTreeWithAddingBlobs:blobs];
       [self
        createTree:tree
        success:^(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject) {
          AFGitHubCommit *commit = [[AFGitHubCommit alloc] init];
          commit.tree = responseObject.first;
          commit.tree.baseTree = baseCommit.tree;
          commit.message = message;
          commit.parents = @[baseCommit];
          [self
           createCommit:commit
           success:^(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject) {
             ref.object = responseObject.first;
             [self updateReference:ref force:NO success:success failure:failure];
           }
           failure:failure];
        }
        failure:failure];
     } failure:failure];
   }
   failure:failure];

}

@end