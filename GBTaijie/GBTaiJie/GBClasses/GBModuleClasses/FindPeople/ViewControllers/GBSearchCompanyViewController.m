//
//  GBSearchCompanyViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/17.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBSearchCompanyViewController.h"
#import "SearchCompanyLoginCell.h"
#import "SearchCompanyBottomView.h"
#import "CityModel.h"

// ViewModel

static NSString *const kSearchCompanyLoginCellID = @"SearchCompanyLoginCell";

@interface GBSearchCompanyViewController ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIImageView *nav_img;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelBtn;

/** 历史数据 */
@property (nonatomic, strong) NSArray *historyList;

@property (nonatomic, strong) SearchCompanyBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GBSearchCompanyViewController {
    /** _type=1:显示历史搜索，_type=2:显示搜索结果 */
    NSInteger _type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"搜索公司";

    // 设置导航栏
    [self setupNavBar];
    
    // 加载子页面
    [self addSubViews];
}

// 设置导航栏
- (void)setupNavBar {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(38, 0, SCREEN_WIDTH - 94, 30)];
    navView.layer.cornerRadius = 15;
    navView.backgroundColor = UIColorFromRGB(0xF2F5FA);
    self.navView = navView;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 14, 14)];
    img.image = [UIImage imageNamed:@"ic_search_small"];
    self.nav_img = img;
    [navView addSubview:img];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(37, 5, navView.size.width - 52, 20)];
    self.textField.placeholder = @"请输入关键字, 如腾讯或大连";
    self.textField.font = Fit_Font(14);
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySearch;
    [navView addSubview:self.textField];
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(navView.frame), 0, 56, 44)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.customNavBar];
    
    [self.customNavBar addSubview:navView];
    [self.customNavBar addSubview:self.cancelBtn];
    CGPoint navViewCenter = navView.center;
    navViewCenter.y = (self.customNavBar.height + StatusBarHeight) / 2;
    navView.center = navViewCenter;
    
    CGPoint cancelBtnCenter = self.cancelBtn.center;
    cancelBtnCenter.y = (self.customNavBar.height + StatusBarHeight) / 2;
    self.cancelBtn.center = cancelBtnCenter;
}

- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSubViews {
    _type = 1;
    self.bottomView = [[SearchCompanyBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 98)];
    @GBWeakObj(self);
    self.bottomView.clearBlock = ^{
        @GBStrongObj(self);
        [self clearSearchHistory];
    };
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 28;
    self.baseTableView.sectionFooterHeight = 28;
    [self.baseTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchCompanyLoginCell class]) bundle:nil] forCellReuseIdentifier:kSearchCompanyLoginCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableFooterView = self.bottomView;
    
    [self fetchSearchHistoryDataList];
}

