//
//  GBPersonalCertificationInfoCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPersonalCertificationInfoCell.h"

#import "GBCertificationCollectionViewCell.h"

static NSString *const kGBCertificationCollectionViewCellId = @"GBCertificationCollectionViewCell";

@interface GBPersonalCertificationInfoCell ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@end

@implementation GBPersonalCertificationInfoCell

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
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.backgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GBCertificationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGBCertificationCollectionViewCellId forIndexPath:indexPath];
    cell.titleLabel.text = self.certificatTitles[indexPath.row];
    cell.iconImageView.image = self.certificatIcons[indexPath.row];
    
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
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - GBMargin*3)/3, 94);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
        _collectionView.contentInset = UIEdgeInsetsMake(16, GBMargin, 0, GBMargin);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GBCertificationCollectionViewCell class] forCellWithReuseIdentifier:kGBCertificationCollectionViewCellId];
    }
    
    return _collectionView;
}

- (GBFindPeopleModel *)peopleModel {
    if (!_peopleModel) {
        _peopleModel = [[GBFindPeopleModel alloc] init];
    }
    
    return _peopleModel;
}

- (NSMutableArray *)certificatTitles {
    if (!_certificatTitles) {
        _certificatTitles = [[NSMutableArray alloc] initWithArray:@[@"芝麻信用",@"企业邮箱",@"工牌",@"在职证明",@"劳动合同"]];
    }
    
    return _certificatTitles;
}

@end
