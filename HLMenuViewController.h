//
//  HLViewController.h
//  Tango
//
//  Created by Lin on 13-11-10.
//  Copyright (c) 2013年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface HLMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end
