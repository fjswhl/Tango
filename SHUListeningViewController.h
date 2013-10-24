//
//  SHUListeningViewController.h
//  Tango
//
//  Created by Shuyu on 13-10-23.
//  Copyright (c) 2013年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SHUListeningViewController : UIViewController<AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *timeLimitProgress;
@property (weak, nonatomic) IBOutlet UITextField *answerSheet;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswer;
@property (weak, nonatomic) IBOutlet UILabel *feedBack;

@property (strong, nonatomic) NSMutableArray *wordsArray;


@end
