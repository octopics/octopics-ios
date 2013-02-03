//
//  OPXPictureListViewController.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "OPXAppDelegate.h"
#import "AFGitHub.h"
#import "OPXPictureListViewController.h"
#import "AFGitHubRepository+Octopics.h"
#import <AFNetworking/AFNetworking.h>
#import "NSDate+InternetDateTime.h"
#import "NSDate+TimeDifference.h"
#import "OPXPictureImageCell.h"
#import "OPXPictureMessageCell.h"
#import "OPXGlobal.h"

@interface OPXPictureListViewController ()

@property (nonatomic, strong) NSArray *pics;

@end

@implementation OPXPictureListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostNewPicture:) name:kOPXNotificationNewPicture object:nil];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if(!self.repository)
    self.repository = [OPXAppDelegate current].currentRepository;
  if(!self.pics)
    [self reload:NO];
  self.navigationItem.title = self.repository.name;
}

#pragma mark - Table view data source

- (void)reload:(BOOL)nocache {
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:self.repository.indexJSONURL];
  if(nocache) {
    OPXSetDefaultCacheOff();
    [req setCachePolicy:NSURLCacheStorageNotAllowed];
    [req setTimeoutInterval:0];
  } else {
    OPXSetDefaultCacheOn();
  }
  AFJSONRequestOperation *op =
  [AFJSONRequestOperation
   JSONRequestOperationWithRequest:req
   success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
     self.pics = JSON;
     OPXSetDefaultCacheOn();
     [self.tableView reloadData];
     if(nocache) {
       double delayInSeconds = 2.0;
       dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
       dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
         
         [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
       });
     }
   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
     OPXSetDefaultCacheOn();
   }];
  if(nocache)
    [op setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
      return nil;
    }];
  [op start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.pics.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = indexPath.row == 1 ? @"MessageCell" : @"PictureCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  NSDictionary *pic = self.pics[indexPath.section];
  if(indexPath.row == 1) {
    [cell.textLabel setText:pic[@"message"]];
  } else {
    [(OPXPictureImageCell *)cell setImageURL:[NSURL URLWithString:pic[@"image_url"]]];
  }
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSDictionary *pic = self.pics[section];
  return [[NSDate dateFromRFC3339String:pic[@"created_at"]] stringWithTimeDifference];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.row == 1 ? 50 : 315;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
  v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
  label.font = [UIFont fontWithName:@"Helvetica" size:12];
  label.textColor = [UIColor colorWithWhite:1 alpha:0.7];
  label.backgroundColor = [UIColor clearColor];
  label.text = [self tableView:tableView titleForHeaderInSection:section];
  [v addSubview:label];
  return v;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Notification Observer

- (void)didPostNewPicture:(NSNotification *)notif {
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self reload:YES];
  });
}

@end
