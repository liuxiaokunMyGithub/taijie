//
//  GBSystemMessageCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBSystemMessageCell.h"

@interface GBSystemMessageCell ()
/* <#describe#> */
@property (nonatomic, strong) UIView *bgView;
/* 分割线 */
@property (nonatomic, strong) UIView *lineView;
/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* 子标题 */
@property (nonatomic, strong) UILabel *subTitleLabel;
/* 子标题 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 价格 */
@property (nonatomic, strong) UILabel *lookLabel;

@end

@implementation GBSystemMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bgView];
        
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.subTitleLabel];
        [self.bgView addSubview:self.timeLabel];
        [self.bgView addSubview:self.lookLabel];
        [self.bgView addSubview:self.lineView];
        
        [self p_addMasonry];
        
        GBViewRadius(self.lineView, 2);
        GBViewBorderRadius(self.bgView, 2, 1, [UIColor kSegmentateLineColor]);
    }
    return self;
}

- (void)setSystemMessageModel:(GBSystemMessageModel *)systemMessageModel {
    _systemMessageModel = systemMessageModel;
    self.titleLabel.text = systemMessageModel.titie;
    self.subTitleLabel.text = systemMessageModel.content;
    self.timeLabel.text = [NSString compareCurrentTime:systemMessageModel.createTime];
    self.lookLabel.text = [systemMessageModel.action isEqualToString:@"GET"] ? @"点击领取" : @"点击查看";
    self.lineView.backgroundColor = systemMessageModel.isRead ? [UIColor kSegmentateLineColor] : [UIColor kBaseColor];
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
        make.right.mas_equalTo(self.contentView).offset(-GBMargin);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    // 分割线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.height.mas_equalTo(@6);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.equalTo(self.bgView).offset(-16);
        make.top.equalTo(self.lineView.mas_bottom).offset(GBMargin/2);
    }];
    
    // 子标题
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.equalTo(self.bgView).offset(-16);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    // 时间
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-16);
        make.bottom.mas_equalTo(-GBMargin/2);
    }];
    
    // 按钮
    [self.lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(16);
        make.bottom.equalTo(self.timeLabel.mas_bottom);
    }];
    
    
}

#pragma mark - # Getters and Setters
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor kBaseColor];
    }
    
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Fit_Font(16);
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor kAssistInfoTextColor];
        _subTitleLabel.font = Fit_Font(12);
    }
    return _subTitleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor kAssistInfoTextColor];
        _timeLabel.font = Fit_Font(12);
    }
    return _timeLabel;
}

- (UILabel *)lookLabel {
    if (!_lookLabel) {
        _lookLabel = [[UILabel alloc] init];
        _lookLabel.textColor = [UIColor kBaseColor];
        _lookLabel.font = Fit_Font(14);
        _lookLabel.text = @"点击查看";
    }
    return _lookLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    
    return _bgView;
}

@end
