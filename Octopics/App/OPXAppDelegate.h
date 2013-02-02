//
//  OPXAppDelegate.h
//  Octopics
//
//  Created by Atsushi Nagase on 2/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFGitHubRepository, AFGitHubCommit ,AFGitHubUser, OPXLoginViewController;
@interface OPXAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) OPXLoginViewController *loginViewController;
@property (copy, nonatomic) AFGitHubCommit *currentHead;
@property (copy, nonatomic) AFGitHubRepository *currentRepository;
@property (copy, nonatomic) AFGitHubUser *currentUser;

+ (OPXAppDelegate *)current;
- (void)showMain;
- (void)showLogin;

@end
