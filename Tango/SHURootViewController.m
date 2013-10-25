//
//  SHURootViewController.m
//  Tango
//
//  Created by Shuyu on 13-10-8.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import "SHURootViewController.h"
#import "SHUNoteViewController.h"

@interface SHURootViewController ()

@end

@implementation SHURootViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Button actions

- (void)showMenu
{
    if (!self.sideMenu){
        
        RESideMenuItem *reviewItem = [[RESideMenuItem alloc] initWithTitle:@"回顾" action:^(RESideMenu *menu, RESideMenuItem *item){
            UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VistaMenu"];
            [menu setRootViewController:navVC];
        }];
        
        RESideMenuItem *forwardItem = [[RESideMenuItem alloc] initWithTitle:@"展望" action:^(RESideMenu *menu, RESideMenuItem *item){
            UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VistaMenu"];
            [menu setRootViewController:navVC];
        }];
        
        RESideMenuItem *noteItem = [[RESideMenuItem alloc] initWithTitle:@"生词本" action:^(RESideMenu *menu, RESideMenuItem *item){
            UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NoteMenu"];
            
            SHUNoteViewController *noteVC = (SHUNoteViewController *)navVC.topViewController;
            noteVC.sideMenuHolder = self;
            
            [menu setRootViewController:navVC];
        }];
        
        RESideMenuItem *settingItem = [[RESideMenuItem alloc] initWithTitle:@"设置" action:^(RESideMenu *menu, RESideMenuItem *item){
            UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingMenu"];
            
            SHUNoteViewController *setVC = (SHUNoteViewController *)navVC.topViewController;
            setVC.sideMenuHolder = self;
            
            [menu setRootViewController:navVC];
        }];
        
        RESideMenuItem *aboutusItem = [[RESideMenuItem alloc] initWithTitle:@"关于我们" action:^(RESideMenu *menu, RESideMenuItem *item){
            UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutusMenu"];
            [menu setRootViewController:navVC];
        }];
        
        _sideMenu = [[RESideMenu alloc] initWithItems:@[reviewItem,forwardItem,settingItem,noteItem,aboutusItem]];
        
        UIImage *backGroundPic = [UIImage imageNamed:@"bgPic2"];
        
        NSLog(@"%@",backGroundPic);
        _sideMenu.backgroundImage = backGroundPic;
    }
    
    [self.sideMenu show];
}


@end
