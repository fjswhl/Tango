//
//  SHUWelcomeViewController.m
//  Tango
//
//  Created by Shuyu on 13-10-15.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

//      当选择完成日期和今日日期相同时的情况以后处理
#import "SHUWelcomeViewController.h"
#import "SHUAppDelegate.h"
@interface SHUWelcomeViewController ()

@property (nonatomic) int requiredStudiedToday;

- (IBAction)backToMenu:(id)sender;
- (IBAction)startRecint:(id)sender;

- (int)numberOfWordsTotal;
- (int)numberOfWordsStudiedTotal;
- (int)numberOfWordsMasteredTotal;
- (int)numberOfWordsStudiedToday;
- (int)numberOfWordsMasteredToday;

@end

@implementation SHUWelcomeViewController

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



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    int numberOfWordsTotal = [self numberOfWordsTotal];
    int numberOfWordsMasteredTotal = [self numberOfWordsMasteredTotal];
    
    self.studiedToday.text = [NSString stringWithFormat:@"%i", [self numberOfWordsStudiedToday]];
    self.studiedTotal.text = [NSString stringWithFormat:@"%i", [self numberOfWordsStudiedTotal]];
    self.isMasteredToday.text = [NSString stringWithFormat:@"%i", [self numberOfWordsMasteredToday]];
    self.isMasteredTotal.text = [NSString stringWithFormat:@"%i", numberOfWordsMasteredTotal];
    self.wordsTotal.text = [NSString stringWithFormat:@"%i", numberOfWordsTotal];
    self.studyProgress.progress = (float)numberOfWordsMasteredTotal / (float)numberOfWordsTotal;
    self.todayProgress.progress = 0.5f;
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"completionDate"];
    if (date) {
        [self processTodayProgress];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToMenu:(id)sender {
    [self showMenu];
}

- (IBAction)startRecint:(id)sender {
    [self performSegueWithIdentifier:@"SegueToRecting" sender:self];
    
}

#pragma mark - lin calculation

- (int)numberOfWordsTotal{
    int result = 0;
    sqlite3 *wordDatabase = [SHUAppDelegate sharedDatabase];
    const char *query = "select count(*) from word_tbl;";
    sqlite3_stmt *queryStmt;
    if (sqlite3_prepare_v2(wordDatabase, query, -1, &queryStmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(queryStmt) == SQLITE_ROW) {
            result = sqlite3_column_int(queryStmt, 0);
        }
    }
    sqlite3_finalize(queryStmt);
    
    return result;
}

- (int)numberOfWordsMasteredTotal{
    int result = 0;
    sqlite3 *wordDatabase = [SHUAppDelegate sharedDatabase];
    const char *query = "select count(*) from word_tbl where is_mastered = 1;";
    sqlite3_stmt *queryStmt;
    if (sqlite3_prepare_v2(wordDatabase, query, -1, &queryStmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(queryStmt) == SQLITE_ROW) {
            result = sqlite3_column_int(queryStmt, 0);
        }
    }
    sqlite3_finalize(queryStmt);
    
    return result;
}

- (int)numberOfWordsMasteredToday{
    int result = 0;
    sqlite3 *wordDatabase = [SHUAppDelegate sharedDatabase];
    const char *query = "select count(*) from word_tbl where is_mastered_today = 1;";
    sqlite3_stmt *queryStmt;
    if (sqlite3_prepare_v2(wordDatabase, query, -1, &queryStmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(queryStmt) == SQLITE_ROW) {
            result = sqlite3_column_int(queryStmt, 0);
        }
    }else{
        NSLog(@"numberOfWordsMasteredToday failed in SHUWelcomeVC");
    }
    sqlite3_finalize(queryStmt);
    
    return result;
}

- (int)numberOfWordsStudiedToday{
    int result = 0;
    sqlite3 *wordDatabase = [SHUAppDelegate sharedDatabase];
    const char *query = "select count(*) from word_tbl where studied_today = 1;";
    sqlite3_stmt *queryStmt;
    if (sqlite3_prepare_v2(wordDatabase, query, -1, &queryStmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(queryStmt) == SQLITE_ROW) {
            result = sqlite3_column_int(queryStmt, 0);
        }
    }else{
        NSLog(@"numberOfWordsStudiedToday failed in SHUWelcomeVC");
    }
    sqlite3_finalize(queryStmt);
    
    return result;
}

- (int)numberOfWordsStudiedTotal{
    int result = 0;
    sqlite3 *wordDatabase = [SHUAppDelegate sharedDatabase];
    const char *query = "select count(*) from word_tbl where studied_total = 1;";
    sqlite3_stmt *queryStmt;
    if (sqlite3_prepare_v2(wordDatabase, query, -1, &queryStmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(queryStmt) == SQLITE_ROW) {
            result = sqlite3_column_int(queryStmt, 0);
        }
    }else{
        NSLog(@"numberOfWordsStudiedTotal failed in SHUWelcomeVC");
    }
    sqlite3_finalize(queryStmt);
    
    return result;
}


- (void)processTodayProgress{
    NSDate *today = [NSDate date];
    NSDate *completionDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"completionDate"];
    
    NSInteger daysInterval = (NSInteger)(fabs([completionDate timeIntervalSinceDate:today]) / (60 * 60 * 12));
    int numberOfWordsTotal = [self numberOfWordsTotal];
    int numberOfWordsStudiedTotal = [self numberOfWordsStudiedTotal];
    int numberOfWordsStudiedToday = [self numberOfWordsStudiedToday];
    
    _requiredStudiedToday = (numberOfWordsTotal - numberOfWordsStudiedTotal) / daysInterval;
    _todayProgress.progress = (float)numberOfWordsStudiedToday / (float)_requiredStudiedToday;
}
@end

























