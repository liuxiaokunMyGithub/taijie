//
//  GBColleagueTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/29.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBColleagueTableViewCell.h"

@interface GBColleagueTableViewCell ()

/* 头像 */
@property (nonatomic, strong) UIImageView *headImageView;

/* 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;

/* 职位 */
@property (nonatomic, strong) UILabel *positionLabel;

/* 子标题 */
@property (nonatomic, strong) UILabel *subTitleLabel;

/* 满意度 */
@property (nonatomic, strong) UILabel *satisfactionLabel;

/* 满意度图标 */
@property (nonatomic, strong) UIImageView *satisfactionImageView;

@property (nonatomic, strong) UIImageView *vIcon;
@property (nonatomic, strong) UIImageView *assuredIcon;

@end

@implementation GBColleagueTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self.contentView addSubview:self.headImageView];
		[self.contentView addSubview:self.nameLabel];
		[self.contentView addSubview:self.positionLabel];
		[self.contentView addSubview:self.subTitleLabel];
		[self.contentView addSubview:self.satisfactionLabel];
		[self.contentView addSubview:self.satisfactionImageView];
        [self.contentView addSubview:self.vIcon];
        [self.contentView addSubview:self.assuredIcon];
    
		[self p_addMasonry];
	}
	return self;
}

#pragma mark - # Private Methods
- (void)p_addMasonry {
	// 头像
	[self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(24);
		make.top.mas_equalTo(24);
		make.size.mas_equalTo(CGSizeMake(40,40));
	}];
	// 姓名
	[self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.headImageView.mas_right).offset(12);
		make.top.mas_equalTo(self.headImageView);
		make.height.mas_equalTo(20);
	}];
	// 职位
	[self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.nameLabel);
		make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
		make.height.mas_equalTo(20);
	}];
	// 子标题
	[self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.nameLabel);
        make.top.equalTo(self.positionLabel.mas_bottom).offset(8);
		make.height.mas_equalTo(20);
	}];
	// 满意度
	[self.satisfactionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(-24);
		make.top.mas_equalTo(self.subTitleLabel);
		make.height.mas_equalTo(20);
	}];
	// 满意度图标
	[self.satisfactionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(-24);
		make.top.mas_equalTo(self.nameLabel);
		make.size.mas_equalTo(CGSizeMake(40,40));
	}];
    
    [self.vIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right);
        make.width.height.equalTo(@(20));
    }];
    
    [self.assuredIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vIcon);
        make.left.equalTo(self.vIcon.mas_right);
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];
}

- (void)setPeopleModel:(GBFindPeopleModel *)peopleModel {
    _peopleModel = peopleModel;
    self.nameLabel.text = peopleModel.nickName;
    self.subTitleLabel.text = GBNSStringFormat(@"%@ · %@", peopleModel.companyName,peopleModel.regionName);
    self.assuredIcon.hidden = peopleModel.hasAssurePassService;
    self.positionLabel.text = GBNSStringFormat(@"帮助过%zu人", peopleModel.helpedCount);
    
    [self.headImageView sd_setImageWithURL:GBImageURL(peopleModel.headImg) placeholderImage:PlaceholderHeadImage];
    
    GBViewRadius(self.headImageView, 20);
    
    // 满意度UI
    self.satisfactionLabel.text = GBNSStringFormat(@"%zu%@",peopleModel.degreeOfSatisfaction*100,@"%");
    
    if (peopleModel.degreeOfSatisfaction <= 0.4) {
        // 低
        self.satisfactionLabel.textColor = [UIColor colorWithHexString:@"#F47725"];
        self.satisfactionImageView.image = GBImageNamed(@"position_thermometer_low");
    }else if (peopleModel.degreeOfSatisfaction > 0.7) {
        // 高
        self.satisfactionLabel.textColor = [UIColor kBaseColor];
        self.satisfactionImageView.image = GBImageNamed(@"position_thermometer_medium");
        
    }else {
        // 中
        self.satisfactionLabel.textColor = [UIColor colorWithHexString:@"#2DC76D"];
        self.satisfactionImageView.image = GBImageNamed(@"position_thermometer_high");
    }
}

#pragma mark - # Getters and Setters
- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
        _headImageView.image = PlaceholderHeadImage;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
	}
	return _headImageView;
}

- (UILabel *)nameLabel {
	if (!_nameLabel) {
		_nameLabel = [[UILabel alloc] init];
		_nameLabel.text = @"刘小坤";
		_nameLabel.font = Fit_M_Font(17);
        _nameLabel.textColor = [UIColor kImportantTitleTextColor];
	}
	return _nameLabel;
}

- (UILabel *)positionLabel {
	if (!_positionLabel) {
		_positionLabel = [[UILabel alloc] init];
		_positionLabel.text = @"iOS开发";
        _positionLabel.font = Fit_Font(12);
        _positionLabel.textColor = [UIColor kNormoalInfoTextColor];
        
    }
	return _positionLabel;
}

- (UILabel *)subTitleLabel {
	if (!_subTitleLabel) {
		_subTitleLabel = [[UILabel alloc] init];
		_subTitleLabel.text = @"在职4年";
        _subTitleLabel.font = Fit_Font(12);
        _subTitleLabel.textColor = [UIColor kAssistInfoTextColor];
    }
	return _subTitleLabel;
}

- (UILabel *)satisfactionLabel {
	if (!_satisfactionLabel) {
		_satisfactionLabel = [[UILabel alloc] init];
		_satisfactionLabel.text = @"满意度 99%";
        _satisfactionLabel.font = Fit_Font(12);
        _satisfactionLabel.textColor = [UIColor kBaseColor];
	}
	return _satisfactionLabel;
}

- (UIImageView *)satisfactionImageView {
	if (!_satisfactionImageView) {
		_satisfactionImageView = [[UIImageView alloc] init];
        _satisfactionImageView.image = PlaceholderHeadImage;

	}
	return _satisfactionImageView;
}

- (UIImageView *)assuredIcon {
    if (!_assuredIcon) {
        _assuredIcon = [[UIImageView alloc] init];
        _assuredIcon.image = GBImageNamed(@"find_p_assuredIcon");
        
    }
    return _assuredIcon;
}

- (UIImageView *)vIcon {
    if (!_vIcon) {
        _vIcon = [[UIImageView alloc] init];
        _vIcon.image = GBImageNamed(@"find_p_V");
        
    }
    return _vIcon;
}

@end
