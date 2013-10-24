//
//  SHUForwardViewController.h
//  Tango
//
//  Created by Shuyu on 13-10-10.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import "SHURootViewController.h"
#import "HLWords.h"
#import "HLOptionButton.h"
#import <AVFoundation/AVFoundation.h>
@interface SHUVistaViewController : SHURootViewController<AVSpeechSynthesizerDelegate>

@property (strong, nonatomic) HLWords *word;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *wordForChoose;


/*      wordNow   :=  当前单词的文本显示
        feedBack  :=  当前单词正确性的文本反馈
        timeLimit :=  NSTimer对象描述时间
        timeLimitProgress :=  时间流逝进度
*/

@property (weak, nonatomic) IBOutlet UILabel *wordNow;
@property (weak, nonatomic) IBOutlet UIProgressView *timeLimitProgress;

@property (weak, nonatomic) NSTimer *timeLimit;


@end
