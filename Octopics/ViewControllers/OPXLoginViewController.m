//
//  OPXLoginViewController.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "OPXLoginViewController.h"
#import "OPXGlobal.h"
#import "OPXAppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <BlocksKit/BlocksKit.h>

@interface OPXLoginViewController ()

@end

@implementation OPXLoginViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter]
   addObserver:self selector:@selector(didLogin:)
   name:AFGitHubNotificationAuthenticationSuccess
   object:nil];
}

- (void)viewDidUnload {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didLogin:(NSNotification *)note {
  [SVProgressHUD showWithStatus:@"Loading information..."
                       maskType:SVProgressHUDMaskTypeGradient];
  [[AFGitHubAPIClient sharedClient]
   getUserWithSuccess:^(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject) {
     [[OPXAppDelegate current] setCurrentUser:responseObject.first];
     UIActionSheet *as = [UIActionSheet actionSheetWithTitle:nil];
     [as addButtonWithTitle:@"Create new repository" handler:^{
       [self performSegueWithIdentifier:@"CreateRepositorySegue" sender:self];
     }];
     [as addButtonWithTitle:@"Choose repository" handler:^{
       [self performSegueWithIdentifier:@"ChooseRepositorySegue" sender:self];
     }];
     [as setCancelButtonWithTitle:@"Cancel" handler:NULL];
     [as showInView:self.view];
   } failure:^(AFGitHubAPIRequestOperation *operation, NSError *error) {
     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
   }];
}


@end
