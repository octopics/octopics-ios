//
//  OPXPictureImageCell.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "OPXPictureImageCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation OPXPictureImageCell

- (void)setImageURL:(NSURL *)imageURL {
  NSURLRequest *req = [NSURLRequest requestWithURL:imageURL];
  __weak OPXPictureImageCell *cell = self;
  [self.imageView
   setImageWithURLRequest:req placeholderImage:nil
   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
     [cell.imageView setImage:image];
     [cell setNeedsLayout];
   }
   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
   }];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.imageView setFrame:CGRectMake(10, 10, 300, 300)];
}

@end
