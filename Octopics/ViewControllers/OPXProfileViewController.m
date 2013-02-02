//
//  OPXProfileViewController.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "OPXProfileViewController.h"
#import "OPXGlobal.h"
#import "OPXAppDelegate.h"

@interface OPXProfileViewController ()

@end

@implementation OPXProfileViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.row == 0 && indexPath.section == 0) {
    [[AFGitHubAPIClient sharedClient] logout];
  }
}

@end
