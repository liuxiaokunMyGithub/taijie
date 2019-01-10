//
//  GBPastExperienceTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/30.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPastExperienceTableViewCell.h"

@interface GBPastExperienceTableViewCell ()
@property (strong, nonatomic)UILabel *companyLabel;
@property (strong, nonatomic)UILabel *positionLabel;
@property (strong, nonatomic)UILabel *dateLabel;

@end

@implementation GBPastExperienceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    
    return self;
}

- (void)setPastExperienceModel:(GBPastExperienceModel *)pastExperienceModel {
    _pastExperienceModel = pastExperienceModel;
    
    self.companyLabel.text = pastExperienceModel.companyName;
    self.positionLabel.text = pastExperienceModel.positionName;
    self.dateLabel.text = GBNSStringFormat(@"%@ 至 %@",pastExperienceModel.startTime,pastExperienceModel.endTime);
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *companyLabel= [[UILabel alloc]init];
    companyLabel.font = Fit_Font(16);
    companyLabel.numberOfLines = 0;
    companyLabel.textColor = [UIColor kImportantTitleTextColor];
    
    [self.contentView addSubview:companyLabel];
    _companyLabel = companyLabel;
    
    UILabel *positionLabel = [[UILabel alloc]init];
    positionLabel.font = Fit_Font(12);
    positionLabel.textColor = [UIColor kAssistInfoTextColor];
    [self.contentView addSubview:positionLabel];
    _positionLabel = positionLabel;
    
    UILabel *date = [[UILabel alloc]init];
    date.font = Fit_Font(12);
    date.textColor = [UIColor kAssistInfoTextColor];
    [self.contentView addSubview:date];
    _dateLabel = date;
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor kBaseColor];
    [self.contentView addSubview:line];
    self.line = line;
    
    UIView *point = [[UIView alloc] init];
    point.backgroundColor = [UIColor kBaseColor];
    [self.contentView addSubview:point];
    self.point = point;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.point mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.companyLabel);
        make.left.equalTo(self).offset(GBMargin);
        make.height.width.mas_equalTo(6);
    }];
    
    GBViewRadius(self.point, 3);
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.point.mas_right).offset(16);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyLabel);
        make.right.equalTo(self.companyLabel);
        make.top.equalTo(self.companyLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(@20);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.centerY.equalTo(self.positionLabel);
        make.height.mas_equalTo(@20);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.point);
        make.bottom.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.point.mas_bottom).offset(10);
        make.width.mas_equalTo(@1);
    }];
}

@end
