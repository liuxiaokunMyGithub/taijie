//
//  GBAddDecryptionServiceViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/20.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 添加解密服务
//  @discussion <#类的功能#>
//

#import "GBAddDecryptionServiceViewController.h"

// Controllers
#import "GBDiscountLimitFreeViewController.h"
// ViewModels


// Models
#import "GBServiceEditModel.h"

// Views
#import "GBSectionHeadView.h"
#import "GBPersonalSectionHeadView.h"
#import "GBSettingCell.h"
#import "FSTextView.h"
#import "GBLIRLButton.h"
#import "HXTagsView.h"
#import "XKTextField.h"
#import "HXTagsCell.h"
#import "GBDecryptionContentCell.h"
#import "GBAddOtherDecryptionTagCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBDecryptionContentCellID = @"GBDecryptionContentCell";

static NSString *const kGBAddOtherDecryptionTagCellID = @"GBAddOtherDecryptionTagCell";

static NSString *const kGBSectionHeadViewID = @"GBSectionHeadView";

@interface GBAddDecryptionServiceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FSTextView *textView;
/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;//tagsView

/* 联系方式 */
@property (nonatomic, strong) XKTextField *textField;

/* 联系方式 */
@property (nonatomic, copy) NSString *contactType;

@property (nonatomic,strong) HXTagCollectionViewFlowLayout *layout;//布局layout
/* 标签 */
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic,strong) NSArray *selectTags;
/* <#describe#> */
@property (nonatomic, strong) NSArray *tagCodes;

/* <#describe#> */
@property (nonatomic, strong) NSArray *titleListArray;

@property (nonatomic, strong) GBServiceEditModel *tempModel;

/* 显示其他标签 */
@property (nonatomic, assign) BOOL showOtherTag;
/* <#describe#> */
@property (nonatomic, copy) NSString *otherTagName;

@property (nonatomic,strong) HXTagAttribute *tagAttribute;//按钮样式对象
/* <#describe#> */
@property (nonatomic, strong) UILabel *discountLabel;
/* <#describe#> */
@property (nonatomic, copy) NSString *discountType;

@end

@implementation GBAddDecryptionServiceViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"新增解密";
    
    [self setBigTitle];
    [self setupNaviBar];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionFooterHeight = 0.0001;
    
    [self.baseTableView registerClass:[GBAddOtherDecryptionTagCell class] forCellReuseIdentifier:kGBAddOtherDecryptionTagCellID];
    [self.baseTableView registerClass:[GBSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBSectionHeadViewID];
    
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.baseTableView registerClass:[GBDecryptionContentCell class] forCellReuseIdentifier:kGBDecryptionContentCellID];

    [self.view addSubview:self.baseTableView];
}

- (void)setBigTitle {
    NSString *titleStr = nil;
    switch (self.serviceType) {
            // 新建解密服务
        case ServiceTypeNewDecryption: {
            titleStr = @"新增解密";
            self.tempModel.isEnable = YES;
            
        }
            break;
            // 编辑解密服务
        case ServiceTypeEditDecryption: {
            titleStr = @"解密编辑";
            [self headerRereshing];
            
            self.baseTableView.tableFooterView = [self setupDeleteButton];

        }
            break;
        default:
            break;
    }
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) title:titleStr];
}

// 在职者解密服务详情信息
- (void)headerRereshing {
    [super headerRereshing];
    [self getIncumbentDecryptInfo];
}

- (void)getIncumbentDecryptInfo {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineIncumbentDecrypt:self.serviceModel.incumbentDecryptId];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.tempModel = [GBServiceEditModel mj_objectWithKeyValues:returnValue];
        self.selectTags =  [NSMutableArray arrayWithArray:[self.tempModel.labelNames componentsSeparatedByString:@","]];
        
        [self.baseTableView reloadData];
    }];
}

