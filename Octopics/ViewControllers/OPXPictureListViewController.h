//
//  OPXPictureListViewController.h
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFGitHubRepository;
@interface OPXPictureListViewController : UITableViewController

@property (nonatomic, copy) AFGitHubRepository *repository;

@end
