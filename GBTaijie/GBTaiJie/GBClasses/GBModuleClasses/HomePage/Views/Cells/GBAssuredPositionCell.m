//
//  GBAssuredPositionCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBAssuredPositionCell.h"
#import "GBLIRLButton.h"
#import "HXTagsView.h"

@interface GBAssuredPositionCell ()
/* 职位 */
@property (nonatomic, strong) UILabel *positionLabel;
/* 公司logo */
@property (nonatomic, strong) UIImageView *companyLogoImageView;

/* 价格 */
@property (nonatomic, strong) UILabel *priceLabel;

/*  */
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *segmentateLine;

/* 公司 */
@property (nonatomic, strong) UILabel *companyLabel;

/* 收藏 */
@property (nonatomic, strong) GBLIRLButton *collectionButton;

/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;

@end

@implementation GBAssuredPositionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.positionLabel];
        [self.contentView addSubview:self.companyLogoImageView];
        [self.contentView addSubview:self.companyLabel];
        [self.contentView addSubview:self.priceLabel];

        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.collectionButton];
        [self.contentView addSubview:self.segmentateLine];
        [self setupTagView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        GBViewRadius(self.companyLogoImageView, 2);
        
    }
    
    return self;
}

- (void)setPositionModel:(GBPositionModel *)positionModel {
    _positionModel = positionModel;
    self.positionLabel.text = self.positionCellType == PositionCellTypeCompanySearch || self.positionCellType == PositionCellTypeCompanyHome ? positionModel.positionName : positionModel.jobName;
    self.priceLabel.text = GBNSStringFormat(@"%zdk-%zdk",positionModel.minSalary,positionModel.maxSalary);
    self.companyLabel.text = self.positionCellType == PositionCellTypeCompanySearch || self.positionCellType == PositionCellTypeCompanyHome ? positionModel.company[@"companyFullName"] : positionModel.targetCompanyName;
    [self.collectionButton setTitle:GBNSStringFormat(@"%zd",positionModel.watchCount) forState:UIControlStateNormal];
    
    
    if (self.positionCellType == PositionCellTypeHomePage) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSMutableArray *tempNormalBackgroundColors = [NSMutableArray array];
        NSMutableArray *coustomNormalTitleColors = [NSMutableArray array];
        
        if (ValidStr(positionModel.experienceName)) {
            [tempArray addObject:positionModel.experienceName];
            [tempNormalBackgroundColors addObject:[UIColor colorWithHexString:@"#ECECF8"]];
            [coustomNormalTitleColors addObject:[UIColor kBaseColor]];
        }
        
        if (ValidStr(positionModel.dilamorName)) {
            [tempArray addObject:positionModel.dilamorName];
            [tempNormalBackgroundColors addObject:[UIColor colorWithHexString:@"#ECECF8"]];
            [coustomNormalTitleColors addObject:[UIColor kBaseColor]];
        }
        [tempArray addObject:@"保过"];
        [tempNormalBackgroundColors addObject:[UIColor colorWithHexString:@"#EDF8EC"]];
        
        [coustomNormalTitleColors addObject:[UIColor colorWithHexString:@"#28B261"]];
        
        if (tempArray.count > 0) {
            self.tagsView.tags = tempArray;
            self.tagsView.coustomNormalBackgroundColors = tempNormalBackgroundColors;
            self.tagsView.coustomNormalTitleColors = coustomNormalTitleColors;
            [self.tagsView reloadData];
        }
        
        [self.companyLogoImageView sd_setImageWithURL:GBImageURL(positionModel.targetCompanyLogo) placeholderImage:PlaceholderListImage];
    }else {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSMutableArray *tempNormalBackgroundColors = [NSMutableArray array];
        NSMutableArray *coustomNormalTitleColors = [NSMutableArray array];
        if (ValidStr(positionModel.requiredExperience)) {
            [tempArray addObject:positionModel.requiredExperience];
            [tempNormalBackgroundColors addObject:[UIColor colorWithHexString:@"#ECECF8"]];
            [coustomNormalTitleColors addObject:[UIColor kBaseColor]];
        }
        
        if (ValidStr(positionModel.requiredEducation)) {
            [tempArray addObject:positionModel.requiredEducation];
            [tempNormalBackgroundColors addObject:[UIColor colorWithHexString:@"#ECECF8"]];
            [coustomNormalTitleColors addObject:[UIColor kBaseColor]];
        }
        
        //        if (self.positionCellType == PositionCellTypeCompanySearch) {
        //            [tempArray addObject:@"保过"];
        //            [tempNormalBackgroundColors addObject:[UIColor colorWithHexString:@"#EDF8EC"]];
        //        }
        
        [coustomNormalTitleColors addObject:[UIColor colorWithHexString:@"#28B261"]];
        if (tempArray.count > 0) {
            self.tagsView.tags = tempArray;
            self.tagsView.coustomNormalBackgroundColors = tempNormalBackgroundColors;
            self.tagsView.coustomNormalTitleColors = coustomNormalTitleColors;
            
            [self.tagsView reloadData];
        }
        
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.positionCellType == PositionCellTypeCompanySearch || self.positionCellType == PositionCellTypeCompanyHome) {
        // 公司搜索-职位cell
        self.companyLogoImageView.hidden = YES;
        self.segmentateLine.hidden = YES;
        
        [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(GBMargin);
            make.top.equalTo(self.contentView).offset(8);
            make.height.mas_equalTo(20);
            make.right.equalTo(self.contentView).offset(-GBMargin);
        }];
        
        [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(GBMargin);
            make.top.equalTo(self.positionLabel.mas_bottom).offset(8);
            make.height.greaterThanOrEqualTo(@20);
            make.right.equalTo(self.contentView).offset(-GBMargin);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.positionLabel);
            make.height.equalTo(@20);
            make.right.equalTo(self.contentView).offset(-GBMargin);
        }];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(GBMargin);
            make.bottom.equalTo(self.contentView).offset(-3);
            make.height.equalTo(@0.5);
            make.right.equalTo(self.contentView).offset(-GBMargin);
        }];
        
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(GBMargin);
            make.top.equalTo(self.tagsView.mas_bottom).offset(5);
            make.height.equalTo(@30);
        }];
        
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.companyLabel);
            make.height.equalTo(@30);
            make.right.equalTo(self.contentView).offset(-GBMargin);
        }];
        
        return;
    }
    
    [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.top.equalTo(self.contentView).offset(16);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.companyLogoImageView.mas_left).offset(-GBMargin/2);
    }];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.top.equalTo(self.positionLabel.mas_bottom).offset(8);
        make.height.greaterThanOrEqualTo(@20);
        make.right.equalTo(self.companyLogoImageView.mas_left).offset(-GBMargin/2);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.top.equalTo(self.tagsView.mas_bottom).offset(8);
        make.height.equalTo(@20);
        make.right.equalTo(self.companyLogoImageView.mas_left).offset(-GBMargin/2);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(8);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.top.equalTo(self.line.mas_bottom).offset(5);
        make.height.equalTo(@30);
    }];
    
    [self.companyLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.positionLabel);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(5);
        make.height.equalTo(@30);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    [self.segmentateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@6);
        make.right.equalTo(self.contentView);
    }];
}

