//
//  OPXComposeViewController.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "OPXComposeViewController.h"
#import "OPXGlobal.h"

@interface OPXComposeViewController ()

@property (nonatomic, strong) AFGitHubCommit *stubCommit;

@end

@implementation OPXComposeViewController

- (void)setPictureBlob:(AFGitHubBlob *)pictureBlob {
  _pictureBlob = [pictureBlob copy];
  
  
  [self.imageView setImage:pictureBlob.imageContent];
}

- (void)viewDidLayoutSubviews {
  [self.imageView setImage:self.pictureBlob.imageContent];
  [super viewDidLayoutSubviews];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  self.placeholderLabel.hidden = YES;
  return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  self.placeholderLabel.hidden = AFGitHubIsStringWithAnyText(textView.text);
  return YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.textView becomeFirstResponder];
}

- (IBAction)done:(id)sender {
  
}

- (IBAction)cancel:(id)sender {
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  NSString *after = [textView.text stringByReplacingCharactersInRange:range withString:text];
  self.stubCommit.message = after;
  return YES;
}


@end
