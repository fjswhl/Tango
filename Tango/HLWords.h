//
//  HLWords.h
//  Tango
//
//  Created by Lin on 13-10-12.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HLOptionContent.h"
#import <sqlite3.h>
typedef enum {
    FORWORD = 1,
    REVIEW,
    RANDOM
}Conditions;

//数据库实例已移至AppDelegate
@interface HLWords : NSObject

@property (strong, nonatomic) NSString *chineseWord;
@property (strong, nonatomic) NSString *japaneseWord;
@property (strong, nonatomic) NSString *pronunceKara;
@property (strong, nonatomic) NSMutableArray *arrayOfJapaneseWord; //存放4个选项的日文解释
/*      egSentece      : 例句
 right_times    : 正确次数
 times_required : 要求次数
 wrong_times    : 错误次数
 isMastered     : 是否掌握
 wordID         : 单词编号
 */
@property (strong, nonatomic) NSString *egSentenceInJpn;
@property (strong, nonatomic) NSString *egSentenceInChn;
@property (strong, nonatomic) NSString *wordClass;
@property (nonatomic) int right_times;
@property (nonatomic) int times_required;
@property (nonatomic) int wrong_times;
@property (nonatomic) BOOL isMastered;
@property (nonatomic) int wordID;


- (id)initWithConditons:(Conditions)condition;
@end
