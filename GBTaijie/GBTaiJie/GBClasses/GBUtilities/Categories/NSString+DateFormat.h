//
//  NSString+DateFormat.h
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2017/8/22.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DateFormat)

// 当前时间
+ (NSString *)localizedStringTime;
// 通过数字转换成时间格式
+ (NSString *)formatWithTime:(NSTimeInterval)duration;
/** 格式化时间差 */
+ (NSString *)compareCurrentTime:(NSString *)str;

/** 获取当前时间戳 */
+ (NSString *)getNowTimeTimestamp;

//时间戳格式化
+ (NSString *)dateToString:(float)timeInterval showSecond:(BOOL)showSecond;

// 去除转义字符"\"
+ (NSString *)deleteEscapeCharacter:(NSString *)str;

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval
                    forConversation:(BOOL)isShort;
@end
