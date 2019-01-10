//
//  GBHomePageSearchViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/15.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 搜索
//  @discussion <#类的功能#>
//

#import "GBHomePageSearchViewController.h"

// Controllers
#import "SalarySelectViewController.h"
// ViewModels

// Models
#import "GBHotTagModel.h"
#import "GBCompanyFiltrateModel.h"

// Views
#import "GBNavSearchBarView.h"
#import "WRCustomNavigationBar.h"
#import "CurrentStatusPopView.h"

#import "MXRGuideMaskView.h"

@interface GBHomePageSearchViewController ()<UITextFieldDelegate>

/** 自定义导航栏 */
@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;
/* <#describe#> */
@property (nonatomic, strong) GBNavSearchBarView *csearchBar;
/* <#describe#> */
@property (nonatomic, strong) UISearchBar *ssearchBar;
// 下拉菜单数据
@property (nonatomic,strong) NSArray *menuItemNames;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <NSString *>*hotSearchStrs;
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *tags;
/* 经验 */
@property (nonatomic, strong) NSArray *experienceList;
/* 经验Code */
@property (nonatomic, strong) NSArray *experienceCodeList;

/* 规模 */
@property (nonatomic, strong) NSArray *companyScaleNameList;
/* 规模Code */
@property (nonatomic, strong) NSArray *companyScaleCodeList;
/* <#describe#> */
@property (nonatomic, strong) UITextField *searchField;

/* 半透明遮罩视图 */
@property (nonatomic, strong) UIView *maskView;

@end

@implementation GBHomePageSearchViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:YCXMenuWillDisappearNotification object:nil];
    [GBNotificationCenter removeObserver:self name:YCXMenuWillAppearNotification object:nil];
}

- (GBNavSearchBarView *)csearchBar {
    if (!_csearchBar) {
        _csearchBar = [[GBNavSearchBarView alloc] initWithFrame:CGRectMake(GBMargin, SafeAreaTopHeight, SCREEN_WIDTH - GBMargin*2, 40)];
        _csearchBar.backgroundColor = [UIColor whiteColor];
        _csearchBar.searchBarViewType = SearchBarViewTypeFiltrate;
    }
    
    return _csearchBar;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.ssearchBar = self.searchBar;
    [self.csearchBar addSubview:self.ssearchBar];
    UITextField *searchField = (UITextField *)[self.searchBar valueForKey:@"_searchField"];
    searchField.font = Fit_Font(14);
    self.ssearchBar.frame = self.csearchBar.placeholdLabel.bounds;
    [self.csearchBar bringSubviewToFront:self.csearchBar.line];
    @GBWeakObj(self);
    self.csearchBar.filtrateButtonClickBlock = ^{
        @GBStrongObj(self);
        [self menuFunction];
    };
    
//    [self setupFiltrateButton];
    
    [searchField addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    self.searchField = searchField;
}

- (void)editDidBegin:(id)sender {
    self.baseSearchTableView.backgroundColor = [UIColor whiteColor];
    self.baseSearchTableView.alpha = 1;
    self.tagsView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.showKeyboardWhenReturnSearchResult = NO;

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.ssearchBar.frame = self.csearchBar.placeholdLabel.bounds;
    self.ssearchBar.left = CGRectGetMaxX(self.csearchBar.typeBtn.frame);
    self.ssearchBar.width = SCREEN_WIDTH - CGRectGetMaxX(self.csearchBar.typeBtn.frame) - GBMargin*2;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.baseSearchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(SafeAreaTopHeight+(60)));
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.searchSuggestionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(SafeAreaTopHeight+(60)));
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.ssearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.csearchBar.typeBtn.mas_right).offset(0);
        make.right.equalTo(self.csearchBar).offset(0);
        make.top.equalTo(self.csearchBar);
        make.height.equalTo(self.csearchBar);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.customNavBar];
    
    [self.customNavBar wr_setLeftButtonWithImage:GBImageNamed(@"icon_back_white")];

    self.baseSearchTableView.backgroundColor = [UIColor whiteColor];
    
    [self.customNavBar addSubview:self.csearchBar];
    
    self.showHotSearch = YES;
    
    [self setupHotCompanyTags];
    
    
    [self.searchBar becomeFirstResponder];
    
    // 下拉菜单通知
    [GBNotificationCenter addObserver:self selector:@selector(menuWillDisappear) name:YCXMenuWillDisappearNotification object:nil];
    [GBNotificationCenter addObserver:self selector:@selector(menuWillAppear) name:YCXMenuWillAppearNotification object:nil];
    
    if (!ValidStr([GBUserDefaults stringForKey:UDK_Gird_Finish_Search])) {
        // 新手引导
        [self guidPageView];
    }
}

