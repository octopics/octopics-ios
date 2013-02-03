//
//  OPXComposeViewController.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "OPXComposeViewController.h"
#import "OPXGlobal.h"
#import "OPXAppDelegate.h"
#import "AFGitHubRepository+Octopics.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface OPXComposeViewController ()

@property (nonatomic, strong) AFGitHubCommit *stubCommit;

@end

@implementation OPXComposeViewController

- (void)setImage:(UIImage *)image {
  _image = [image copy];
  [self.imageView setImage:image];
}

- (void)viewDidLayoutSubviews {
  [self.imageView setImage:self.image];
  self.placeholderTextView.frame = self.textView.frame;
  [super viewDidLayoutSubviews];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  self.placeholderTextView.hidden = AFGitHubIsStringWithAnyText(textView.text);
  return YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.textView becomeFirstResponder];
}

- (IBAction)done:(id)sender {
  [SVProgressHUD showWithStatus:@"Transaction in progress..." maskType:SVProgressHUDMaskTypeGradient];
  [[[OPXAppDelegate current] currentRepository]
   postImage:self.image
   withMessage:self.textView.text
   success:^(AFGitHubAPIRequestOperation *operation, AFGitHubAPIResponse *responseObject) {
     [SVProgressHUD showSuccessWithStatus:@"Complete"];
     [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
   }failure:^(AFGitHubAPIRequestOperation *operation, NSError *error) {
     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
   }];
}

- (IBAction)cancel:(id)sender {
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  NSString *after = [textView.text stringByReplacingCharactersInRange:range withString:text];
  self.stubCommit.message = after;
  self.placeholderTextView.hidden = AFGitHubIsStringWithAnyText(after);
  return YES;
}


@end
