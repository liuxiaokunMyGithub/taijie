//
//  GBWithdrawalRecordCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/6.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBWithdrawalRecordCell.h"

@interface GBWithdrawalRecordCell ()
/* 背景视图 */
@property (nonatomic, strong) UIView *bgView;
/* 蓝色标识 */
@property (nonatomic, strong) UIView *flagView;
/* title1 */
@property (strong , nonatomic) UILabel *titleLabel1;
/* title2 */
@property (strong , nonatomic) UILabel *titleLabel2;
/* title3 */
@property (strong , nonatomic) UILabel *titleLabel3;
/* title4 */
@property (strong , nonatomic) UILabel *titleLabel4;
/* title5 */
@property (strong , nonatomic) UILabel *titleLabel5;
/* title6 */
@property (strong , nonatomic) UILabel *titleLabel6;

/* subTitle1 */
@property (strong , nonatomic) UILabel *subTitle1;
/* subTitle2 */
@property (strong , nonatomic) UILabel *subTitle2;
/* subTitle3 */
@property (strong , nonatomic) UILabel *subTitle3;
/* subTitle4 */
@property (strong , nonatomic) UILabel *subTitle4;
/* subTitle5 */
@property (strong , nonatomic) UILabel *subTitle5;
/* subTitle6 */
@property (strong , nonatomic) UILabel *subTitle6;

@end

@implementation GBWithdrawalRecordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setupSubView {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.flagView];
    [self.bgView addSubview:self.titleLabel1];
    [self.bgView addSubview:self.titleLabel2];
    [self.bgView addSubview:self.titleLabel3];
    [self.bgView addSubview:self.titleLabel4];
    [self.bgView addSubview:self.titleLabel5];
    [self.bgView addSubview:self.titleLabel6];
    [self.bgView addSubview:self.subTitle1];
    [self.bgView addSubview:self.subTitle2];
    [self.bgView addSubview:self.subTitle3];
    [self.bgView addSubview:self.subTitle4];
    [self.bgView addSubview:self.subTitle5];
    [self.bgView addSubview:self.subTitle6];
    
    GBViewBorderRadius(self.bgView, 2, 0.5, [UIColor kSegmentateLineColor]);
}

- (void)setupTitleStr:(NSArray *)titles {
    self.titleLabel1.text = titles[0];
    self.titleLabel2.text = titles[1];
    self.titleLabel3.text = titles[2];
    self.titleLabel4.text = titles[3];
    self.titleLabel5.text = titles[4];
    self.titleLabel6.text = titles[5];

}

- (void)setWithdrawalRecordModel:(GBWithdrawalRecordModel *)withdrawalRecordModel {
    _withdrawalRecordModel = withdrawalRecordModel;
    self.subTitle1.text = withdrawalRecordModel.createTime;
    self.subTitle2.text = withdrawalRecordModel.reviewedTime;
    self.subTitle3.text = GBNSStringFormat(@"人民币%zu元",withdrawalRecordModel.amount);
    self.subTitle4.text = withdrawalRecordModel.state;
    self.subTitle5.text = @"支付宝";
    self.subTitle6.text = withdrawalRecordModel.alipayAccount;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.flagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel1);
        make.left.mas_equalTo(self.bgView);
        make.height.mas_equalTo(GBMargin/2);
        make.width.mas_equalTo(2);
    }];
    
    [self.titleLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(GBMargin/2);
        make.top.mas_equalTo(self.bgView).offset(GBMargin/2);
        make.width.mas_equalTo(@80);
    }];
    
    [self.subTitle1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel1.mas_right).offset(GBMargin/2);
        make.top.mas_equalTo(self.bgView).offset(GBMargin/2);
        make.right.mas_equalTo(self.bgView).offset(-GBMargin);
    }];
    
    [self.titleLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(GBMargin/2);
        make.top.mas_equalTo(self.titleLabel1.mas_bottom).offset(8);
        make.width.mas_equalTo(@80);
    }];
    
    [self.subTitle2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel1.mas_right).offset(GBMargin/2);
        make.top.mas_equalTo(self.titleLabel1.mas_bottom).offset(8);
        make.right.mas_equalTo(self.bgView).offset(-GBMargin);
    }];
    
    [self.titleLabel3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(GBMargin/2);
        make.top.mas_equalTo(self.titleLabel2.mas_bottom).offset(8);
        make.width.mas_equalTo(@80);
    }];
    
    [self.subTitle3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel1.mas_right).offset(GBMargin/2);
        make.top.mas_equalTo(self.titleLabel2.mas_bottom).offset(8);
        make.right.mas_equalTo(self.bgView).offset(-GBMargin);
    }];
    
    [self.titleLabel4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(GBMargin/2);
        make.top.mas_equalTo(self.titleLabel3.mas_bottom).offset(8);
        make.width.mas_equalTo(@80);
    }];
    
    [self.subTitle4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel1.mas_right).offset(GBMargin/2);
        make.top.mas_equalTo(self.titleLabel3.mas_bottom).offset(8);
        make.right.mas_equalTo(self.bgView).offset(-GBMargin);
    }];
    
    [self.titleLabel5 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(GBMargin/2);
        make.top.mas_equalTo(self.titleLabel4.mas_bottom).offset(8);
        make.width.mas_equalTo(@80);
    }];
    
    [self.subTitle5 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel1.mas_right).offset(GBMargin/2);
        make.top.mas_equalTo(self.titleLabel4.mas_bottom).offset(8);
        make.right.mas_equalTo(self.bgView).offset(-GBMargin);
    }];
    
    [self.titleLabel6 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(GBMargin/2);
        make.top.mas_equalTo(self.titleLabel5.mas_bottom).offset(8);
        make.width.mas_equalTo(@80);
    }];
    
    [self.subTitle6 mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.titleLabel1.mas_right).offset(GBMargin/2);
        make.top.mas_equalTo(self.titleLabel5.mas_bottom).offset(8);
        make.right.mas_equalTo(self.bgView).offset(-GBMargin);
    }];
}

