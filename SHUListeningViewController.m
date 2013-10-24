//
//  SHUListeningViewController.m
//  Tango
//
//  Created by Shuyu on 13-10-23.
//  Copyright (c) 2013年 Lin. All rights reserved.
//

#import "SHUListeningViewController.h"
#import "HLOptionContent.h"


#define JP_VOICE @"ja-JP"
#define CN_VOICE @"ch-CN"

@interface SHUListeningViewController ()

@property (strong, nonatomic) NSTimer *timerLimit;
@property (strong, nonatomic) HLOptionContent *currentWord;
@property (nonatomic) BOOL isListeningOver;

@end

@implementation SHUListeningViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isListeningOver = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)startToListening:(id)sender {
    [self arrangeWord];
}

- (void)addProgress{
    
    if (_timeLimitProgress.progress != 1.0) {
        _timeLimitProgress.progress += 0.1;
    }else{
        [_timerLimit invalidate];
        
        /*  不会  */
        
        _feedBack.text = @"看来你不会";
        _correctAnswer.text = _currentWord.kara;
        _isListeningOver = YES;
        [self speechWithString:_currentWord.kara inLanguage:JP_VOICE];
        
    }
}

- (void)arrangeWord
{
    _timeLimitProgress.progress = 0;
    
    if (!_timerLimit) {
        _timerLimit = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addProgress) userInfo:nil repeats:YES];
    }
    
    int index = [self getRandomNumber:0 to:(int)([_wordsArray count]-1)];
    _currentWord = _wordsArray[index];
    [self speechWithString:_currentWord.chineseWord inLanguage:CN_VOICE];
    
    _isListeningOver = NO;
    
}

- (IBAction)checkAnswer:(id)sender {
    
    if ([_answerSheet.text isEqualToString:_currentWord.japaneseWord] || [_answerSheet.text isEqualToString:_currentWord.kara]){
        
        _feedBack.text = @"正确";
        
    }else{
        _feedBack.text = @"错误";
    }
    
    _correctAnswer.text = _currentWord.kara;
    _isListeningOver = YES;
    
    [self speechWithString:_currentWord.kara inLanguage:JP_VOICE];
    
    /*   然后查看代理方法   */
}

- (IBAction)playJanVoice:(id)sender {
    [self speechWithString:_currentWord.japaneseWord inLanguage:JP_VOICE];
}

- (IBAction)playChnVoice:(id)sender {
    [self speechWithString:_currentWord.japaneseWord inLanguage:CN_VOICE];
}

- (int)getRandomNumber:(int)from to:(int)to
{
    /*  生成从From - To的随机数，[from,to) */
    
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - Speech

- (void)speechWithString:(NSString *)string inLanguage:(NSString *)language{
    
    AVSpeechUtterance *speechUtterance = [AVSpeechUtterance speechUtteranceWithString:string];
    
    speechUtterance.rate = 0.2;
    
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:language];
    
    speechUtterance.voice = voice;
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    [synthesizer speakUtterance:speechUtterance];
    
    synthesizer.delegate = self;
}

#pragma mark - AVSpeechSynthesizer delegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    if (_isListeningOver == YES){
        _feedBack.text = @"下一个";
        [self arrangeWord];
    }
    
}

@end
