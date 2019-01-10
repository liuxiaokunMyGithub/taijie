//
//  GBAssuredMasterTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBAssuredMasterTableViewCell.h"
#import "GBAssureMasterCardCell.h"
#import "GBCommonPersonalHomePageViewController.h"

@interface GBAssuredMasterTableViewCell ()<UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

static NSString *const kGBAssureMasterCardCellID = @"GBAssureMasterCardCell";

@implementation GBAssuredMasterTableViewCell

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
    
    _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);

}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assureMasters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GBAssureMasterCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGBAssureMasterCardCellID forIndexPath:indexPath];
    cell.masterCardCellType = self.masterCardCellType;
    cell.assureMasterModel = self.assureMasters[indexPath.row];

    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了%zd",indexPath.row);
    GBCommonPersonalHomePageViewController *homePageVC = [[GBCommonPersonalHomePageViewController alloc] init];
    homePageVC.targetUsrid = self.assureMasters[indexPath.row].userId;
    [[GBAppHelper getPushNavigationContr] pushViewController:homePageVC animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

#pragma mark - Setter Getter Methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.itemSize = CGSizeMake(SCREEN_WIDTH - GBMargin*2, 160);
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        [self addSubview:_collectionView];
        _collectionView.contentInset = UIEdgeInsetsMake(10, GBMargin, 0, GBMargin);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GBAssureMasterCardCell class] forCellWithReuseIdentifier:kGBAssureMasterCardCellID];
    }
    return _collectionView;
}


@end
