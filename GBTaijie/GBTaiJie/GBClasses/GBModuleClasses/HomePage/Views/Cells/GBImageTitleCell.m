//
//  GBImageTitleCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBImageTitleCell.h"

@interface GBImageTitleCell ()<SDCycleScrollViewDelegate>

/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GBImageTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.cycleScrollView];
        [self.contentView addSubview:self.titleLabel];
        [self addMasonry];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        GBViewRadius(self.cycleScrollView, 2);

    }
    
    return self;
}

- (void)setBanner:(GBBannerModel *)banner {
    _banner = banner;
    self.titleLabel.text = banner.detail;
}

- (void)addMasonry {
    // 图片
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.height.mas_equalTo(Fit_W_H(124));
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView);

    }];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了%zd轮播图",index);
    if (self.didClickedBlock) {
        self.didClickedBlock(index);
    }
}

#pragma mark - # Getters and Setters
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(GBMargin, 0, self.width-GBMargin*2, Fit_W_H(160)) delegate:self placeholderImage:GBImageNamed(@"LaunchScreen_H")];
        _cycleScrollView.autoScrollTimeInterval = 5.0;
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_cycleScrollView];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"icon_cycle"];
        _cycleScrollView.pageDotImage =  [UIImage imageNamed:@"icon_point"];
        _cycleScrollView.pageControlRightOffset = Fit_W_H(5);
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    }
    
    return _cycleScrollView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Fit_L_Font(10);
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
    }
    return _titleLabel;
}
@end
