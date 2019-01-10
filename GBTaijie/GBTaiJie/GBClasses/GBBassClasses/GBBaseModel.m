//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBBaseModel.h"
#import <objc/runtime.h>

@implementation GBBaseModel

-(id)initWithDic:(NSDictionary *)data{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSData*)keyedArchiverObject
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (instancetype)unarchiveObjectWithDate:(NSData*)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *vars =  class_copyIvarList([self class], &count);
    for (int index =0; index < count; index++) {
        Ivar varTemp = vars[index];
        const char* c = ivar_getName(varTemp);
        NSString *keyName = [NSString stringWithUTF8String:c];
        if ([self valueForKey:keyName]) {
            [aCoder encodeObject:[self valueForKey:keyName] forKey:keyName];
        }
    }
    free(vars);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        unsigned int count = 0;
        Ivar *vars =  class_copyIvarList([self class], &count);
        for (int index =0; index < count; index++) {
            Ivar varTemp = vars[index];
            const char* c = ivar_getName(varTemp);
            NSString *keyName = [NSString stringWithUTF8String:c];
            [self setValue:[aDecoder decodeObjectForKey:keyName] forKey:keyName];
        }
        free(vars);
    }
    return self;
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    if (oldValue == [NSNull null]) {
        if ([oldValue isKindOfClass:[NSArray class]]) {
            return  @[];
        }else if([oldValue isKindOfClass:[NSDictionary class]]){
            return @{};
        }else{
            return @"";
        }
        
    }

    return oldValue;
}

@end
