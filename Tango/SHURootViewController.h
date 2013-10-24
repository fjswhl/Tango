//
//  SHURootViewController.h
//  Tango
//
//  Created by Shuyu on 13-10-8.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import <sqlite3.h>
@interface SHURootViewController : UIViewController

@property (strong, readonly, nonatomic) RESideMenu *sideMenu;

- (void)showMenu;
@end