- (void)clearSearchHistory {
    if (self.index == 1) {
        [UserManager synSetValue:nil forKey:kSearchCompanyHistoryList];
        self.historyList = [[NSArray alloc] init];
        
        self.baseTableView.tableFooterView = nil;
        [self.baseTableView reloadData];
    } else {
        [UserManager synSetValue:nil forKey:kSearchCityHistoryList];
        self.historyList = [[NSArray alloc] init];
        
        self.baseTableView.tableFooterView = nil;
        [self.baseTableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.nav_img removeFromSuperview];
    [self.textField removeFromSuperview];
    [self.navView removeFromSuperview];
    [self.cancelBtn removeFromSuperview];
}

- (void)insertCitySearchHistory:(CityModel *)city {
    NSMutableArray *searchList = [[NSMutableArray alloc] initWithArray:[UserManager getValueforKey:kSearchCityHistoryList]];
    NSMutableIndexSet *mutSet = [[NSMutableIndexSet alloc] init];
    for (int index = 0; index < [searchList count]; index++) {
        
        CityModel *cityM = [CityModel unarchiveObjectWithDate:searchList[index]];
        NSString *searchKey = cityM.regionId;
        
        if([searchKey isEqualToString:city.regionId]){
            [mutSet addIndex:index];
        }
    }
    [searchList removeObjectsAtIndexes:mutSet];
    
    [searchList insertObject:[city keyedArchiverObject] atIndex:0];
    [UserManager synSetValue:searchList forKey:kSearchCityHistoryList];
}

- (void)insertCompanySearchHistory:(CompanyModel *)company {
    NSMutableArray *searchList = [[NSMutableArray alloc] initWithArray:[UserManager getValueforKey:kSearchCompanyHistoryList]];
    NSMutableIndexSet *mutSet = [[NSMutableIndexSet alloc] init];
    for (int index = 0; index < [searchList count]; index++) {
        
        CompanyModel *companyM = [CompanyModel unarchiveObjectWithDate:searchList[index]];
        NSString *searchKey = companyM.companyId;
        if([searchKey isEqualToString:company.companyId]){
            [mutSet addIndex:index];
        }
    }
    [searchList removeObjectsAtIndexes:mutSet];  //[user keyedArchiverObject]
    
    [searchList insertObject:[company keyedArchiverObject] atIndex:0];
    [UserManager synSetValue:searchList forKey:kSearchCompanyHistoryList];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    
    _type = 2;
    [self fetchData];
    
    // 搜索数据
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField { // 一获取焦点就走此方法
    NSLog(@"textFieldDidBeginEditing");
    _type = 1;
    NSString *nowText = textField.text;
    if ([nowText length] == 0) {
        [self fetchSearchHistoryDataList];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"shouldChangeCharactersInRange-------%@", NSStringFromRange(range));
    NSLog(@"shouldChangeCharactersInRange-------%@", string);
    
    if (range.location == 0 && range.length == 1 && [string isEqualToString:@""]) {
        [self fetchSearchHistoryDataList];
    }
    return YES;
}


/** 搜索数据 */
- (void)fetchData {
    if (self.index == 1) {
        GBFindPeopleViewModel *findPeopleVM = [[GBFindPeopleViewModel alloc] init];
        [findPeopleVM loadRequestSearchCompanyI:1 pageSize:10 key:self.textField.text];
        @GBWeakObj(self);
        [findPeopleVM setSuccessReturnBlock:^(id returnValue) {
            @GBStrongObj(self);
            NSArray *companys = [CompanyModel mj_objectArrayWithKeyValuesArray:[returnValue objectForKey:@"list"]];
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:companys];
            
            self.baseTableView.tableFooterView = nil;
            [self.baseTableView reloadData];
        }];
    }
    //         else {
    //        WS(self)
    //        [self showProgressWithView:self.view animated:YES];
    //        [SendRequest getRegionByKey:self.textField.text result:^(NSDictionary *result, NSError *error) {
    //            [self hideProgress:self.view animated:YES];
    //            result = [CommonUtils decryptDicWithResult:result];
    //            if([result[@"result"] integerValue] == 1) {
    //                NSLog(@"搜索城市数据 = %@", [result objectForKey:@"data"]);
    //                NSArray *datas = [result objectForKey:@"data"];
    //                NSArray *citys = [CityModel mj_objectArrayWithKeyValuesArray:datas];
    //
    //                [self.dataArray removeAllObjects];
    //                [self.dataArray addObjectsFromArray:citys];
    //
    //                self.tableView.tableFooterView = nil;
    //                [self.tableView reloadData];
    //            } else {
    //                [CommonUtils showToast:[result objectForKey:@"msg"]];
    //            }
    //        }];
    //    }
}

/** 搜索历史数据 */
- (void)fetchSearchHistoryDataList {
    if (self.index == 1) {
        NSArray *companyDatas = [UserManager getValueforKey:kSearchCompanyHistoryList];
        NSMutableArray *datas = [[NSMutableArray alloc] init];
        for (NSData *currentData in companyDatas) {
            CompanyModel *company = [CompanyModel unarchiveObjectWithDate:currentData];
            [datas addObject:company];
        }
        self.historyList = datas;
        
        if (self.historyList.count > 5) {
            self.historyList = [self.historyList subarrayWithRange:NSMakeRange(0, 5)];
        }
    } else {
        NSArray *companyDatas = [UserManager getValueforKey:kSearchCityHistoryList];
        NSMutableArray *datas = [[NSMutableArray alloc] init];
        for (NSData *currentData in companyDatas) {
            CompanyModel *company = [CompanyModel unarchiveObjectWithDate:currentData];
            [datas addObject:company];
        }
        self.historyList = datas;
        
        if (self.historyList.count > 5) {
            self.historyList = [self.historyList subarrayWithRange:NSMakeRange(0, 5)];
        }
    }
    if (self.historyList.count > 0) {
        self.baseTableView.tableFooterView = self.bottomView;
    } else {
        self.baseTableView.tableFooterView = nil;
    }
    [self.baseTableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == 1) {
        return self.historyList.count;
    } else {
        NSLog(@"self.dataArray.count = %zd", self.dataArray.count);
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCompanyLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCompanyLoginCellID];
    if (_type == 1) {
        if (self.index == 1) {
            CompanyModel *company = [self.historyList objectAtIndex:indexPath.row];
            cell.nameL.text = company.companyFullName;
        } else {
            CityModel *city = [self.historyList objectAtIndex:indexPath.row];
            cell.nameL.text = city.regionName;
        }
        
    } else {
        if (self.index == 1) {
            CompanyModel *company = [self.dataArray objectAtIndex:indexPath.row];
            cell.nameL.text = company.companyFullName;
        } else {
            CityModel *city = [self.dataArray objectAtIndex:indexPath.row];
            cell.nameL.text = city.regionName;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 1) {
        if (self.index == 1) {
            CompanyModel *company = [self.historyList objectAtIndex:indexPath.row];
            self.companyBlock(company);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            CityModel *city = [self.historyList objectAtIndex:indexPath.row];
            self.cityBlock(city);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchcity" object:nil userInfo:@{@"city":city}];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        if (self.index == 1) {
            CompanyModel *company = [self.dataArray objectAtIndex:indexPath.row];
            self.companyBlock(company);
            [self insertCompanySearchHistory:company];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            CityModel *city = [self.dataArray objectAtIndex:indexPath.row];
            self.cityBlock(city);
            [self insertCitySearchHistory:city];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchcity" object:nil userInfo:@{@"city":city}];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


@end
