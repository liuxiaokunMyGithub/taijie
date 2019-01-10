//
//  GBOrderRecodCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBOrderRecodCell.h"
#import "RKNotificationHub.h"

@interface GBOrderRecodCell ()

/* 类型标记 */
@property (nonatomic, strong) UIImageView *iconImageView;

/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 时间 */
@property (nonatomic, strong) UILabel *timeLabel;

/* 交易金额 */
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UIView *lineView;


@end

@implementation GBOrderRecodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self.contentView addSubview:self.iconImageView];
		[self.contentView addSubview:self.titleLabel];
		[self.contentView addSubview:self.timeLabel];
		[self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.stateButton];
        [self.contentView addSubview:self.lineView];
		[self p_addMasonry];
	}
	return self;
}

/** MARK: 交易流水记录 */
- (void)setRecodeModel:(TransactionListModel *)recodeModel {
    _recodeModel = recodeModel;
    
    self.timeLabel.text = recodeModel.createTime;
    self.titleLabel.text = recodeModel.title;

    if ([recodeModel.recerdStatus isEqualToString:@"IN"]) {
        /**增加*/
        self.moneyLabel.text = [NSString stringWithFormat:@"+ ￥%.f",recodeModel.amount];

    }else {
        self.moneyLabel.text = [NSString stringWithFormat:@"- ￥%.f",recodeModel.amount];
    }
    
    if ([recodeModel.recerdTypeName hasPrefix:@"保"]) {
        self.iconImageView.image = GBImageNamed(@"mine_recode_aursed");
    }else if ([recodeModel.recerdTypeName hasPrefix:@"问"]){
        self.iconImageView.image = GBImageNamed(@"mine_recode_decryption");
    }else {
        self.iconImageView.image = GBImageNamed(@"mine_recode_decryption");
    }
}

- (void)setOrderModel:(BuyOrderModel *)orderModel {
    _orderModel = orderModel;
    
//    [orderModel.discountType isEqualToString:@"FREE"] ? @"限免" : GBNSStringFormat(@"%zu币",orderModel.price)
    self.moneyLabel.text = GBNSStringFormat(@"%zu币",orderModel.amount);
    self.titleLabel.text = orderModel.title;
    self.timeLabel.text = orderModel.createTime;
    
    if ([orderModel.serviceType isEqualToString:@"GOODS_TYPE_BG"]) {
        self.iconImageView.image = GBImageNamed(@"mine_recode_aursed");
    }else if ([orderModel.serviceType isEqualToString:@"GOODS_TYPE_WD"]){
        self.iconImageView.image = GBImageNamed(@"mine_recode_decryption");
    }else {
        self.iconImageView.image = GBImageNamed(@"mine_recode_decryption");
    }
    
    [self.stateButton setTitle:orderModel.serviceStatusName forState:UIControlStateNormal];
    
    if ((self.roleOrderType == RoleOrderTypeBuyersPurchased && orderModel.isSubscriberConfirm) || (self.roleOrderType == RoleOrderTypeSellerService && orderModel.isVendorConfirm)) {
        RKNotificationHub *hubBadgeView = [[RKNotificationHub alloc]initWithView:self.iconImageView];
        [hubBadgeView moveCircleByX:5 Y:-5];
        [hubBadgeView setCircleColor:[UIColor redColor] labelColor:[UIColor redColor]];
        [hubBadgeView scaleCircleSizeBy:0.2];
        hubBadgeView.countLabelFont = Fit_Font(1);
        [hubBadgeView setCount:1];
    }
//    if ([orderModel.serviceStatus isEqualToString:@"TO_BE_CONFIRMED"]) {
//        [self.stateButton setTitle:@"待确认" forState:UIControlStateNormal];
//        [self.stateButton setTitleColor:[UIColor kYellowBgColor] forState:UIControlStateNormal];
//    }else if ([orderModel.serviceStatus isEqualToString:@"ONGOING"]) {
//        [self.stateButton setTitle:@"进行中" forState:UIControlStateNormal];
//        [self.stateButton setTitleColor:[UIColor kYellowBgColor] forState:UIControlStateNormal];
//    }else if ([orderModel.serviceStatus isEqualToString:@"FINISHED"]) {
//        [self.stateButton setTitle:@"已结束" forState:UIControlStateNormal];
//    }else {
//        [self.stateButton setTitle:@"已退款" forState:UIControlStateNormal];
//    }
//
    
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
	// 类型标记
	[self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(24);
		make.top.mas_equalTo(16);
		make.size.mas_equalTo(CGSizeMake(20,20));
	}];
    
    // 交易金额
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
	// 标题
	[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(8);
        make.right.mas_equalTo(self.moneyLabel.mas_left).mas_offset(-8);

		make.top.mas_equalTo(16);
		make.height.mas_equalTo(20);
	}];
	// 时间
	[self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(8);
		make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
		make.height.mas_equalTo(16);
	}];
    
    // 状态
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(16);
    }];
    
    
    // 分割线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark - # Getters and Setters
- (UIImageView *)iconImageView {
	if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:GBImageNamed(@"mine_recode_decryption")];
	}
    
	return _iconImageView;
}

- (UILabel *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [UILabel createLabelWithText:@"Java工程师" font:Fit_M_Font(14) textColor:[UIColor kNormoalInfoTextColor]];
	}
	return _titleLabel;
}

- (UILabel *)timeLabel {
	if (!_timeLabel) {
        _timeLabel = [UILabel createLabelWithText:@"08/20/2018 18:33" font:Fit_Font(12) textColor:[UIColor kAssistInfoTextColor]];
	}
	return _timeLabel;
}

- (UILabel *)moneyLabel {
	if (!_moneyLabel) {
		_moneyLabel = [UILabel createLabelWithText:@"+ 9999币" font:Fit_Font(14) textColor:[UIColor kYellowBgColor]];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
	}
	return _moneyLabel;
}

- (UIButton *)stateButton {
    if (!_stateButton) {
        _stateButton = [[UIButton alloc] init];
        _stateButton.titleLabel.font = Fit_Font(12);
        [_stateButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
    }
    
    return _stateButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _lineView;
}

@end
