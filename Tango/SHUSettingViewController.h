//
//  SHUSettingViewController.h
//  Tango
//
//  Created by Shuyu on 13-10-15.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHUSettingViewController : UITableViewController

@property (weak, nonatomic) id sideMenuHolder;
@property (weak, nonatomic) IBOutlet UISwitch *iCloudSwitch;

- (NSURL *)ubiquitousDocumentsURL;

@end
