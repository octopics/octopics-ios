//
//  OPXComposeViewController.h
//  Octopics
//
//  Created by Atsushi Nagase on 2/2/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFGitHubBlob;
@interface OPXComposeViewController : UITableViewController<UITextViewDelegate>

@property (nonatomic, copy) UIImage *image;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
