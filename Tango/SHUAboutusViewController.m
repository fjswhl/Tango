//
//  SHUAboutusViewController.m
//  Tango
//
//  Created by Shuyu on 13-10-15.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import "SHUAboutusViewController.h"

@interface SHUAboutusViewController ()

@end

@implementation SHUAboutusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)bacoToMenu:(id)sender {
    [self showMenu];
}

@end
