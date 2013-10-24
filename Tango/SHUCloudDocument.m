//
//  SHUCloudDocument.m
//  Tango
//
//  Created by Shuyu on 13-10-20.
//  Copyright (c) 2013年 Lin. All rights reserved.
//

#import "SHUCloudDocument.h"

@implementation SHUCloudDocument


-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if (contents){
        _wordsInNote = [NSKeyedUnarchiver unarchiveObjectWithData:contents];
    }
    
    return YES;
}

-(id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:_wordsInNote];
}

@end
