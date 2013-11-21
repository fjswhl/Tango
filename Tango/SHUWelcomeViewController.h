//
//  SHUWelcomeViewController.h
//  Tango
//
//  Created by Shuyu on 13-10-15.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "PICircularProgressView.h"
#import "MRCircularProgressView.h"
@interface SHUWelcomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *studiedToday;
@property (weak, nonatomic) IBOutlet UILabel *isMasteredToday;
@property (weak, nonatomic) IBOutlet UILabel *studiedTotal;
@property (weak, nonatomic) IBOutlet UILabel *isMasteredTotal;
@property (weak, nonatomic) IBOutlet UILabel *wordsTotal;
@property (weak, nonatomic) IBOutlet UIProgressView *studyProgress;

@property (weak, nonatomic) IBOutlet MRCircularProgressView *todayProgress;


@end
