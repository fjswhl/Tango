//
//  SHUNoteViewController.m
//  Tango
//
//  Created by Shuyu on 13-10-15.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import "SHUNoteViewController.h"
#import "SHUListeningViewController.h"
#import "SHUCorrectViewController.h"
#import "SHUAppDelegate.h"
#import "HLOptionContent.h"


@interface SHUNoteViewController ()

@property (nonatomic) int rowForRight;

@end

@implementation SHUNoteViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchWordsInDatabase:[SHUAppDelegate sharedDatabase]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segueToListening:(id)sender {
    if (_wordsInWordNote != nil){
        [self performSegueWithIdentifier:@"SegueToListening" sender:self];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出问题了" message:@"单词本里没有可听写单词" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToListening"]) {
        SHUListeningViewController *nextVC = [segue destinationViewController];
        nextVC.wordsArray = _wordsInWordNote;
    }else{
        SHUCorrectViewController *nextvc = [segue destinationViewController];
        nextvc.rightWords = [_wordsInWordNote objectAtIndex:_rowForRight];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.wordsInWordNote count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rawWord"];
    HLWords *content = [self.wordsInWordNote objectAtIndex:indexPath.row];
    cell.textLabel.text = [content stringRepresentation];
    return cell;
}

#pragma mark - Table view delagete

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    _rowForRight = indexPath.row;
    
    [self performSegueWithIdentifier:@"SegueToRightForNote" sender:self];
}

- (IBAction)backToMenu:(id)sender {
    [self.sideMenuViewController presentMenuViewController];
}

#pragma mark - SQLite

- (void)fetchWordsInDatabase:(sqlite3 *)database{
    if (self.wordsInWordNote == nil) {
        self.wordsInWordNote = [[NSMutableArray alloc] init];
    }
    const char *query = "select word_id,japanese_word,kana,chinese_word,word_class,eg_sentence from word_tbl where inWordNote = 1;";
    sqlite3_stmt *queryStmt;
    if (sqlite3_prepare_v2(database, query, -1, &queryStmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(queryStmt) == SQLITE_ROW) {
            int wordID = sqlite3_column_int(queryStmt, 0);
            const char *jWord = (const char *)sqlite3_column_text(queryStmt, 1);
            NSString *japaneseWord = nil;
            if (jWord) {
                japaneseWord = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStmt, 1)];
            }
            NSString *kara = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStmt, 2)];
            NSString *chineseWord = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStmt, 3)];
            NSString *wordClass = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStmt, 4)];
            NSString *egSentence = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStmt, 5)];
            
            HLWords *aWord = [[HLWords alloc] initWithWordID:wordID chineseWord:chineseWord japaneseWord:japaneseWord wordClass:wordClass kara:kara egSentence:egSentence];
            [self.wordsInWordNote addObject:aWord];
        }
    }else{
        NSLog(@"fetchWordsIndatabase failed in SHUNoteViewController");
    }
}
@end




