- (void)guidPageView {
    NSArray * imageArr = @[@"newbie_guide03"];
    CGRect rect1 = self.customNavBar.frame;
    NSArray * imgFrameArr = @[
                              [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+18, CGRectGetMinY(self.csearchBar.frame)-GBMargin/2,322, 265)],
                              ];
    NSArray * transparentRectArr = @[[NSValue valueWithCGRect:rect1]];
    NSArray * orderArr = @[@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    [maskView addImages:imageArr imageFrame:imgFrameArr TransparentRect:transparentRectArr orderArr:orderArr];
    maskView.didDismissMaskViewBlock = ^{
        [GBUserDefaults setObject:@"Gird_Finish_Search" forKey:UDK_Gird_Finish_Search];
        [GBUserDefaults synchronize];
    };
    [maskView showMaskViewInView:KEYWINDOW];
}

#pragma mark - # Setup Methods
// 热门标签
- (void)setupHotTags {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestHomePageHotJob];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        [self.hotSearchStrs removeAllObjects];
        
        NSMutableArray <GBHotTagModel *>*tempArray = [GBHotTagModel mj_objectArrayWithKeyValuesArray:returnValue];
        for (GBHotTagModel *hotTag in tempArray) {
            [self.hotSearchStrs addObject:hotTag.jobName];
        }
        
        self.hotSearches = self.hotSearchStrs;
    }];
}

// 热门公司
- (void)setupHotCompanyTags {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestHotCompanies];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        [self.hotSearchStrs removeAllObjects];
        
        NSMutableArray <GBCompanyFiltrateModel *>*tempArray = [GBCompanyFiltrateModel mj_objectArrayWithKeyValuesArray:returnValue];
        for (GBCompanyFiltrateModel *hotTag in tempArray) {
            [self.hotSearchStrs addObject:hotTag.companyFullName];
        }
        
        self.hotSearches = self.hotSearchStrs;
    }];
}