#pragma mark - # Setup Methods
- (void)setupNaviBar {
    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:[UIColor kBaseColor]];
    @GBWeakObj(self);
    self.customNavBar.onClickRightButton = ^{
    @GBStrongObj(self);
        if (!self.selectTags.count) {
            return [UIView showHubWithTip:@"请添加解密方向"];
        }
        
        if ([self.tempModel.originalPrice integerValue] <= 0) {
            return [UIView showHubWithTip:@"请输入正确金额"];
        }
        
        if ([self.tempModel.originalPrice integerValue] < [self.tempModel.price integerValue]) {
            return [UIView showHubWithTip:@"折扣价不得高于原价"];
        }
        
        NSMutableArray *tagLists = [NSMutableArray array];
        for (int i = 0; i < self.tags.count; i++) {
            for (NSString *tag in self.selectTags) {
                NSString *tagName = tag;
                if ([tagName isEqualToString:self.tags[i]]) {
                    if ([tagName isEqualToString:@"其他"]) {
                        if (!ValidStr(self.otherTagName)) {
                            break;
                        }
                        
                        tagName = self.otherTagName;
                    }
                    
                    NSDictionary *tempDic = @{
                                              @"name":tagName,
                                              @"code":self.tagCodes[i]
                                              };
                    [tagLists addObject:tempDic];
                    
                    break;
                }
            }
        }
        
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestMineDecryptRenewal:self.tempModel.discountType types:tagLists originalPrice:self.tempModel.originalPrice price:self.tempModel.price title:self.tempModel.title details:self.tempModel.details isEnable:self.tempModel.isEnable incumbentDecryptId:self.tempModel.incumbentDecryptId];
        
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            [self.navigationController popViewControllerAnimated:YES];
            [UIView showHubWithTip:@"保存成功"];
        }];

    };
}

- (UIView *)setupDeleteButton {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 40)];
    UIButton *deleteButton = [UIButton createButton:CGRectMake(0, 0, SCREEN_WIDTH, 40) target:self action:@selector(deleteButtonAction) textColor:[UIColor kBaseColor]];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [footerView addSubview:deleteButton];
    return footerView;
}

