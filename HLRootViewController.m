//
//  HLRootViewController.m
//  Tango
//
//  Created by Lin on 13-11-10.
//  Copyright (c) 2013年 Lin. All rights reserved.
//

#import "HLRootViewController.h"
#import "HLMenuViewController.h"
@interface HLRootViewController ()

@end

@implementation HLRootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    self.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.delegate = (HLMenuViewController *)self.menuViewController;
}

@end
