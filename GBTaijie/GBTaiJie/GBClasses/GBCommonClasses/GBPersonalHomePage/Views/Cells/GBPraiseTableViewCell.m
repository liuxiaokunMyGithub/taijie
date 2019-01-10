//
//  GBPraiseTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPraiseTableViewCell.h"
#import "GBPraiseItemCell.h"
#import "GBCommonPersonalHomePageViewController.h"

@interface GBPraiseTableViewCell ()<UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/* describe */
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *textColors;
@property (nonatomic, strong) NSArray *bgColors;

@end

static NSString *const kGBPraiseItemCellID = @"GBPraiseItemCell";

@implementation GBPraiseTableViewCell

#pragma mark - Intial
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.backgroundColor;
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GBPraiseItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGBPraiseItemCellID forIndexPath:indexPath];

    cell.titleLabel.text = self.praises[indexPath.row];
    cell.titleLabel1.text = self.titles[indexPath.row];

    cell.titleLabel.textColor = [UIColor colorWithHexString:self.textColors[indexPath.row]];
    cell.titleLabel1.textColor = [UIColor colorWithHexString:self.textColors[indexPath.row]];
    cell.bgView.backgroundColor = [UIColor colorWithHexString:self.bgColors[indexPath.row]];
    cell.lineView.backgroundColor = [UIColor colorWithHexString:self.textColors[indexPath.row]];

    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

#pragma mark - Setter Getter Methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(Fit_W_H(110), 86);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 95);
        _collectionView.contentInset = UIEdgeInsetsMake(0, GBMargin, 0, GBMargin);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GBPraiseItemCell class] forCellWithReuseIdentifier:kGBPraiseItemCellID];
    }
    return _collectionView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"好评率",@"服务人数",@"及时性",@"专业性",@"接单率"];
    }
    
    return _titles;
}

- (NSArray *)textColors {
    if (!_textColors) {
        _textColors = @[@"#C68C33",@"#FA513B",@"#28B261",@"#755FEF",@"#C68C33"];
    }
    
    return _textColors;
}

- (NSArray *)bgColors {
    if (!_bgColors) {
        _bgColors = @[@"#F7EEE1",@"#F4E7E7",@"#E4F1E9",@"#ECECF8",@"#F7EEE1"];
    }
    
    return _bgColors;
}

- (NSMutableArray *)praises {
    if (!_praises) {
        _praises = [[NSMutableArray alloc] init];
    }
    
    return _praises;
}

@end
