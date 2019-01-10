//
//  MessageModel.h
//  JMessage-AuroraIMUI-OC-Demo
//
//  Created by oshumini on 2017/6/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AuroraIMUI/AuroraIMUI-Swift.h>
#import "GBTaiJie-Swift.h"
#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

typedef void (^JMAsyncDataHandler)(NSData * _Nullable data, NSString * _Nullable msgId);

@interface MessageModel : NSObject <IMUIMessageModelProtocol>

@property(strong, nonatomic)JMSGMessage * _Nullable message;

/* 对方头像 */
@property (nonatomic, strong) UIImage * _Nullable targetAvatar;

@property(strong, nonatomic)JMAsyncDataHandler _Nullable mediaDataCallback;

@property (nonatomic, readonly, copy) NSString * _Nonnull msgId;

@property (nonatomic, readonly, strong) id <IMUIUserProtocol> _Nonnull fromUser;

@property (nonatomic, readonly, strong) id <IMUIMessageCellLayoutProtocol> _Nonnull layout;

@property (nonatomic, readonly, strong) UIImage * _Nonnull resizableBubbleImage;

@property (nonatomic, readonly, copy) NSString * _Nonnull timeString;

- (NSString * _Nonnull)text SWIFT_WARN_UNUSED_RESULT;

- (NSString * _Nonnull)mediaFilePath SWIFT_WARN_UNUSED_RESULT;

@property (nonatomic, readonly) CGFloat duration;

@property (nonatomic, readonly) BOOL isOutGoing;

@property (nonatomic, readonly) enum IMUIMessageStatus messageStatus;

@property (assign, nonatomic) NSString * _Nullable type;

- (instancetype _Nullable )initWithMessage:(JMSGMessage *_Nullable)message targetAvatar:(UIImage *_Nullable)targetAvatar isNeedShowTime:(BOOL )isNeedShowTime;

- (void)getMediaDataCallback:(JMAsyncDataHandler _Nullable ) callback;

- (NSString *_Nullable)setMediaFilePath:(NSString *_Nonnull)path;

@end