// 筛选标签
- (void)setupFiltrateButton {
    @GBWeakObj(self);
    self.tagsView.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
        @GBStrongObj(self);
        NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
        switch (currentIndex) {
            case 0:
            {
                if (self.searchType == SearchTypeCompany) {
                    // 公司 - 规模
                    CurrentStatusPopView *statusV = [[CurrentStatusPopView alloc] initWithStatusArray:self.companyScaleNameList andSelectedStatus:self.companyFitrateModel.companyScaleName];
                    statusV.titleStr = @"规模";
                    [statusV setSelectBlock:^(NSString *companyScaleName) {
                        self.companyFitrateModel.companyScaleName = companyScaleName;
                        for (NSInteger i = 0; i < self.companyScaleCodeList.count; i++) {
                            if ([self.companyScaleNameList[i] isEqualToString:companyScaleName]) {
                                self.companyFitrateModel.companyScaleCode = self.companyScaleCodeList[i];
                                break;
                            }
                        }
                        
                        [self.tags replaceObjectAtIndex:0 withObject:self.companyFitrateModel.companyScaleName];
                        [self.tagsView reloadData];
                    }];
                    [statusV show];
                    
                    return ;
                }
                
                // 职位 - 薪资
                SalarySelectViewController *salary = [[SalarySelectViewController alloc] init];
                salary.selectBlock = ^(NSString *minSalary, NSString *maxSalary) {
                    self.filtrateModel.minSalary = minSalary;
                    self.filtrateModel.maxSalary = maxSalary;
                    
                    [self.tags replaceObjectAtIndex:0 withObject:GBNSStringFormat(@"%@k-%@k",minSalary,maxSalary)];
                    [self.tagsView reloadData];
                    
                    !self.filtrateBlock ? : self.filtrateBlock(self.filtrateModel);
                };
                
                salary.customNavBar.alpha = 0;
                // 核心代码
                self.definesPresentationContext = YES;
                salary.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [GBRootViewController presentViewController:salary animated:NO completion:nil];
            }
                break;
            case 1:
            {
                // 职位 - 经验
                CurrentStatusPopView *statusV = [[CurrentStatusPopView alloc] initWithStatusArray:self.experienceList andSelectedStatus:self.filtrateModel.experienceName];
                statusV.titleStr = @"经验";
                [statusV setSelectBlock:^(NSString *experienceName) {
                    self.filtrateModel.experienceName = experienceName;
                    for (NSInteger i = 0; i < self.experienceCodeList.count; i++) {
                        if ([self.experienceList[i] isEqualToString:experienceName]) {
                            self.filtrateModel.experienceCode = self.experienceCodeList[i];
                            break;
                        }
                    }
                    
                    [self.tags replaceObjectAtIndex:1 withObject:self.filtrateModel.experienceName];
                    [self.tagsView reloadData];
                    
                    !self.filtrateBlock ? : self.filtrateBlock(self.filtrateModel);

                }];
                [statusV show];
            }
                break;
            default:
                break;
        }
    };
    
    self.tagsView.tags = self.tags;
    HXTagAttribute *model = [[HXTagAttribute alloc]init];
    model.borderWidth  = 0.5;
    model.borderColor  = [UIColor kSegmentateLineColor];
    model.cornerRadius  = 12;
    model.titleSize  = 12;
    model.textColor  = [UIColor whiteColor];
    model.normalBackgroundColor  = [UIColor clearColor];
    model.selectedBackgroundColor  = [UIColor clearColor];

    model.tagSpace  = GBMargin;
    
    self.tagsView.tagAttribute = model;
    
    HXTagCollectionViewFlowLayout *flowLayout = [[HXTagCollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100,20);
    flowLayout.sectionInset = UIEdgeInsetsZero;
    self.tagsView.layout = flowLayout;
    
    [self.customNavBar addSubview:self.tagsView];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customNavBar).offset(GBMargin);
        make.bottom.equalTo(self.customNavBar).offset(-8);
        make.right.equalTo(self.csearchBar).offset(-GBMargin);
        make.height.equalTo(@24);
    }];
    
    [self.tagsView reloadData];
}

#pragma mark - # Event Response
- (void)menuWillAppear {
    [self.view bringSubviewToFront:self.maskView];
//    if (self.baseSearchTableView.alpha == 1) {
//        self.maskView.top = SafeAreaTopHeight + 80;
//    }else {
        self.maskView.top = SafeAreaTopHeight+(60);
//    }
}
/** 右侧下拉菜单按钮将要消失通知 */
- (void)menuWillDisappear {
    self.maskView.alpha = 0;
}

/**
 右侧下拉菜单按钮功能
 */
- (void)menuFunction {
    self.maskView.alpha = 0.5;

    [YCXMenu setTintColor:[UIColor whiteColor]];
    [YCXMenu setCornerRadius:2];
    [YCXMenu setTitleFont:Fit_Font(15)];
    [YCXMenu setSelectedColor:[UIColor whiteColor]];
    [YCXMenu setSeparatorColor:[UIColor kSegmentateLineColor]];
    
    @GBWeakObj(self);
    [YCXMenu showMenuInView:KEYWINDOW fromRect:CGRectMake(GBMargin+10, self.csearchBar.bottom, 50, 0) menuItems:self.menuItemNames selected:^(NSInteger index, YCXMenuItem *item) {
        @GBStrongObj(self);
        
        [self.searchField becomeFirstResponder];
        self.searchField.text = @"";
        
        self.maskView.alpha = 0;

        if (index == 1) {
            [self setupHotTags];
            
            self.searchType = SearchTypePosition;
            [self.csearchBar.typeBtn setTitle:@"职位" forState:UIControlStateNormal];
            self.tags = [NSMutableArray arrayWithArray:@[@"薪资",@"经验"]];
            self.tagsView.tags = self.tags;
            [self.tagsView reloadData];
            
        }else {
            [self setupHotCompanyTags];

            self.searchType = SearchTypeCompany;
            [self.csearchBar.typeBtn setTitle:@"公司" forState:UIControlStateNormal];
            self.tags = [NSMutableArray arrayWithArray:@[]];
            self.tagsView.tags = self.tags;
            [self.tagsView reloadData];
        }
    }];
}

