//
//  SHUAppDelegate.m
//  Tango
//
//  Created by Shuyu on 13-10-8.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

// test
#import "SHUAppDelegate.h"
static sqlite3 *database;
@implementation SHUAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self processTodayInformationInDatabase];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self closeDatabase];
}

#pragma mark - lin

+ (sqlite3 *)sharedDatabase{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (database == nil) {
            NSString *beginPath = [[NSBundle mainBundle] pathForResource:@"data2" ofType:@"sqlite"];
            NSString *targetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *targetFile = [targetPath stringByAppendingPathComponent:@"data2.sqlite"];
            
            NSFileManager *fm = [NSFileManager defaultManager];
            if (![fm fileExistsAtPath:targetFile]) {
                NSError *error;
                [fm copyItemAtPath:beginPath toPath:targetFile error:&error];
                NSLog(@"%@", error);
            }
            
            if(sqlite3_open([targetFile UTF8String], &database) != SQLITE_OK){
                NSLog(@"ERROR, open database failed!");
            }
        }
    });
    return database;
}

- (void)closeDatabase{
    sqlite3_close(database);
}

- (void)processTodayInformationInDatabase{          //每日处理数据库里is_mastered_today和sutdied_today的信息   此方法重点测试  13-10-16
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    
    NSInteger secondOrdinalNow = [currentCalendar ordinalityOfUnit:NSSecondCalendarUnit inUnit:NSDayCalendarUnit forDate:today];
    
    if ([prefs integerForKey:@"secondOrdinal"] == 0) {
        [prefs setInteger:secondOrdinalNow forKey:@"secondOrdinal"];    //设置缺省值
    }
    if ([prefs objectForKey:@"date"] == nil) {
        [prefs setValue:today forKey:@"date"];
    }
    
    NSInteger secondOrdinalLastTime = [prefs integerForKey:@"secondOrdinal"];
    
    if (secondOrdinalNow < secondOrdinalLastTime || [today timeIntervalSinceDate:(NSDate *)[prefs objectForKey:@"date"]] >= 60 * 60 * 12) {
        const char *update = "update word_tbl set is_mastered_today = 0,studied_today = 0;";
        sqlite3_stmt *updateStmt;
        if (sqlite3_prepare_v2([SHUAppDelegate sharedDatabase], update, -1, &updateStmt, NULL) == SQLITE_OK) {
            sqlite3_step(updateStmt);
        }else{
            NSLog(@"update failed in processTodayInformationInDatabase of SHUWelcomeViewController");
        }
        
        [prefs setInteger:secondOrdinalNow forKey:@"secondOrdinal"];
        [prefs setValue:today forKey:@"date"];
    }
}
@end
