#pragma mark - # Getters and Setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    
    return _bgView;
}

- (UIView *)flagView {
    if (!_flagView) {
        _flagView = [[UIView alloc] init];
        _flagView.backgroundColor = [UIColor kBaseColor];
    }
    
    return _flagView;
}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.textColor = [UIColor kAssistInfoTextColor];
        _titleLabel1.font = Fit_Font(14);
        _titleLabel1.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _titleLabel1;
}

- (UILabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [[UILabel alloc] init];
        _titleLabel2.textColor = [UIColor kAssistInfoTextColor];
        _titleLabel2.font = Fit_Font(14);
        _titleLabel2.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _titleLabel2;
}

- (UILabel *)titleLabel3 {
    if (!_titleLabel3) {
        _titleLabel3 = [[UILabel alloc] init];
        _titleLabel3.textColor = [UIColor kAssistInfoTextColor];
        _titleLabel3.font = Fit_Font(14);
        _titleLabel3.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _titleLabel3;
}
- (UILabel *)titleLabel4 {
    if (!_titleLabel4) {
        _titleLabel4 = [[UILabel alloc] init];
        _titleLabel4.textColor = [UIColor kAssistInfoTextColor];
        _titleLabel4.font = Fit_Font(14);
        _titleLabel4.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _titleLabel4;
}
- (UILabel *)titleLabel5 {
    if (!_titleLabel5) {
        _titleLabel5 = [[UILabel alloc] init];
        _titleLabel5.textColor = [UIColor kAssistInfoTextColor];
        _titleLabel5.font = Fit_Font(14);
        _titleLabel5.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _titleLabel5;
}
- (UILabel *)titleLabel6 {
    if (!_titleLabel6) {
        _titleLabel6 = [[UILabel alloc] init];
        _titleLabel6.textColor = [UIColor kAssistInfoTextColor];
        _titleLabel6.font = Fit_Font(14);
        _titleLabel6.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _titleLabel6;
}

- (UILabel *)subTitle1 {
    if (!_subTitle1) {
        _subTitle1 = [[UILabel alloc] init];
        _subTitle1.textColor = [UIColor kImportantTitleTextColor];
        _subTitle1.font = Fit_Font(14);
        _subTitle1.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _subTitle1;
}

- (UILabel *)subTitle2 {
    if (!_subTitle2) {
        _subTitle2 = [[UILabel alloc] init];
        _subTitle2.textColor = [UIColor kImportantTitleTextColor];
        _subTitle2.font = Fit_Font(14);
        _subTitle2.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _subTitle2;
}

- (UILabel *)subTitle3 {
    if (!_subTitle3) {
        _subTitle3 = [[UILabel alloc] init];
        _subTitle3.textColor = [UIColor kImportantTitleTextColor];
        _subTitle3.font = Fit_Font(14);
        _subTitle3.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _subTitle3;
}

- (UILabel *)subTitle4 {
    if (!_subTitle4) {
        _subTitle4 = [[UILabel alloc] init];
        _subTitle4.textColor = [UIColor kImportantTitleTextColor];
        _subTitle4.font = Fit_Font(14);
        _subTitle4.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _subTitle4;
}
- (UILabel *)subTitle5 {
    if (!_subTitle5) {
        _subTitle5 = [[UILabel alloc] init];
        _subTitle5.textColor = [UIColor kImportantTitleTextColor];
        _subTitle5.font = Fit_Font(14);
        _subTitle5.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _subTitle5;
}
- (UILabel *)subTitle6 {
    if (!_subTitle6) {
        _subTitle6 = [[UILabel alloc] init];
        _subTitle6.textColor = [UIColor kImportantTitleTextColor];
        _subTitle6.font = Fit_Font(14);
        _subTitle6.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _subTitle6;
}

@end