- (void)setupTagView {
    self.tagsView.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
        NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
    };
    self.tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.tagsView.layout.itemSize = CGSizeMake(100, 20);
    HXTagAttribute *model = [[HXTagAttribute alloc]init];
    model.borderWidth  = 0;
    model.cornerRadius  = 2;
    model.titleSize  = 12;
    model.textColor  = [UIColor kBaseColor];
    model.normalBackgroundColor  = [UIColor colorWithHexString:@"#ECECF8"];
    model.tagSpace  = 15;
    
    self.tagsView.tagAttribute = model;
    
    [self.tagsView reloadData];
    
    [self.contentView addSubview:self.tagsView];

}

- (UILabel *)positionLabel {
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.textColor = [UIColor kImportantTitleTextColor];
        _positionLabel.text = @"iOS工程师";
        _positionLabel.font = Fit_Font(16);
    }
    return _positionLabel;
}

- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.textColor = [UIColor kAssistInfoTextColor];
        _companyLabel.font = Fit_Font(12);
        _companyLabel.text = @"隔壁科技";
    }
    return _companyLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor kPromptRedColor];
        _priceLabel.text = @"10 - 15k";
        _priceLabel.font = Fit_B_Font(14);
    }
    return _priceLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _line;
}

- (UIImageView *)companyLogoImageView {
    if (!_companyLogoImageView) {
        _companyLogoImageView = [[UIImageView alloc] init];
        _companyLogoImageView.image = PlaceholderListImage;
        _companyLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _companyLogoImageView;
}

- (GBLIRLButton *)collectionButton {
    if (!_collectionButton) {
        _collectionButton = [[GBLIRLButton alloc] init];
        [_collectionButton setImage:GBImageNamed(@"icon_interesting") forState:UIControlStateNormal];
        [_collectionButton setTitle:@"1111" forState:UIControlStateNormal];
        _collectionButton.titleLabel.font = Fit_Font(12);
        [_collectionButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
    }
    
    return _collectionButton;
}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] init];
//        _tagsView.backgroundColor = [UIColor redColor];
        _tagsView.userInteractionEnabled = NO;
    }
    
    return _tagsView;
}

- (UIView *)segmentateLine {
    if (!_segmentateLine) {
        _segmentateLine = [[UIView alloc] init];
        _segmentateLine.backgroundColor = [UIColor kTitleColorBG];
    }
    
    return _segmentateLine;
}

@end
