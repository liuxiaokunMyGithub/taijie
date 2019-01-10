//
//  GBMessageCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/13.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBSystemMessageModel.h"

/** 头像tag */
extern NSInteger const kIconTag;

@interface GBMessageCell : UITableViewCell
/** 会话id */
@property(strong, nonatomic) NSString *conversationId;

/* 头像 */
@property (nonatomic, strong) UIImageView *iconImageView;

/* 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;

/* 消息 */
@property (nonatomic, strong) UILabel *msgLabel;

/* 时间 */
@property (nonatomic, strong) UILabel *timeLabel;

/** 消息数 */
@property (nonatomic, strong) UILabel *messageNumberLabel;

/* <#describe#> */
@property (nonatomic, strong) GBSystemMessageModel *systemMessageModel;

- (void)setCellDataWithConversation:(JMSGConversation *)conversation;

@end
