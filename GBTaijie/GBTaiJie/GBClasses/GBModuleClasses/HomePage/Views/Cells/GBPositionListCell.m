//
//  GBPositionListCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/28.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPositionListCell.h"

#import "HXTagsView.h"

@interface GBPositionListCell ()
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

/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;

@end

@implementation GBPositionListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.positionLabel];
        [self.contentView addSubview:self.companyLogoImageView];
        [self.contentView addSubview:self.companyLabel];
        [self.contentView addSubview:self.priceLabel];
        
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.segmentateLine];
        [self setupTagView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setPositionModel:(GBPositionModel *)positionModel {
    _positionModel = positionModel;
    self.positionLabel.text =  positionModel.positionName;
    self.priceLabel.text = GBNSStringFormat(@"%zuk-%zuk",positionModel.minSalary,positionModel.maxSalary);
    self.companyLabel.text =  positionModel.companyFullName;
    [self.companyLogoImageView sd_setImageWithURL:GBImageURL(positionModel.companyLogo) placeholderImage:PlaceholderListImage];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        if (ValidStr(positionModel.requiredExperience)) {
            [tempArray addObject:positionModel.requiredExperience];
        }
        
        if (ValidStr(positionModel.requiredEducation)) {
            [tempArray addObject:positionModel.requiredEducation];
        }
        
        if (tempArray.count > 0) {
            self.tagsView.tags = tempArray;
            [self.tagsView reloadData];
        }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.segmentateLine.hidden = YES;
    
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
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
    
    
    
    [self.companyLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.positionLabel);
        make.width.equalTo(@80);
        make.height.equalTo(@60);
        make.right.equalTo(self.contentView).offset(-GBMargin);
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
    //    model.borderColor  = kClearColor;
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
