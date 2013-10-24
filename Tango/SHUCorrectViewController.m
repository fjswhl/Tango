//
//  SHUCorrectViewController.m
//  Tango
//
//  Created by Shuyu on 13-10-10.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import "SHUCorrectViewController.h"
#import "SHUAppDelegate.h"
@interface SHUCorrectViewController ()

@property (weak, nonatomic) IBOutlet UIButton *transButton;

@end

@implementation SHUCorrectViewController

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
    
    _chineseWord.text = _rightWords.chineseWord;
    _japaneseWord.text = _rightWords.japaneseWord;
    _pronunceKara.text = _rightWords.pronunceKara;
    _egSentenceInJpn.text = _rightWords.egSentenceInJpn;
    _wordClass.text = _rightWords.wordClass;



}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)translateString:(NSString *)string{
    NSString *sourceText = string;
    NSString *strURL = [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=xidian512&key=2115314771&type=data&doctype=json&version=1.1&q=%@", [sourceText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *targetText;
    
    if (strURL) {
        NSURL *url = [NSURL URLWithString:strURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data == nil) {
            return @"网络错误，请重试";
        }
    ;    targetText = [self parseJSONDataWithData:data];
    }
    return targetText;
}

- (NSString *)parseJSONDataWithData:(NSData *)data{
    NSString *result = nil;
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json == nil) {
        NSLog(@"json parse failed");
        return @"网络错误， 请重试";
    }
    NSArray *array = [json objectForKey:@"translation"];
    result = [array objectAtIndex:0];
    return result;
}

- (IBAction)addIntoMyWordNote:(id)sender{
    sqlite3 *wordDatabase = [SHUAppDelegate sharedDatabase];
    const char *updateInWordNote = "update word_tbl set inWordNote = 1 where word_id = ?;";
    sqlite3_stmt *updateInWordNoteStmt;
    if (sqlite3_prepare_v2(wordDatabase, updateInWordNote, -1, &updateInWordNoteStmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(updateInWordNoteStmt, 1, self.rightWords.wordID);
        sqlite3_step(updateInWordNoteStmt);
    }else{
        NSLog(@"updateInWordNoteStmt failed in addIntoMyWordNote failed!");
    }
    sqlite3_finalize(updateInWordNoteStmt);
    
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"消息" message:@"生词添加成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alrt show];
}

- (IBAction)viewTranslation:(UIButton *)sender{
    UIButton *button = (UIButton *)sender;
    button.hidden = YES;
    [self.indicator startAnimating];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSString *targetText = [self translateString:_egSentenceInJpn.text];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            _egSentenceInChn.text = targetText;
            [self.indicator stopAnimating];
        });
    });
}
@end

























