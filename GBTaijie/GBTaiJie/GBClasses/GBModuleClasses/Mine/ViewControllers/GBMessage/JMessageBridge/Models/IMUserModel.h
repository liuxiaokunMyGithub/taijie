//
//  UserModel.h
//  JMessage-AuroraIMUI-OC-Demo
//
//  Created by oshumini on 2017/6/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBTaiJie-Swift.h"
#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

@interface IMUserModel : NSObject <IMUIUserProtocol>

/* 消息 */
@property (nonatomic, strong) JMSGMessage * _Nullable message;

/* 对方头像 */
@property (nonatomic, strong) UIImage * _Nullable targetAvatar;

- (NSString * _Nonnull)userId SWIFT_WARN_UNUSED_RESULT;

- (NSString * _Nonnull)displayName SWIFT_WARN_UNUSED_RESULT;

- (UIImage * _Nonnull)Avatar SWIFT_WARN_UNUSED_RESULT;

- (void)setupWithUser:(JMSGMessage *_Nullable)message targetAvatar:(UIImage *_Nonnull)targetAvatar;

@end
