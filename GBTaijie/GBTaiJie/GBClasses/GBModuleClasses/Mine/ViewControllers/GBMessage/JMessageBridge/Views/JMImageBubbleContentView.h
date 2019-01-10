//
//  JMImageBubbleContentView.h
//  JMessageOCDemo
//
//  Created by oshumini on 2017/6/14.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBTaiJie-Swift.h"

@interface JMImageBubbleContentView : UIView <IMUIMessageContentViewProtocol>
@property(strong, nonatomic)UIImageView * _Nullable imageMessageView;

- (void)layoutContentViewWithMessage:(id <IMUIMessageModelProtocol> _Nonnull)message;
@end
