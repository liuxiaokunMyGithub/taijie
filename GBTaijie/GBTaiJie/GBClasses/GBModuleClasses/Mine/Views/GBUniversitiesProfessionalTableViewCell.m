//
//  GBUniversitiesProfessionalTableViewCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBUniversitiesProfessionalTableViewCell.h"
#import "GBProvincesViewController.h"

#import "GBUniversitiesDomesticItemCell.h"

static NSString *const kGBUniversitiesDomesticItemCellID = @"GBUniversitiesDomesticItemCell";
static NSString *const kGBUniversitiesOverseasItemCellID = @"GBUniversitiesOverseasItemCell";

@interface GBUniversitiesProfessionalTableViewCell ()<UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/* describe */
@property (nonatomic, strong) NSArray *titles;

@end

@implementation GBUniversitiesProfessionalTableViewCell

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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        GBUniversitiesDomesticItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGBUniversitiesDomesticItemCellID forIndexPath:indexPath];
        cell.valueLabel1.text = self.educationDomesticModel.pcname;
        cell.valueLabel2.text = self.educationDomesticModel.universityName;
        cell.valueLabel3.text = self.educationDomesticModel.majorName;
        
        return cell;
    }
    
    GBUniversitiesOverseasItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGBUniversitiesOverseasItemCellID forIndexPath:indexPath];
    
    cell.valueTextField1.text = self.educationOverseasModel.pcname;
    cell.valueTextField2.text = self.educationOverseasModel.universityName;
    cell.valueTextField3.text = self.educationOverseasModel.majorName;
    self.overseasItemCell = cell;
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GBProvincesViewController *provincesVC = [[GBProvincesViewController alloc] init];
        provincesVC.educationExperienceModel = self.educationDomesticModel;
        [[GBAppHelper getPushNavigationContr] pushViewController:provincesVC animated:YES];
    }
}

#pragma mark - Setter Getter Methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, 200);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GBUniversitiesDomesticItemCell class] forCellWithReuseIdentifier:kGBUniversitiesDomesticItemCellID];
        [_collectionView registerClass:[GBUniversitiesOverseasItemCell class] forCellWithReuseIdentifier:kGBUniversitiesOverseasItemCellID];
    }
    
    return _collectionView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"好评率",@"服务人数",@"及时性",@"专业性",@"接单率"];
    }
    
    return _titles;
}

- (GBEducationExperienceModel *)educationDomesticModel {
    if (!_educationDomesticModel) {
        _educationDomesticModel = [[GBEducationExperienceModel alloc] init];
    }
    
    return _educationDomesticModel;
}

- (GBEducationExperienceModel *)educationOverseasModel {
    if (!_educationOverseasModel) {
        _educationOverseasModel = [[GBEducationExperienceModel alloc] init];
    }
    
    return _educationOverseasModel;
}

@end
