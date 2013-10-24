//
//  SHUAppDelegate.h
//  Tango
//
//  Created by Shuyu on 13-10-8.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import <sqlite3.h>
@interface SHUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic) sqlite3 *database;

+ (sqlite3 *)sharedDatabase;
- (void)closeDatabase;
@end

