//
//  GBEndServiceViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/24.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 结束服务
//  @discussion <#类的功能#>
//

#import "GBEndServiceViewController.h"

// Controllers
#import "GBRefundViewController.h"
#import "GBOrderServiceEvaluationViewController.h"
// ViewModels


// Models
#import "DCFiltrateItem.h"
#import "DCContentItem.h"

// Views
#import "GBPersonalSectionHeadView.h"
#import "GBReportTableViewCell.h"

static NSString *const kGBReportTableViewCellID = @"GBReportTableViewCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

@interface GBEndServiceViewController ()<UITableViewDelegate,UITableViewDataSource>


/* 举报内容模型 */
@property (nonatomic, strong) NSMutableArray <DCFiltrateItem *> *filtrateItem;
/* 已选 */
@property (strong , nonatomic)NSMutableArray *seleArray;


@end

@implementation GBEndServiceViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"结束服务";
    
    [self setupNav];
    
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.rowHeight = 55;
    self.baseTableView.sectionHeaderHeight = 60;
    self.baseTableView.sectionFooterHeight = 0.00001;
    
    [self.baseTableView registerClass:[GBReportTableViewCell class] forCellReuseIdentifier:kGBReportTableViewCellID];
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 60) title:@"结束服务"];
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
}


#pragma mark - # Setup Methods
- (void)setupNav {
    [self.customNavBar wr_setRightButtonWithTitle:@"确定" titleColor:[UIColor kBaseColor]];
    
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
        if (!ValidStr(self.seleArray[0][0])) {
            return [UIView showHubWithTip:@"请选择结束原因"];
        }
        
        NSString *type = nil;
        if ([self.seleArray[0][0] isEqualToString:@"已成功保我入职，满意并付款"]) {
            type = @"REASON_NORMAL";
            GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
            [mineVM loadRequestMineAssurePassFinish:self.orderDeailsModel.assurePassId reasonType:type remark:self.seleArray[0][0] refundAmount:nil rewardAmount:nil];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                GBOrderServiceEvaluationViewController *evaluationVC = [[GBOrderServiceEvaluationViewController alloc] init];
                evaluationVC.orderDetailsType = self.orderDetailsType;
                evaluationVC.orderDeailsModel = self.orderDeailsModel;
                [self.navigationController pushViewController:evaluationVC animated:YES];
            }];
            
            return ;
        }else if ([self.seleArray[0][0] isEqualToString:@"自身原因，主动放弃服务"]) {
            type = @"REASON_SELF_GIVEUP";

        }else if ([self.seleArray[0][0] isEqualToString:@"协商一致，结束服务"]) {
            type = @"REASON_BOTH_AGREE";
        }
        
        GBRefundViewController *refundVC = [[GBRefundViewController alloc] init];
        refundVC.orderDeailsModel = self.orderDeailsModel;
        refundVC.reasonType = type;
        refundVC.remark = self.seleArray[0][0];
        [self.navigationController pushViewController:refundVC animated:YES];
        
    }];
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filtrateItem[section].content.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = @"请选择结束原因";
    headerView.moreButton.hidden = YES;
    [headerView.moreButton setImage:nil forState:UIControlStateNormal];
    
    headerView.titleLabel.font = Fit_M_Font(17);
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBReportTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBReportTableViewCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentItem = self.filtrateItem[indexPath.section].content[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        //限制每组内的Item只能选中一个(加入质数选择)
    if (_filtrateItem[indexPath.section].content[indexPath.row].isSelect == NO) {
        for (NSInteger j = 0; j < _filtrateItem[indexPath.section].content.count; j++) {
            _filtrateItem[indexPath.section].content[j].isSelect = NO;
        }
    }
    _filtrateItem[indexPath.section].content[indexPath.row].isSelect = !_filtrateItem[indexPath.section].content[indexPath.row].isSelect;
    
    //数组mutableCopy初始化,for循环加数组 结构大致：@[@[],@[]] 如此
    _seleArray = [@[] mutableCopy];
    for (NSInteger i = 0; i < _filtrateItem.count; i++) {
        NSMutableArray *section = [@[] mutableCopy];
        [_seleArray addObject:section];
    }
    
    //把所选的每组Item分别加入每组的数组中
    for (NSInteger i = 0; i < _filtrateItem.count; i++) {
        for (NSInteger j = 0; j < _filtrateItem[i].content.count; j++) {
            if (_filtrateItem[i].content[j].isSelect == YES) {
                [_seleArray[i] addObject:_filtrateItem[i].content[j].content];
            }else{
                [_seleArray[i] removeObject:_filtrateItem[i].content[j].content];
            }
        }
    }
    
    [tableView reloadData];
}

#pragma mark - # Getters and Setters

- (NSMutableArray<DCFiltrateItem *> *)filtrateItem
{
    if (!_filtrateItem) {
        _filtrateItem = [DCFiltrateItem mj_objectArrayWithFilename:@"EndService.plist"];
    }
    return _filtrateItem;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
