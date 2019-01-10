//
//  GBFindColleaguesTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBFindColleaguesTableViewCell.h"
#import "GBColleaguesItemCell.h"
#import "GBCommonPersonalHomePageViewController.h"

@interface GBFindColleaguesTableViewCell ()<UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

static NSString *const kGBColleaguesItemCellID = @"GBColleaguesItemCell";

@implementation GBFindColleaguesTableViewCell

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
    return self.colleaguesModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GBColleaguesItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGBColleaguesItemCellID forIndexPath:indexPath];
    cell.colleaguesModel = self.colleaguesModels[indexPath.row];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了%zd",indexPath.row);
    GBCommonPersonalHomePageViewController *homePageVC = [[GBCommonPersonalHomePageViewController alloc] init];
    homePageVC.targetUsrid = self.colleaguesModels[indexPath.row].userId;
    [[GBAppHelper getPushNavigationContr] pushViewController:homePageVC animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

#pragma mark - Setter Getter Methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(Fit_W_H(120), 166);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
        _collectionView.contentInset = UIEdgeInsetsMake(0, GBMargin, 0, 15);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GBColleaguesItemCell class] forCellWithReuseIdentifier:kGBColleaguesItemCellID];
    }
    return _collectionView;
}


@end