#pragma mark - # Privater Methods


#pragma mark - # Delegate


#pragma mark - # Getters and Setters
- (NSArray *)menuItemNames {
    if (!_menuItemNames) {
        //set item
        YCXMenuItem *item1 = [YCXMenuItem menuItem:@"公司"
                                             image:nil
                                               tag:101
                                          userInfo:@{@"title":@"Menu"}];
        item1.foreColor = [UIColor kImportantTitleTextColor];
        
        YCXMenuItem *item2 = [YCXMenuItem menuItem:@"职位"
                                             image:nil
                                               tag:100
                                          userInfo:@{@"title":@"Menu"}];
        item2.foreColor = [UIColor kImportantTitleTextColor];
        _menuItemNames = @[item1,item2];
    }
    
    return _menuItemNames;
}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] init];
        _tagsView.hidden = YES;

    }
    
    return _tagsView;
}

// 自定义导航栏
- (WRCustomNavigationBar *)customNavBar {
    if (_customNavBar == nil) {
        _customNavBar = [[WRCustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SafeAreaTopHeight+(60))];
       _customNavBar.barBackgroundImage = GBImageNamed(@"Home_Head_img_background");
    }
    return _customNavBar;
}

- (NSArray *)companyScaleNameList {
    if (!_companyScaleNameList) {
        _companyScaleNameList = @[@"不限", @"0-20人", @"20-99人", @"100-499人", @"500-999人", @"1000-9999人", @"10000人以上"];
    }
    
    return _companyScaleNameList;
}

- (NSArray *)companyScaleCodeList {
    if (!_companyScaleCodeList) {
        _companyScaleCodeList = @[@"", @"COMPANY_SCALE_GT_0_LT_20", @"COMPANY_SCALE_GT_20_LT_99", @"COMPANY_SCALE_GT_100_LT_499", @"COMPANY_SCALE_GT_500_LT_999", @"COMPANY_SCALE_GT_1000_LT_9999", @"COMPANY_SCALE_GT_10000"];
    }
    
    return _companyScaleCodeList;
}


- (NSArray *)experienceList {
    if (!_experienceList) {
        _experienceList = @[@"不限", @"应届生", @"1年以下", @"1-3年", @"3-5年", @"5-10年", @"10年以上"];
    }
    
    return _experienceList;
}

- (NSArray *)experienceCodeList {
    if (!_experienceCodeList) {
        _experienceCodeList = @[@"JOB_WORK_YEAR_NO", @"JOB_WORK_YEAR_GT_0LT_0", @"JOB_WORK_YEAR_LT_0", @"JOB_WORK_YEAR_GT_1_LT_0", @"JOB_WORK_YEAR_GT_5_LT_3", @"JOB_WORK_YEAR_GT_10_LT_5", @"JOB_WORK_YEAR_GT_10"];
    }
    
    return _experienceCodeList;
}

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [[NSMutableArray alloc] initWithArray:@[@"薪资",@"经验"]];
    }
    
    return _tags;
}
- (NSMutableArray *)hotSearchStrs {
    if (!_hotSearchStrs) {
        _hotSearchStrs = [[NSMutableArray alloc] init];
    }
    
    return _hotSearchStrs;
}

- (GBFiltrateModel *)filtrateModel {
    if (!_filtrateModel) {
        _filtrateModel = [[GBFiltrateModel alloc] init];
    }
    
    return _filtrateModel;
}

- (GBCompanyFiltrateModel *)companyFitrateModel {
    if (!_companyFitrateModel) {
        _companyFitrateModel = [[GBCompanyFiltrateModel alloc] init];
    }
    
    return _companyFitrateModel;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+(60), SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor lightGrayColor];
        _maskView.alpha = 0.5;
        [self.view addSubview:_maskView];
    }
    
    return _maskView;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