- (void)deleteButtonAction {
    [self AlertWithTitle:@"提示" message:@"删除该解密服务?" andOthers:@[@"取消",@"确定"] animated:YES action:^(NSInteger index) {
        if (index == 1) {
            GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
            [mineVM loadRequestMineDeleteIncumbentDecrypt:self.serviceModel.incumbentDecryptId];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [UIView showHubWithTip:@"删除成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}


#pragma mark - # Event Response
// 热门服务推荐
- (void)getTagsData {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineassurePassLabels];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
//        self.tagModels = [GBAssureContentTagModel mj_objectArrayWithKeyValuesArray:returnValue];
        // 取出职位名称作为标签源
//        for (GBAssureContentTagModel *tagModel in self.tagModels) {
//            [self.tags addObject:tagModel.labelName];
//        }
//        
        [self.baseTableView reloadData];
        
    }];
}

#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? 3 : section == 0 ? self.showOtherTag ? 2 : 1 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 3 ? 0.000001 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 2 || indexPath.section == 3 ? 44 : indexPath.section == 0 ? (indexPath.row == 0 ? 100 : 44) : 300;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
//    if (!headerView) {
//        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
//    }
    GBSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBSectionHeadView alloc] initWithReuseIdentifier:kGBSectionHeadViewID];
    }
    
    headerView.titleLabel.text = section == 0 ? @"解密方向" :  section == 1 ?@"解密内容" : section == 2 ? @"价格与折扣" : @"";
    if (section == 0) {
        headerView.subTitleLabel.text = @"最多能选3个，包含其他方向。其他方向只能填写一个";
    }else {
        headerView.subTitleLabel.text = @"";
    }
    
    headerView.moreButton.hidden = YES;
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HXTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            if (!cell) {
                cell = [[HXTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
            }
            cell.tags = self.tags;
            cell.selectedTags = [NSMutableArray arrayWithArray:_selectTags];
            cell.layout = self.layout;
            cell.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
                NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
                self.selectTags = selectTags;
                if ([selectTags containsObject:@"其他"]) {
                    self.showOtherTag = YES;
                    [self.baseTableView reloadData];
                    
                }else {
                    self.showOtherTag = NO;
                    [self.baseTableView reloadData];
                }
            };
            cell.isMultiSelect = YES;
            cell.maxSelectCount = 3;
            cell.tagAttribute = self.tagAttribute;
            cell.minSelectCount = 1;
            
            [cell reloadData];
            
            return cell;
        }else {
            
            GBAddOtherDecryptionTagCell *addOtherDecryptionTagCell = [tableView cellForRowAtIndexPath:indexPath];
            if (!addOtherDecryptionTagCell) {
                addOtherDecryptionTagCell = [[GBAddOtherDecryptionTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBAddOtherDecryptionTagCellID];
            }
            
            addOtherDecryptionTagCell.tagTextField.text = self.otherTagName;
            addOtherDecryptionTagCell.noticeLabel.text = GBNSStringFormat(@"(%zu/7)",addOtherDecryptionTagCell.tagTextField.text.length);

            addOtherDecryptionTagCell.textValueChangedBlock = ^(NSString *valueStr) {
                self.otherTagName = valueStr;
            };
            
            return addOtherDecryptionTagCell;
        }
        
    }
    
    if (indexPath.section == 1) {
        GBDecryptionContentCell *decryptionContentCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!decryptionContentCell) {
            decryptionContentCell = [[GBDecryptionContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBDecryptionContentCellID];
        }
        decryptionContentCell.textView.text = self.tempModel.title;
        decryptionContentCell.textView2.text = self.tempModel.details;

        decryptionContentCell.titleValueChangedBlock = ^(NSString *valueStr) {
            self.tempModel.title = valueStr;
        };
        
        decryptionContentCell.detailsValueChangedBlock = ^(NSString *valueStr) {
            self.tempModel.details = valueStr;
        };
        
        return decryptionContentCell;
    }
    
    GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(GBSettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = self.titleListArray[indexPath.section][indexPath.row];
    cell.line.hidden = YES;
    
    if (indexPath.section == 2) {
        cell.indicateButton.hidden = YES;
        switch (indexPath.row) {
            case 0:
            {
            }
                break;
            case 1:
            {
                cell.cellType = ValidStr(self.tempModel.discountType) ? CellTypeDetailsLabel: CellTypeDetailsTextfield;
                cell.titleLabel.hidden = YES;
                cell.contentTextField.placeholder = @"请输入定价";
                cell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
                cell.contentTextField.margin = 8;
                cell.contentTextField.text = self.tempModel.originalPrice;
                cell.textValueChangedBlock = ^(NSString *valueStr) {
                    self.tempModel.originalPrice = valueStr;
                    if (ValidStr(valueStr)) {
                        self.discountLabel.textColor = [UIColor kImportantTitleTextColor];
                    }
                };
                
                cell.line.hidden = NO;
                //                GBViewBorderRadius(cell.contentTextField, 2, 0.5, [UIColor kSegmentateLineColor]);
            }
                break;
                
            case 2:
            {
                cell.indicateButton.hidden = NO;
                cell.contentTextField.text = [self.tempModel.discountType isEqualToString:@"FREE"] ? @"免费" : [self.tempModel.discountType isEqualToString:@"DISCOUNT"] ? GBNSStringFormat(@"折扣%@币",self.tempModel.price)  : @"";
                cell.contentTextField.textAlignment = NSTextAlignmentRight;
                
                cell.titleLabel.textColor = ValidStr(self.tempModel.originalPrice) ? [UIColor kImportantTitleTextColor] : [UIColor kAssistInfoTextColor];
                self.discountLabel = (UILabel *)cell.titleLabel;
            }
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 3) {
        cell.cellType = CellTypeDetailsSwitch;
        cell.setSwitch.on = self.tempModel.isEnable;
        cell.switchChangedBlock = ^(BOOL isOpen) {
            self.tempModel.isEnable = isOpen;
        };
        
        cell.indicateButton.hidden = YES;
        
        cell.textLabel.font = Fit_M_Font(18);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 2) {
        if (!ValidStr(self.tempModel.originalPrice)) {
            return [UIView showHubWithTip:@"请输入定价"];
        }
        
        if (ValidStr(self.discountType)) {
            return [UIView showHubWithTip:@"限免折扣期间不可修改"];
        }
        
        
        // 折扣与限免
        GBDiscountLimitFreeViewController *discountLimitFreeVC = [[GBDiscountLimitFreeViewController alloc] init];
        discountLimitFreeVC.discountType = self.tempModel.discountType;
        discountLimitFreeVC.originalPrice = self.tempModel.originalPrice;
        discountLimitFreeVC.saveBlock = ^(NSString *discountType, NSString *price) {
            self.tempModel.discountType = discountType;
            self.tempModel.price = price;
            [self.baseTableView reloadData];
        };
        [self.navigationController pushViewController:discountLimitFreeVC animated:YES];
    }
}

#pragma mark - # Getters and Setters
- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [[NSMutableArray alloc] initWithArray:@[@"求职技巧",@"职场生存",@"公司包打听",@"专业技能",@"职业规划",@"其他"]];
    }
    
    return _tags;
}

