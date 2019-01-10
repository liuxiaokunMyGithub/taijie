//
//  NSString+DateFormat.m
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2017/8/22.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import "NSString+DateFormat.h"

static NSString * const FORMAT_PAST_SHORT = @"yyyy/MM/dd";
static NSString * const FORMAT_DATE_SHORT = @"yyyy-MM-dd";
static NSString * const FORMAT_PAST_TIME = @"ahh:mm";
static NSString * const FORMAT_THIS_WEEK = @"eee ahh:mm";
static NSString * const FORMAT_THIS_WEEK_SHORT = @"eee";
static NSString * const FORMAT_YESTERDAY = @"ahh:mm";
static NSString * const FORMAT_TODAY = @"ahh:mm";

@implementation NSString (DateFormat)

+ (NSString *)localizedStringTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];[formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

// 通过数字转换成时间格式
+ (NSString *)formatWithTime:(NSTimeInterval)duration
{
    int hour = 0;
    int minute = 0;
    int second = 0;
    hour = duration / 3600;
    minute = ((int)duration % 3600) / 60;
    second = (int)duration % 60;
    return hour > 0 ? [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second] : [NSString stringWithFormat:@"%02d:%02d",minute,second];
}

/** 更新时间差 */
+ (NSString *)compareCurrentTime:(NSString *)dateStr {
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:dateStr];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%zu分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%zu小时前",temp];
    }
    
    else if((temp = temp/24) <7){
        result = [NSString stringWithFormat:@"%zu天前",temp];
    } else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        [formatter setLocale:locale];
        
        [formatter setDateFormat:FORMAT_DATE_SHORT];
        result = [formatter stringFromDate:timeDate];
    }
    return  result;
}

/** 获取当前时间戳 */
+ (NSString *)getNowTimeTimestamp {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time = [date timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", time];
    
    return timeString;
}

/**
 *  @author 刘小坤, 16-08-05 18:08:37
 *
 *  日期格式化
 *
 *  @param timeInterval 需要格式化的时间
 *
 *  @return 格式化之后的时间字符串
 */
+ (NSString *)dateToString:(float)timeInterval showSecond:(BOOL)showSecond {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    if (showSecond == YES) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSTimeInterval time= timeInterval/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return [dateFormatter stringFromDate:date];
}

/**
 下午11:56 （是今天的）
 会话：同样以上字符 - 下午11:56
 
 昨天 上午10:22 （昨天的）
 会话：只显示 - 昨天
 
 星期二 上午08:21 （今天昨天之前的一周显示星期）
 会话：只显示 - 星期二
 
 2015年1月22日 上午11:58 （一周之前显示具体的日期了）
 会话：显示 - 2015/04/18
 */
//设置格式 年yyyy 月 MM 日dd 小时hh(HH) 分钟 mm 秒 ss MMM单月 eee周几 eeee星期几 a上午下午
+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval
                    forConversation:(BOOL)isShort {
    //转为现在时间
    NSDate* theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    
    NSString *output = nil;
    
    NSTimeInterval theDiff = -theDate.timeIntervalSinceNow;
    
    //上述时间差输出不同信息
    if (theDiff < 60) {
        output = @"刚刚";
        
    } else if (theDiff < 60 * 60) {
        int minute = (int) (theDiff / 60);
        output = [NSString stringWithFormat:@"%d分钟前", minute];
        
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        [formatter setLocale:locale];
        
        BOOL isTodayYesterday = NO;
        BOOL isPastLong = NO;
        
        if ([theDate isToday]) {
            [formatter setDateFormat:FORMAT_TODAY];
        } else if ([theDate isYesterday]) {
            [formatter setDateFormat:FORMAT_YESTERDAY];
            isTodayYesterday = YES;
        } else if ([theDate isThisWeek]) {
            if (isShort) {
                [formatter setDateFormat:FORMAT_THIS_WEEK_SHORT];
            } else {
                [formatter setDateFormat:FORMAT_THIS_WEEK];
            }
        } else {
            if (isShort) {
                [formatter setDateFormat:FORMAT_PAST_SHORT];
            } else {
                [formatter setDateFormat:FORMAT_PAST_TIME];
                isPastLong = YES;
            }
        }
        
        if (isTodayYesterday) {
            NSString *todayYesterday = [self getTodayYesterdayString:theDate];
            if (isShort) {
                output = todayYesterday;
            } else {
                output = [formatter stringFromDate:theDate];
                output = [NSString stringWithFormat:@"%@ %@", todayYesterday, output];
            }
        } else {
            output = [formatter stringFromDate:theDate];
            if (isPastLong) {
                NSString *thePastDate = [self getPastDateString:theDate];
                output = [NSString stringWithFormat:@"%@ %@", thePastDate, output];
            }
        }
    }
    
    return output;
}

+ (NSString *)getTodayYesterdayString:(NSDate *)theDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [formatter setLocale:locale];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.doesRelativeDateFormatting = YES;
    return [formatter stringFromDate:theDate];
}

+ (NSString *)getPastDateString:(NSDate *)theDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [formatter setLocale:locale];
    formatter.dateStyle = NSDateFormatterLongStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    return [formatter stringFromDate:theDate];
}

+ (NSString *)deleteEscapeCharacter:(NSString *)str {
    NSMutableString *responseString = [NSMutableString stringWithString:str];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
        [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    
    return responseString;
}


@end
