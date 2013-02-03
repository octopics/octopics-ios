//
//  OPXPictureMessageCell.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "OPXPictureMessageCell.h"

@implementation OPXPictureMessageCell


- (void)layoutSubviews {
  [super layoutSubviews];
  [self.textLabel setFrame:CGRectMake(10, 0, 300, 20)];
  [self.textLabel setNumberOfLines:2];
}

@end
