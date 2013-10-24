//
//  SHUCorrectViewController.h
//  Tango
//
//  Created by Shuyu on 13-10-10.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLWords.h"

@interface SHUCorrectViewController : UIViewController

@property (strong, nonatomic) HLWords *rightWords;

@property (weak, nonatomic) IBOutlet UILabel *chineseWord;
@property (weak, nonatomic) IBOutlet UILabel *japaneseWord;
@property (weak, nonatomic) IBOutlet UILabel *pronunceKara;
@property (weak, nonatomic) IBOutlet UILabel *egSentenceInJpn;
@property (weak, nonatomic) IBOutlet UILabel *egSentenceInChn;
@property (weak, nonatomic) IBOutlet UILabel *wordClass;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
- (NSString *)translateString:(NSString *)string;

- (IBAction)viewTranslation:(UIButton *)sender;
@end
