//
//  OPXChooseRepositoryViewController.m
//  Octopics
//
//  Created by Atsushi Nagase on 2/3/13.
//  Copyright (c) 2013 LittleApps Inc. All rights reserved.
//

#import "OPXChooseRepositoryViewController.h"
#import "OPXGlobal.h"

@interface OPXChooseRepositoryViewController ()

@end

@implementation OPXChooseRepositoryViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // TODO: Check references and file exists.
  

}

@end
