//
//  SHUForwardViewController.m
//  Tango
//
//  Created by Shuyu on 13-10-10.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

/*
    note by lin 13-10-12
    进度条待重做
*/

#import "SHUVistaViewController.h"
#import "SHUCorrectViewController.h"
#import "SHUAppDelegate.h"
#define ONESECOND 1.0

@interface SHUVistaViewController ()

//@property (strong, nonatomic) AVSpeechSynthesizer *speechSynthesizer;
//@property (strong, nonatomic) AVSpeechSynthesisVoice *voice;

- (IBAction)IdontKnow;
- (IBAction)goToNextWord;
- (IBAction)chooseWord:(UIButton *)sender;
- (IBAction)isTooEasy:(id)sender;

- (void)progressAdd;
- (void)performNewWordAndOptions;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (void)speechWithString:(NSString *)string;

@property (weak, nonatomic) IBOutlet UILabel *chnForJP_1;
@property (weak, nonatomic) IBOutlet UILabel *kanForJP_1;
@property (weak, nonatomic) IBOutlet UILabel *chnForJP_2;
@property (weak, nonatomic) IBOutlet UILabel *kanForJP_2;
@property (weak, nonatomic) IBOutlet UILabel *chnForJP_3;
@property (weak, nonatomic) IBOutlet UILabel *kanForJP_3;
@property (weak, nonatomic) IBOutlet UILabel *chnForJP_4;
@property (weak, nonatomic) IBOutlet UILabel *kanForJP_4;

@end

