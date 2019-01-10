//
//  GBRankingTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBRankingTableViewCell.h"
#import "GBRankingItemCell.h"

@interface GBRankingTableViewCell ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@end

static NSString *const kGBRankingItemCellID = @"GBRankingItemCell";

@implementation GBRankingTableViewCell

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
    return self.ranks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GBRankingItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGBRankingItemCellID forIndexPath:indexPath];
    [cell.bgView sd_setImageWithURL:GBImageURL(self.ranks[indexPath.row].picture) placeholderImage:PlaceholderListImage];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GBBaseWebViewController *webView = nil;
    webView = [[GBBaseWebViewController alloc] initWithUrl:self.ranks[indexPath.row].link];
    webView.titleStr = @"排行榜";
    
    [webView.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_share_top")];
    [webView.customNavBar setOnClickRightButton:^{
        // 分享
        [KEYWINDOW addSubview:[ShareManagerInstance shareView]];
        ShareManagerInstance.shareTitle = @"排行榜";
        ShareManagerInstance.shareText = self.ranks[indexPath.row].rankMainName;
        ShareManagerInstance.shareUrl = self.ranks[indexPath.row].link;
        ShareManagerInstance.imageData = [UIImage getImageDataURL:GBImageURL(self.ranks[indexPath.row].sharePicture)];
        [[ShareManagerInstance shareView] showWithContentType:JSHARELink];
    }];
    
    [[GBAppHelper getPushNavigationContr] pushViewController:webView animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return GBMargin/2;
}

#pragma mark - Setter Getter Methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - GBMargin*2 - GBMargin/2)/2, 85);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
        _collectionView.contentInset = UIEdgeInsetsMake(0, GBMargin, 0, GBMargin);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GBRankingItemCell class] forCellWithReuseIdentifier:kGBRankingItemCellID];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)ranks {
    if (!_ranks) {
        _ranks = [[NSMutableArray alloc] init];
    }
    
    return _ranks;
}

@end
