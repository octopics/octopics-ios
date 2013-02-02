//
//  OPXAppDelegate.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "OPXAppDelegate.h"
#import "AFGitHubAPIKeys.h"
#import "OPXGlobal.h"
#import "OPXComposeViewController.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <BlocksKit/BlocksKit.h>

#define kMainTabBarControllerIdentifer @"MainTabBarController"
#define kLoginNavigationControllerIdentifer @"LoginNavigationController"

@implementation OPXAppDelegate

+ (OPXAppDelegate *)current {
  return (OPXAppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
  AFGitHubAPIClient *client = [AFGitHubAPIClient clientWithClientID:kAFGitHubClientID secret:kAFGitHubClientSecret];
  NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kOPSDefaultsAccessTokenKey];
  if(AFGitHubIsStringWithAnyText(accessToken))
    [client setAuthorizationHeaderWithToken:accessToken];
  [AFGitHubAPIClient setSharedClient:client];
  if([client isAuthenticated] && self.currentRepository) {
    [self showMain];
  } else {
    [self showLogin];
  }
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(didLogin:) name:AFGitHubNotificationAuthenticationSuccess object:nil];
  [nc addObserver:self selector:@selector(didLogout:) name:AFGitHubNotificationAuthenticationCleared object:nil];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -

#pragma mark - Switch View Controllers

- (UIViewController *)setRootViewControllerWithIdentifier:(NSString *)identifier {
  UIViewController *vc = [[self.window.rootViewController storyboard] instantiateViewControllerWithIdentifier:identifier];
  [self.window setRootViewController:vc];
  return vc;
}

- (void)showLogin {
  UINavigationController *nvc = (UINavigationController *)[self setRootViewControllerWithIdentifier:kLoginNavigationControllerIdentifer];
  self.loginViewController = (OPXLoginViewController *)nvc.topViewController;
}

- (void)showMain {
  UITabBarController *vc = (UITabBarController *)[self setRootViewControllerWithIdentifier:kMainTabBarControllerIdentifer];
  [vc setDelegate:self];
  self.tabBarController = vc;
}

- (void)confirmSourceType {
  UIActionSheet *as = [UIActionSheet actionSheetWithTitle:@"Selelct photo source"];
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    [as addButtonWithTitle:@"Camera" handler:^{
      [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    [as addButtonWithTitle:@"Photo Library" handler:^{
      [self showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
  [as setCancelButtonWithTitle:@"Cancel" handler:NULL];
  [as showFromTabBar:self.tabBarController.tabBar];
}

- (void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
  UIImagePickerController *vc = [[UIImagePickerController alloc] init];
  [vc setDelegate:self];
  [vc setSourceType:sourceType];
  [vc setAllowsEditing:YES];
  [self.tabBarController presentViewController:vc animated:YES completion:NULL];
}

#pragma mark - Session

#pragma mark - Notification Observer

- (void)didLogin:(NSNotification *)note {
  AFOAuthCredential *credential = note.userInfo[@"credential"];
  [[NSUserDefaults standardUserDefaults] setObject:credential.accessToken forKey:kOPSDefaultsAccessTokenKey];
}

- (void)didLogout:(NSNotification *)note {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kOPSDefaultsAccessTokenKey];
  self.currentHead = nil;
  self.currentRepository = nil;
  self.currentUser = nil;
  [self showLogin];
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
  if(viewController.tabBarItem.tag == 20) {
    [self confirmSourceType];
    return NO;
  }
  return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [picker dismissViewControllerAnimated:NO completion:^{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIViewController *rvc = [self.window rootViewController];
    UINavigationController *nvc = [rvc.storyboard instantiateViewControllerWithIdentifier:@"ComposeNavigationControler"];
    OPXComposeViewController *vc = (OPXComposeViewController *)[nvc topViewController];
    AFGitHubBlob *blob = [[AFGitHubBlob alloc] init];
    [blob setImageContent:image];
    [vc setPictureBlob:blob];
    [rvc presentViewController:nvc animated:NO completion:NULL];
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