- (NSArray *)tagCodes {
    if (!_tagCodes) {
        _tagCodes = @[@"DECRYPT_QZJQ",@"DECRYPT_ZCSC",@"DECRYPT_GSBDT",@"DECRYPT_ZYJN",@"DECRYPT_ZYGH",@"CUSTOMIZED"];
    }
    
    return _tagCodes;
}

//- (NSMutableArray *)tagModels {
//    if (!_tagModels) {
//        _tagModels = [[NSMutableArray alloc] init];
//    }
//
//    return _tagModels;
//}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - GBMargin*2, 40)];
    }
    return _tagsView;
}

- (HXTagCollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [HXTagCollectionViewFlowLayout new];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _layout.minimumInteritemSpacing = 10;
//        _layout.minimumLineSpacing = 10;
        _layout.itemSize = CGSizeMake(64,30);
        _layout.sectionInset = UIEdgeInsetsMake(15.0f, GBMargin, 15.0f, 10.0f);
    }
    return _layout;
}

- (NSArray *)titleListArray {
    if (!_titleListArray) {
        _titleListArray = @[@[],@[],@[@"定价",@"",@"限免与折扣"],@[@"上线此服务"]];
    }
    
    return _titleListArray;
}

- (GBServiceEditModel *)tempModel {
    if (!_tempModel) {
        _tempModel = [[GBServiceEditModel alloc] init];
    }
    
    return _tempModel;
}

- (HXTagAttribute *)tagAttribute {
    if (!_tagAttribute) {
        _tagAttribute = [[HXTagAttribute alloc] init];
        _tagAttribute.cornerRadius = 15;
        _tagAttribute.tagSpace = GBMargin;
        _tagAttribute.titleSize = 14;
        _tagAttribute.borderColor = [UIColor kSegmentateLineColor];
        _tagAttribute.borderWidth = 0.5;
        _tagAttribute.selectedTextColor = [UIColor kBaseColor];
        _tagAttribute.textColor = [UIColor kNormoalInfoTextColor];
        _tagAttribute.selectedBackgroundColor = [UIColor colorWithHexString:@"#F7F5FD"];
        _tagAttribute.normalBackgroundColor = [UIColor whiteColor];
        _tagAttribute.selectBorderColor = [UIColor kBaseColor];
    }
    
    return _tagAttribute;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
