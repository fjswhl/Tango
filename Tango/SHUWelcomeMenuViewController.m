//
//  SHUWelcomeMenuViewController.m
//  Tango
//
//  Created by Shuyu on 13-10-8.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import "SHUWelcomeMenuViewController.h"
#import "SHURootViewController.h"
#import "SHUAppDelegate.h"
@interface SHUWelcomeMenuViewController ()
- (int)numberOfWordsTotal;
- (int)numberOfWordsStudiedTotal;
- (int)numberOfWordsMasteredTotal;

- (int)numberOfWordsStudiedToday;
- (int)numberOfWordsMasteredToday;
@end

@implementation SHUWelcomeMenuViewController

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
    self.studiedToday.text = [NSString stringWithFormat:@"%i", [self numberOfWordsStudiedToday]];
    self.studiedTotal.text = [NSString stringWithFormat:@"%i", [self numberOfWordsStudiedTotal]];
    self.isMasteredToday.text = [NSString stringWithFormat:@"%i", [self numberOfWordsMasteredToday]];
    self.isMasteredTotal.text = [NSString stringWithFormat:@"%i", [self numberOfWordsMasteredTotal]];
    self.wordsTotal.text = [NSString stringWithFormat:@"%i",[self numberOfWordsTotal]];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMenu:(id)sender {
    [self showMenu];
}

#pragma mark - lin

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


@end































