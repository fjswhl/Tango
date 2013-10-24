//
//  SHUWelcomeMenuViewController.h
//  Tango
//
//  Created by Shuyu on 13-10-8.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import "SHURootViewController.h"

@interface SHUWelcomeMenuViewController : SHURootViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *NavBarItem;

@property (weak, nonatomic) IBOutlet UILabel *studiedToday;
@property (weak, nonatomic) IBOutlet UILabel *isMasteredToday;
@property (weak, nonatomic) IBOutlet UILabel *studiedTotal;
@property (weak, nonatomic) IBOutlet UILabel *isMasteredTotal;
@property (weak, nonatomic) IBOutlet UILabel *wordsTotal;
@end
