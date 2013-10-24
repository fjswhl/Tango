//
//  HLOptionContent.h
//  Tango
//
//  Created by Lin on 13-10-11.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLOptionContent : NSObject

@property id spuerVC;

@property (strong, nonatomic) NSString *kara;
@property (strong, nonatomic) NSString *japaneseWord;
@property (strong, nonatomic) NSString *chineseWord;
@property (nonatomic) int wordID;

- (id)initWithWordID:(int)wordID kara:(NSString *)kara japaneseWord:(NSString *)japaneseWord;
- (id)initWithWordID:(int)wordID kara:(NSString *)kara japaneseWord:(NSString *)japaneseWord chineseWord:(NSString *)chineseWord;
- (NSString *)stringRepresentation;
- (NSString *)stringRepresentationWithChinese;

@end