@implementation SHUVistaViewController

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
    //    //如果是展望界面，则以展望为条件筛选单词
    //    //如果是复习界面，则以复习为条件筛选单词
    //    self.word = [[HLWords alloc] initWithConditons:FORWORD];
    [self performNewWordAndOptions];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_timeLimitProgress setProgress:0 animated:YES];
    [_timeLimit invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)IdontKnow {
    /*      判定为生词后，销毁计时器，重置进度条    */
    [_timeLimit invalidate];
    [_timeLimitProgress setProgress:0 animated:YES];
    
    [self performSegueWithIdentifier:@"SegueToRight" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*      Segue回调传值 := SHUWords当前背诵       */
    if ([segue.identifier isEqualToString:@"SegueToRight"]){
        SHUCorrectViewController* correctVC = [segue destinationViewController];
        correctVC.rightWords = _word;
    }
}

- (IBAction)goToNextWord {
    [self performNewWordAndOptions];
    [_timeLimitProgress setProgress:0 animated:YES];
}

- (IBAction)chooseWord:(UIButton *)sender{
    
    //根据假名选出word_id，判断是否相等
    HLOptionButton *aOption = (HLOptionButton *)sender;
    sqlite3 *wordDatabase = [SHUAppDelegate sharedDatabase];
    if(wordDatabase){
        int selectedOptionWordID = aOption.optionContent.wordID;
        int rightWordID = self.word.wordID;
        
        if (selectedOptionWordID == rightWordID) {
            //在这里更新数据库数据
            const char *update = "update word_tbl set right_times = (right_times + 1) where word_id = ?;";
            sqlite3_stmt *updateStmt;
            if (sqlite3_prepare_v2(wordDatabase, update, -1, &updateStmt, NULL) == SQLITE_OK) {
                sqlite3_bind_int(updateStmt, 1, rightWordID);
                sqlite3_step(updateStmt);
            }
            sqlite3_finalize(updateStmt);
            
            //在这里判断用户是否掌握该单词并更新数据库
            const char *query = "select right_times, wrong_times from word_tbl where word_id = ?;";
            sqlite3_stmt *queryStmt;
            int r = sqlite3_prepare_v2(wordDatabase, query, -1, &queryStmt, NULL);
            if (!r) {
                sqlite3_bind_int(queryStmt, 1, rightWordID);
                int right_times = 0;
                int wrong_times = 0;
                while (sqlite3_step(queryStmt) == SQLITE_ROW) {
                    right_times = sqlite3_column_int(queryStmt, 0);
                    wrong_times = sqlite3_column_int(queryStmt, 1);
                }
                if (right_times == 10) {
                    const char *updateIsMastered = "update word_tbl set is_mastered = 1, is_mastered_today = 1 where word_id = ?;";
                    sqlite3_stmt *updateIsMasteredStmt;
                    if(sqlite3_prepare_v2(wordDatabase, updateIsMastered, -1, &updateIsMasteredStmt, NULL) == SQLITE_OK){
                        sqlite3_bind_int(updateIsMasteredStmt, 1, right_times);
                        sqlite3_step(updateIsMasteredStmt);
                    }
                }
            }else{
                NSLog(@"updateIsMastered failed in chooseWord of SHUVistaViewController");
            }
            sqlite3_finalize(queryStmt);
            
            //下面处理发音
            [self speechWithString:self.word.pronunceKara];
            
        }else{
            //在这里更新数据库数据
            const char *update = "update word_tbl set wrong_times = (wrong_times + 1) where word_id = ?;";
            sqlite3_stmt *updateStmt;
            if (sqlite3_prepare_v2(wordDatabase, update, -1, &updateStmt, NULL) == SQLITE_OK) {
                sqlite3_bind_int(updateStmt, 1, selectedOptionWordID);
                sqlite3_step(updateStmt);
            }
            sqlite3_finalize(updateStmt);
            [self IdontKnow];
        }
    }else{
        NSLog(@"ERROR, database not found");
    }
    
}

- (void)performNewWordAndOptions{
    /*  定时器每隔1s调用一次，8s为界限后销毁    */
    
    if (!_timeLimit) {
        _timeLimit = [NSTimer scheduledTimerWithTimeInterval:ONESECOND target:self selector:@selector(progressAdd) userInfo:nil repeats:YES];
    }
    
    HLWords *aWord = [[HLWords alloc] initWithConditons:FORWORD];
    self.word = aWord;                                  //  同时把这里新生成的单词赋给自身的word属性，以便于进入correctView时获取数据
    _wordNow.text = aWord.chineseWord;
    
    
    NSArray *chnForJpan = @[_chnForJP_1,_chnForJP_2,_chnForJP_3,_chnForJP_4];
    NSArray *kanForJpan = @[_kanForJP_1,_kanForJP_2,_kanForJP_3,_kanForJP_4];
    
    for (int i = 0; i <= 3; ++i) {
        HLOptionButton *tempButton = _wordForChoose[i];
        srand((unsigned)time(NULL));
        int index = rand()%(4 - i);
        HLOptionContent *aOptionContent = aWord.arrayOfJapaneseWord[index];//取出一个，删一个
        tempButton.optionContent = aOptionContent;
        [aWord.arrayOfJapaneseWord removeObjectAtIndex:index];
        if (aOptionContent.japaneseWord) {
            UILabel *tmpLabel_chn = [chnForJpan objectAtIndex:i];
            UILabel *tmpLabel_jpn = [kanForJpan objectAtIndex:i];
            tmpLabel_chn.text = aOptionContent.japaneseWord;
            tmpLabel_jpn.text = aOptionContent.kara;
            
            [tmpLabel_chn sizeToFit];
            [tmpLabel_jpn sizeToFit];
            
        }else{
            UILabel *tmpLabel_chn = [chnForJpan objectAtIndex:i];
            UILabel *tmpLabel_jpn = [kanForJpan objectAtIndex:i];
            tmpLabel_chn.text = aOptionContent.kara;
            tmpLabel_jpn.text = aOptionContent.kara;
            
            [tmpLabel_chn sizeToFit];
            [tmpLabel_jpn sizeToFit];
        }
    }
    
    //更新数据库的studied_today和studied_total字段
    const char *update = "update word_tbl set studied_today = 1,studied_total = 1 where word_id = ?;";
    sqlite3_stmt *updateStmt;
    if (sqlite3_prepare_v2([SHUAppDelegate sharedDatabase], update, -1, &updateStmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(updateStmt, 1, self.word.wordID);
        sqlite3_step(updateStmt);
    }else{
        NSLog(@"update studied_today and studied_total failed in performNewWordAndOptions of SHUVistaViewController");
    }
    sqlite3_finalize(updateStmt);
}

- (void)progressAdd
{
    if (_timeLimitProgress.progress >= 0.5){
        _timeLimitProgress.tintColor = [UIColor whiteColor];
    }else{
        _timeLimitProgress.tintColor = [UIColor blackColor];
    }
    
    if (_timeLimitProgress.progress == 1.0){
        [self IdontKnow];
        
        /*  清零进度  */
        
        [_timeLimitProgress setProgress:0 animated:YES];
    }
    
    NSInteger countDown = [[NSUserDefaults standardUserDefaults] integerForKey:@"countDown"];
    if (countDown == 0) {
        countDown = 8;
    }
    _timeLimitProgress.progress += (10.0f / (float)countDown / 10.0f);
}

- (IBAction)isTooEasy:(id)sender{
    sqlite3 *wordDatabase = [SHUAppDelegate sharedDatabase];
    const char *updateIsMastered = "update word_tbl set is_mastered = 1,is_mastered_today = 1 where word_id = ?;";
    sqlite3_stmt *updateIsMasteredStmt;
    if (sqlite3_prepare_v2(wordDatabase, updateIsMastered, -1, &updateIsMasteredStmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(updateIsMasteredStmt, 1, self.word.wordID);
        sqlite3_step(updateIsMasteredStmt);
    }else{
        NSLog(@"update is_mastered stmt failed in SHUVistaViewController");
    }
    sqlite3_finalize(updateIsMasteredStmt);
    
    [self goToNextWord];
}

- (IBAction)backToMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

#pragma mark - speech

- (void)speechWithString:(NSString *)string{
    AVSpeechUtterance *speechUtterance = [AVSpeechUtterance speechUtteranceWithString:string];
    speechUtterance.rate = 0.2;

    
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ja-JP"];
    speechUtterance.voice = voice;
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    synthesizer.delegate = self;
    [synthesizer speakUtterance:speechUtterance];
}

#pragma mark - AVSpeechSynthesizer delegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    [self goToNextWord];
}
@end
































