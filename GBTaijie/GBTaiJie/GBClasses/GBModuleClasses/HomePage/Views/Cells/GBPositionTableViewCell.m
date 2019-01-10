//
//  GBPositionTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPositionTableViewCell.h"

// 职位详情
#import "GBPositonDetailsViewController.h"

// Models
#import "GBPositionCommonModel.h"
// Views
#import "GBPositioinCell.h"

@interface GBPositionTableViewCell ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

/* 底部 */
@property (strong , nonatomic)UIView *bottomLineView;
/* <#describe#> */
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

static NSString *const GBPositioinCellID = @"GBPositioinCell";

@implementation GBPositionTableViewCell

#pragma mark - Intial
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.backgroundColor;
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
//    layout.itemSize = CGSizeMake(Fit_W_H(120), self.height);
    self.collectionView.frame = self.bounds;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.positionModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GBPositioinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GBPositioinCellID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    cell.positionModel = [self.positionModelArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 10) {
        !_didselectMoreBlock ? : _didselectMoreBlock();
        return;
    }
    
    NSLog(@"点击了职位%zd",indexPath.row);
    GBPositonDetailsViewController *positionDetailVC = [[GBPositonDetailsViewController alloc] init];
    positionDetailVC.positionModel = [self.positionModelArray objectAtIndex:indexPath.row];
    [[GBAppHelper getPushNavigationContr] pushViewController:positionDetailVC animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

#pragma mark - # Getter Setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(Fit_W_H(120), 166);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.contentInset = UIEdgeInsetsMake(10, GBMargin, 0, GBMargin);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GBPositioinCell class] forCellWithReuseIdentifier:GBPositioinCellID];
    }
    return _collectionView;
}

- (NSMutableArray *)positionModelArray {
    if (!_positionModelArray) {
        _positionModelArray = [[NSMutableArray alloc] init];
    }
    
    return _positionModelArray;
}

@end
