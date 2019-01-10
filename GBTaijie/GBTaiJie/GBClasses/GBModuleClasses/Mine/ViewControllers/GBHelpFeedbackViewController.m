//
//  GBHelpFeedbackViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBHelpFeedbackViewController.h"

// Controllers
#import "GBFeedbackViewController.h"
// ViewModels


// Models


// Views
#import "GBPersonalSectionHeadView.h"
#import "GBSettingCell.h"

static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBHelpFeedbackViewController ()<UITableViewDelegate,UITableViewDataSource>
/* 组标题 */
@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;
/* 行标题 */
@property (nonatomic, strong) NSMutableArray <NSArray *> *contentTitlesArray;
/* 底部按钮 */
@property (nonatomic, strong) UIView *bottomView;

/* 分割线 */
@property (nonatomic, strong) UIView *lineView;

/* 确认按钮 */
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation GBHelpFeedbackViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"意见反馈";

    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 50;
    self.baseTableView.rowHeight = 50;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"帮助与反馈"];
    [self.view addSubview:[self setupBottomViewWithtitle:@"意见反馈"]];
    self.baseTableView.height = SCREEN_HEIGHT - SafeAreaTopHeight - BottomViewFitHeight(72);
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
    @GBStrongObj(self);
        GBFeedbackViewController *feedbackVC = [[GBFeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    };
}


#pragma mark - # Setup Methods
- (UIImageView *)setupTableViewHeaderImageView {
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    headImageView.image = GBImageNamed(@"headBgImage");
    
    return headImageView;
}

#pragma mark - # Event Response
- (void)feedbackButtonAction {
    
}

#pragma mark - # Privater Methods

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentTitlesArray[section].count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = self.sectionTitlesArray[section];
    headerView.titleLabel.font =  Fit_M_Font(17);
    headerView.moreButton.hidden = YES;
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(GBSettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = self.contentTitlesArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.font = Fit_Font(14);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *titleArr = @[@[@"解密专题指南",@"入职保过使用指南"],@[@"解密专题指南",@"入职保过使用指南"],@[@"支付与退款服务指南",@"收益提现服务指南"]];
    NSArray *nameArr = @[@[@"decrypt_help_candidate.html",@"sesrvice_items.html"],@[@"decrypt_help_incumbent.html",@"bg_help_incumbent.html"],@[@"pay_refund.html",@"withdraw.html"]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_GB_HTML,nameArr[indexPath.section][indexPath.row]];
    GBBaseWebViewController *webView = [[GBBaseWebViewController alloc] initWithUrl:url];
    webView.titleStr = titleArr[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:webView animated:YES];
    
}

#pragma mark - # Getters and Setters
- (NSMutableArray *)sectionTitlesArray {
    if (!_sectionTitlesArray) {
        _sectionTitlesArray = [NSMutableArray arrayWithArray:@[@"我是求助者",@"我是认证同事",@"其他"]];
    }
    
    return _sectionTitlesArray;
}

- (NSMutableArray *)contentTitlesArray {
    if (!_contentTitlesArray) {
        _contentTitlesArray = [NSMutableArray arrayWithArray:@[@[@"解密专题指南",@"入职保过使用指南"],@[@"解密专题指南",@"入职保过使用指南"],@[@"支付与退款服务指南",@"收益提现服务指南"]]];
    }
    
    return _contentTitlesArray;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor kSegmentateLineColor];
    }
    return _lineView;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton addTarget:self action:@selector(feedbackButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setTitle:@"意见反馈" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = Fit_B_Font(17);
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage imageNamed:@"button_bg_long"] forState:UIControlStateNormal];
    }
    return _confirmButton;
}
// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
