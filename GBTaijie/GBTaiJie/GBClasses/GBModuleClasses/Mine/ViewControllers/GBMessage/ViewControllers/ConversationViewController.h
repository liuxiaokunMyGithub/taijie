//
//  ConversationViewController.h
//  JMessage-AuroraIMUI-OC-Demo
//
//  Created by oshumini on 2017/6/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

@interface ConversationViewController : GBBaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarHeightConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarToBottomConstrait;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageListTop;

/* 会话对象头像 */
@property (nonatomic, strong) UIImage *targetAvatar;

@property (strong, nonatomic) JMSGConversation *conversation;

@end
