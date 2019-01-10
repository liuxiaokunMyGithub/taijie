//
//  PositionSelectViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/820.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 期望职位
//  @discussion 职位三级列表
//
#import "PositionSelectViewController.h"
#import "PositionSelectCell.h"
#import "PositionSelectView.h"
#import "IndustryModel.h"

// !!!:重构中

@interface PositionSelectViewController ()
// 职位级列表
@property (nonatomic, strong) NSMutableArray *dataArray;
// 职位一级列表
@property (nonatomic, strong) NSMutableArray *oneArray;
// 职位二级列表
@property (nonatomic, strong) NSMutableArray *twoArray;

@property (nonatomic, strong) PositionSelectView *selectView;

@end

@implementation PositionSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"选择职位类型";
    
    // 设置子视图
    [self setupSubViews];
    
    // 获取初级职位列表
    [self loadPositionList:@"" jobLayer:@"1"];
}

- (void)setupSubViews {
    [self.baseTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PositionSelectCell class]) bundle:nil] forCellReuseIdentifier:@"PositionSelectCell"];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    self.baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:self.baseTableView];
}

#pragma mark - # Data Method
/** MARK:  获取职位列表   */
- (void)loadPositionList:(NSString *)jobPid jobLayer:(NSString *)jobLayer  {
    GBFindPeopleViewModel *findPeopleVM = [[GBFindPeopleViewModel alloc] init];
    [findPeopleVM loadRequestJobList:jobPid jobLayer:jobLayer limited:NO];
    [findPeopleVM setSuccessReturnBlock:^(id returnValue) {
        if ([jobLayer isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            NSArray *datas = [JobModel mj_objectArrayWithKeyValuesArray:returnValue];
            [self.dataArray addObjectsFromArray:datas];
            [self.baseTableView reloadData];
        }
        
        if ([jobLayer isEqualToString:@"2"]) {
            NSArray *datas = [JobModel mj_objectArrayWithKeyValuesArray:returnValue];
            [self.oneArray removeAllObjects];
            [self.oneArray addObjectsFromArray:datas];
            
            [self.selectView.cateOneTableView reloadData];
        }
       
        if ([jobLayer isEqualToString:@"3"]) {
            NSArray *datas = [JobModel mj_objectArrayWithKeyValuesArray:returnValue];
            [self.twoArray removeAllObjects];
            [self.twoArray addObjectsFromArray:datas];
            
            [self.selectView.cateTwoTableView reloadData];
        }
    }];
}

#pragma mark - # UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.baseTableView) {
        return self.dataArray.count;
    }else if (tableView == _selectView.cateOneTableView) {
        return self.oneArray.count;
    }else {
        return self.twoArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.baseTableView) {
        PositionSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PositionSelectCell"];
        [cell setCenterNameLHidden:YES];
        JobModel *job = [self.dataArray objectAtIndex:indexPath.row];
        cell.nameL.text = job.jobName;
        return cell;
    } else if (tableView == self.selectView.cateOneTableView) {
        PositionSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCateOne"];
        [cell setCenterNameLHidden:NO];
        JobModel *job = [self.oneArray objectAtIndex:indexPath.row];
        cell.centerNameL.text = job.jobName;
        return cell;
    } else {
        PositionSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCateTwo"];
        [cell setCenterNameLHidden:NO];
        cell.backgroundColor = [UIColor kBaseBackgroundColor];
        JobModel *job = [self.twoArray objectAtIndex:indexPath.row];
        cell.centerNameL.text = job.jobName;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.baseTableView) {
        JobModel *job = [self.dataArray objectAtIndex:indexPath.row];
        [self loadPositionList:job.jobId jobLayer:@"2"];
        self.selectView.x = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.selectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            self.selectView.backV.x = 0;
        }];
    }else if (tableView == _selectView.cateOneTableView) {
        JobModel *job = [self.oneArray objectAtIndex:indexPath.row];
        
        [self loadPositionList:job.jobId jobLayer:@"3"];
    }else if (tableView == _selectView.cateTwoTableView) {
        self.selectBlock([self.twoArray objectAtIndex:indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - # Getters and Setters
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)oneArray {
    if (!_oneArray) {
        _oneArray = [NSMutableArray array];
    }
    return _oneArray;
}

- (NSMutableArray *)twoArray {
    if (!_twoArray) {
        _twoArray = [NSMutableArray array];
    }
    return _twoArray;
}


- (PositionSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[PositionSelectView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _selectView.cateOneTableView.delegate = self;
        _selectView.cateOneTableView.dataSource = self;
        _selectView.cateTwoTableView.delegate = self;
        _selectView.cateTwoTableView.dataSource = self;
        [self.view addSubview:_selectView];
        [self.view bringSubviewToFront:_selectView];
    }
    return _selectView;
}

@end
