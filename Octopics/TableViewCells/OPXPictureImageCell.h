//
//  OPXPictureImageCell.h
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPXPictureImageCell : UITableViewCell

@property (nonatomic, copy) NSURL *imageURL;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end
