//
//  GBNewsOnePicCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBNewsOnePicCell.h"
#import "GBLIRLButton.h"

@interface GBNewsOnePicCell ()
/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* logo */
@property (nonatomic, strong) UIImageView *logoImageView;
/* 浏览 */
@property (nonatomic, strong) UIButton *lookButton;
/* 收藏 */
@property (nonatomic, strong) UIButton *collectionButton;
/*  */
@property (nonatomic, strong) UIView *line;

@end

@implementation GBNewsOnePicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.lookButton];
        [self.contentView addSubview:self.collectionButton];
        [self.contentView addSubview:self.line];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        GBViewRadius(self.logoImageView, 2);

    }
    
    return self;
}

- (void)setNewsModel:(GBNewsModel *)newsModel {
    _newsModel = newsModel;
    self.titleLabel.text = newsModel.title;
    [self.logoImageView sd_setImageWithURL:GBImageURL(newsModel.picture) placeholderImage:PlaceholderListImage];
    [self.lookButton setTitle:GBNSStringFormat(@"%@",newsModel.watchCount) forState:UIControlStateNormal];
    [self.collectionButton setTitle:GBNSStringFormat(@"%@",newsModel.starCount) forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@82);
        make.width.equalTo(@124);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.logoImageView.mas_left).offset(-GBMargin/2);
        make.height.greaterThanOrEqualTo(@40);
    }];
    
    [self.lookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.logoImageView).offset(5);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.logoImageView).offset(5);
        make.left.equalTo(self.lookButton.mas_right).offset(GBMargin);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel.font = Fit_Font(16);
        _titleLabel.text = @"[眼红] 盘点那些福利好到爆的公司！";
        _titleLabel.numberOfLines = 2;
    }
    
    return _titleLabel;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = PlaceholderListImage;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _logoImageView;
}

- (UIButton *)collectionButton {
    if (!_collectionButton) {
        _collectionButton = [[UIButton alloc] init];
        [_collectionButton setImage:GBImageNamed(@"icon_collection") forState:UIControlStateNormal];
        [_collectionButton setTitle:@"1111" forState:UIControlStateNormal];
        _collectionButton.titleLabel.font = Fit_Font(12);
        [_collectionButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        _collectionButton.userInteractionEnabled = NO;
    }
    
    return _collectionButton;
}

- (UIButton *)lookButton {
    if (!_lookButton) {
        _lookButton = [[UIButton alloc] init];
        [_lookButton setImage:GBImageNamed(@"icon_browse") forState:UIControlStateNormal];
        _lookButton.titleLabel.font = Fit_Font(12);
        [_lookButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        _lookButton.userInteractionEnabled = NO;
    }
    
    return _lookButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _line;
}

@end
