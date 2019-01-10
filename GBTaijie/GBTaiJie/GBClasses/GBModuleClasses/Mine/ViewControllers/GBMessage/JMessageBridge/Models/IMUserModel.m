//
//  IMUserModel.m
//  JMessage-AuroraIMUI-OC-Demo
//
//  Created by oshumini on 2017/6/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import "IMUserModel.h"

@implementation IMUserModel
- (instancetype)init
{
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (NSString * _Nonnull)userId SWIFT_WARN_UNUSED_RESULT {
    return self.message.isReceived ?self.message.fromUser.username: [GBUserDefaults objectForKey:UDK_UserId];
}

- (NSString * _Nonnull)displayName SWIFT_WARN_UNUSED_RESULT {
    return self.message.isReceived ? self.message.fromUser.displayName : userManager.currentUser.nickName;
}

- (UIImage * _Nonnull)Avatar SWIFT_WARN_UNUSED_RESULT {
    return (self.message.isReceived ? (_targetAvatar ? [_targetAvatar setCircleImage]: PlaceholderHeadImage) : ([IMManager sharedIMManager].currentUserImAvatar ? [[IMManager sharedIMManager].currentUserImAvatar setCircleImage]:PlaceholderHeadImage));
    
}

- (void)setupWithUser:(JMSGMessage *)message targetAvatar:(UIImage *)targetAvatar {
    _message = message;
    _targetAvatar = targetAvatar;
    
}

@end
