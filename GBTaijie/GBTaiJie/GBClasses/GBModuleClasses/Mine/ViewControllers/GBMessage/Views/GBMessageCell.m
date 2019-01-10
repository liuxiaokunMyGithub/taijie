//
//  GBMessageCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/13.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBMessageCell.h"

NSInteger const kIconTag = 2018731;

@interface GBMessageCell ()
/* <#describe#> */
@property (nonatomic, strong) UIView *redPoint;
@end

@implementation GBMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self.contentView addSubview:self.iconImageView];
		[self.contentView addSubview:self.nameLabel];
		[self.contentView addSubview:self.msgLabel];
		[self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.messageNumberLabel];
        [self.contentView addSubview:self.redPoint];
		[self p_addMasonry];
        
        self.iconImageView.tag = kIconTag;
        GBViewRadius(self.iconImageView, 24);
        GBViewRadius(self.redPoint, 4);

        GBViewRadius(self.messageNumberLabel, 11);
        self.selectionStyle =  UITableViewCellSelectionStyleNone;

	}
    
	return self;
}

- (void)setSystemMessageModel:(GBSystemMessageModel *)systemMessageModel {
    self.nameLabel.text = @"系统消息";
    [self.iconImageView setImage:GBImageNamed(@"icon_SystemMessage")];
    if (systemMessageModel.isRead) {
        [self.redPoint setHidden:NO];
    } else {
        [self.redPoint setHidden:YES];
    }
    
    self.msgLabel.text = systemMessageModel.content;

    self.timeLabel.text = [NSString compareCurrentTime:systemMessageModel.createTime];

}

- (void)setCellDataWithConversation:(JMSGConversation *)conversation {
    self.nameLabel.text = conversation.title;
    self.conversationId = [self conversationIdWithConversation:conversation];
    
    [conversation avatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (![objectId isEqualToString:self.conversationId]) {
            NSLog(@"out-of-order avatar");
            return ;
        }
        
        if (error == nil) {
            if (data != nil) {
                [self.iconImageView setImage:[UIImage imageWithData:data]];
            } else {
                if (conversation.conversationType == kJMSGConversationTypeSingle) {
                    [self.iconImageView setImage:PlaceholderHeadImage];
                } else {
                    [self.iconImageView setImage:PlaceholderHeadImage];
                }
            }
        } else {
            NSLog(@"会话头像 error: %@",error);
            
            [self.iconImageView setImage:PlaceholderHeadImage];
        }
    }];
    
    if ([conversation.unreadCount integerValue] > 0) {
        [self.messageNumberLabel setHidden:NO];
        self.messageNumberLabel.text = [NSString stringWithFormat:@"%@", conversation.unreadCount];
    } else {
        [self.messageNumberLabel setHidden:YES];
    }
    
    if (conversation.latestMessage.timestamp != nil ) {
        double time = [conversation.latestMessage.timestamp doubleValue];
        self.timeLabel.text = [NSString getFriendlyDateString:time forConversation:YES];
        
    } else {
        self.timeLabel.text = @"";
    }
    self.msgLabel.text = conversation.latestMessageContentText;
}

- (NSString *)conversationIdWithConversation:(JMSGConversation *)conversation {
    NSString *conversationId = nil;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user = conversation.target;
        conversationId = [NSString stringWithFormat:@"%@_%ld_%@",user.username, kJMSGConversationTypeSingle, conversation.targetAppKey];
    } else {
        JMSGGroup *group = conversation.target;
        conversationId = [NSString stringWithFormat:@"%@_%ld",group.gid,kJMSGConversationTypeGroup];
    }
    return conversationId;
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
	// 头像
	[self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(24);
		make.centerY.mas_equalTo(self.contentView);
		make.size.mas_equalTo(CGSizeMake(48,48));
	}];
    
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(-2);
        make.top.equalTo(self.iconImageView).offset(5);
        make.size.mas_equalTo(CGSizeMake(8,8));
    }];
    
	// 姓名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(12);
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.width.mas_equalTo(180);
    }];
    
	// 消息
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(12);
        make.right.mas_equalTo(self.messageNumberLabel.mas_left).mas_offset(-GBMargin/2);
        
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom);
    }];
    
	// 时间
	[self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-GBMargin);
        make.top.mas_equalTo(self.iconImageView.mas_top);
        make.width.mas_equalTo(120);
	}];
    
    // 时间
    [self.messageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-GBMargin);
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom);
        make.width.height.mas_equalTo(22);
    }];
}

#pragma mark - # Getters and Setters
- (UIImageView *)iconImageView {
	if (!_iconImageView) {
		_iconImageView = [[UIImageView alloc] init];
	}
	return _iconImageView;
}

- (UILabel *)nameLabel {
	if (!_nameLabel) {
		_nameLabel = [[UILabel alloc] init];
        _nameLabel.font = Fit_M_Font(17);
        _nameLabel.textColor = [UIColor kImportantTitleTextColor];
	}
	return _nameLabel;
}

- (UILabel *)msgLabel {
	if (!_msgLabel) {
		_msgLabel = [[UILabel alloc] init];
        _msgLabel.font = Fit_M_Font(14);
        _msgLabel.textColor = [UIColor kNormoalInfoTextColor];
	}
	return _msgLabel;
}

- (UILabel *)timeLabel {
	if (!_timeLabel) {
		_timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = Fit_M_Font(12);
        _timeLabel.textColor = [UIColor kAssistInfoTextColor];
	}
	return _timeLabel;
}

- (UILabel *)messageNumberLabel {
    if (!_messageNumberLabel) {
        _messageNumberLabel = [[UILabel alloc] init];
        _messageNumberLabel.textAlignment = NSTextAlignmentRight;
        _messageNumberLabel.font = Fit_M_Font(10);
        _messageNumberLabel.textColor = [UIColor whiteColor];
        _messageNumberLabel.backgroundColor = [UIColor colorWithHexString:@"#FF5858"];
        _messageNumberLabel.textAlignment = NSTextAlignmentCenter;
        _messageNumberLabel.hidden = YES;
    }
    
    return _messageNumberLabel;
}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [[UIView alloc] init];
        _redPoint.backgroundColor = [UIColor redColor];
        _redPoint.hidden = YES;
    }
    
    return _redPoint;
}

@end
