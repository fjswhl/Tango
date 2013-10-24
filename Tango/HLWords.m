//
//  HLWords.m
//  Tango
//
//  Created by Lin on 13-10-12.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import "HLWords.h"
#import "SHUAppDelegate.h"
@implementation HLWords


/* note by lin 13-10-22
 关闭数据库的地点待确定
 */

- (id)initWithConditons:(Conditions)condition{
    if (self = [super init]) {
        //        SHUAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        //        sqlite3 *wordDatabase = [appDelegate sharedDatabase];
        sqlite3 *wordDatabase = [SHUAppDelegate sharedDatabase];
        if (condition == FORWORD) { //查询应背的单词                          算法待优化         note by lin 13-10-13
            const char *queryForword = "select * from word_tbl where is_mastered = 0 order by right_times,random() limit 1";
            sqlite3_stmt *queryStmt;
            int result = sqlite3_prepare_v2(wordDatabase, queryForword, -1, &queryStmt, NULL);
            if (result == SQLITE_OK) {
                while (sqlite3_step(queryStmt) == SQLITE_ROW) {
                    self.wordID = sqlite3_column_int(queryStmt, 0);
                    self.pronunceKara = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(queryStmt, 1)];
                    const char *aJapaneseWord = (const char *)sqlite3_column_text(queryStmt, 2);
                    if (aJapaneseWord != nil) {
                        self.japaneseWord = [NSString stringWithUTF8String:aJapaneseWord];
                    }else{
                        self.japaneseWord = nil;
                    }
//                    self.japaneseWord = [NSString stringWithCString:(const char *)sqlite3_column_text(queryStmt, 2) encoding:NSUTF8StringEncoding];
                    self.chineseWord = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStmt,3)];
                    self.wordClass = [NSString stringWithCString:(const char *)sqlite3_column_text(queryStmt, 4) encoding:NSUTF8StringEncoding];
                    self.wrong_times = sqlite3_column_int(queryStmt, 5);
                    self.right_times = sqlite3_column_int(queryStmt, 6);
                    self.isMastered = sqlite3_column_int(queryStmt, 7);
                    self.egSentenceInJpn = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStmt, 8)];
                    
                }
            }
            sqlite3_finalize(queryStmt);
        }else if (condition == RANDOM){ //随机查询一个单词
            NSString *queryRandom = @"select * from word_tbl where is_mastered = 1 order by random() limit 1";
            sqlite3_stmt *queryStmt;
            int result = sqlite3_prepare_v2(wordDatabase, [queryRandom UTF8String], -1, &queryStmt, nil);
            if (result == SQLITE_OK) {
                while (sqlite3_step(queryStmt) == SQLITE_ROW) {
                    self.wordID = sqlite3_column_int(queryStmt, 0);
                    self.pronunceKara = [NSString stringWithCString:(const char *)sqlite3_column_text(queryStmt, 1) encoding:NSUTF8StringEncoding];
                    self.japaneseWord = [NSString stringWithCString:(const char *)sqlite3_column_text(queryStmt, 2) encoding:NSUTF8StringEncoding];
                    self.chineseWord = [NSString stringWithCString:(const char *)sqlite3_column_text(queryStmt,3) encoding:NSUTF8StringEncoding];
                    self.wordClass = [NSString stringWithCString:(const char *)sqlite3_column_text(queryStmt, 4) encoding:NSUTF8StringEncoding];
                    self.wrong_times = sqlite3_column_int(queryStmt, 5);
                    self.right_times = sqlite3_column_int(queryStmt, 6);
                    self.isMastered = sqlite3_column_int(queryStmt, 7);
                    self.egSentenceInJpn = [NSString stringWithCString:(const char *)sqlite3_column_text(queryStmt, 8) encoding:NSUTF8StringEncoding];
                }
            }
            sqlite3_finalize(queryStmt);
        }
        
        //查询其他3个日文(只检索japansesWord)
        self.arrayOfJapaneseWord = [[NSMutableArray alloc] init];
        const char *query = "select word_id,japanese_word,kana from word_tbl where word_id <> ? order by random()  limit 3";
        sqlite3_stmt *queryStmt;
        int result = sqlite3_prepare_v2(wordDatabase, query, -1, &queryStmt, nil);
        if (result == SQLITE_OK) {
            sqlite3_bind_int(queryStmt, 1, self.wordID);
            while (sqlite3_step(queryStmt) == SQLITE_ROW) {
                int word_id = sqlite3_column_int(queryStmt, 0);
                const char *kana = (const char *)sqlite3_column_text(queryStmt, 1);
                NSString *aJapaneseWord = nil;
                if (kana != NULL) {
                    aJapaneseWord = [NSString stringWithUTF8String:kana];
                }
                NSString *aKara = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(queryStmt, 2)];
                HLOptionContent *aOption = [[HLOptionContent alloc] initWithWordID:word_id kara:aKara japaneseWord:aJapaneseWord];
                [self.arrayOfJapaneseWord addObject:aOption];
            }
        }
        sqlite3_finalize(queryStmt);
        HLOptionContent *aOption = [[HLOptionContent alloc] initWithWordID:self.wordID kara:self.pronunceKara japaneseWord:self.japaneseWord];
        [self.arrayOfJapaneseWord addObject:aOption];//把当前待背单词的日文也加进来
    }
    return self;
}

- (id)initWithWordID:(int)wordID chineseWord:(NSString *)chineseWord japaneseWord:(NSString *)japaneseWord wordClass:(NSString *)wordClass kara:(NSString *)kara egSentence:(NSString *)egSentence{
    if (self = [super init]) {
        self.wordClass = wordClass;
        self.wordID = wordID;
        self.chineseWord = chineseWord;
        self.japaneseWord = japaneseWord;
        self.pronunceKara = kara;
        self.egSentenceInJpn = egSentence;
    }
    return self;
}

- (NSString *)stringRepresentation{
    NSString *result = nil;
    if (self.japaneseWord == nil) {
        result = self.pronunceKara;
    }else{
        result = [NSString stringWithFormat:@"%@(%@)", self.japaneseWord, self.pronunceKara];
    }
    return result;
}



@end
