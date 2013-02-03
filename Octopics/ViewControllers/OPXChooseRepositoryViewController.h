//
//  OPXChooseRepositoryViewController.h
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFGitHubRepositoryListViewController.h"

@class AFGitHubUser;
@interface OPXChooseRepositoryViewController : AFGitHubRepositoryListViewController

@property (nonatomic, copy) AFGitHubUser *user;

@end
