//
//  GBProvincesViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBProvincesViewController.h"
// Controllers
#import "GBUniversitiesViewController.h"

// ViewModels


// Models


// Views
#import "GBSettingCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBProvincesViewController ()<UITableViewDelegate,UITableViewDataSource>
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <NSDictionary *>*dataArray;

/* <#describe#> */
//@property (nonatomic, copy) NSString *provinceName;
/* <#describe#> */
//@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, strong)NSIndexPath *lastSelected;//上一次选中的索引

@end

@implementation GBProvincesViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self headerRereshing];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    self.baseTableView.rowHeight = 56;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    
    [self setupCustomNavBarRightButton:@"下一步"];
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
    @GBStrongObj(self);
        
        if (!ValidStr(self.educationExperienceModel.pcname) || !ValidStr(self.educationExperienceModel.provinceId)) {
            return [UIView showHubWithTip:@"请选择省份"];
        }
        
        GBUniversitiesViewController *universitiesVC = [[GBUniversitiesViewController alloc] init];
        universitiesVC.educationExperienceModel = self.educationExperienceModel;
        universitiesVC.educationExperienceModel = self.educationExperienceModel;

        [self.navigationController pushViewController:universitiesVC animated:YES];
    }];
}


#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    [self loadRequestListProvinces];
}

- (void)loadRequestListProvinces {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestListProvinces];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.dataArray = [NSMutableArray arrayWithArray:returnValue];
        [self.baseTableView reloadData];
    }];
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGBSettingCellID];
    }
    cell.titleLabel.text = self.dataArray[indexPath.row][@"provinceName"];
    cell.indicateButton.hidden = YES;
    
    cell.tintColor = [UIColor kBaseColor];
    
    NSInteger selectedRow = self.lastSelected.row;

    if (selectedRow == indexPath.row && self.lastSelected != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.educationExperienceModel.pcname = self.dataArray[indexPath.row][@"provinceName"];
    self.educationExperienceModel.provinceId = GBNSStringFormat(@"%@",self.dataArray[indexPath.row][@"id"]);
    
    //当前cell row
    NSInteger newRow = [indexPath row];
    //记录上一次cell row
    NSInteger oldRow = (self.lastSelected != nil) ? [self.lastSelected row] : -1;
    if (newRow != oldRow)
    {
        
        //选中cell
        GBSettingCell *newcell =  [tableView cellForRowAtIndexPath:indexPath];
        newcell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        //取消上一次选中cell
        GBSettingCell *oldCell = [tableView cellForRowAtIndexPath:self.lastSelected];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    self.lastSelected = indexPath;
}



#pragma mark - # Getters and Setters
- (GBEducationExperienceModel *)educationExperienceModel {
    if (!_educationExperienceModel) {
        _educationExperienceModel = [[GBEducationExperienceModel alloc] init];
    }
    
    return _educationExperienceModel;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end