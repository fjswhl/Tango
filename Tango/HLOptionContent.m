//
//  HLOptionContent.m
//  Tango
//
//  Created by Lin on 13-10-11.
//  Copyright (c) 2013年 Shuyu. All rights reserved.
//

#import "HLOptionContent.h"

@implementation HLOptionContent

- (id)initWithWordID:(int)wordID kara:(NSString *)kara japaneseWord:(NSString *)japaneseWord{
    if (self = [super init]) {
        self.wordID = wordID;
        self.kara = kara;
        self.japaneseWord = japaneseWord;
    }
    return self;
}

- (id)initWithWordID:(int)wordID kara:(NSString *)kara japaneseWord:(NSString *)japaneseWord chineseWord:(NSString *)chineseWord{
    if (self = [super init]) {
        self.wordID = wordID;
        self.kara = kara;
        self.japaneseWord = japaneseWord;
        self.chineseWord = chineseWord;
    }
    return self;
}

- (NSString *)stringRepresentation{
    NSString *result = nil;
    if (self.japaneseWord == nil) {
        result = self.kara;
    }else{
        result = [NSString stringWithFormat:@"%@(%@)", self.japaneseWord, self.kara];
    }
    return result;
}

- (NSString *)stringRepresentationWithChinese{
    NSString *result = nil;
    if (self.japaneseWord == nil) {
        result = [NSString stringWithFormat:@"%@: %@", self.chineseWord, self.kara];
    }else{
        result = [NSString stringWithFormat:@"%@: %@(%@)", self.chineseWord, self.japaneseWord, self.kara];
    }
    return result;
}
@end
