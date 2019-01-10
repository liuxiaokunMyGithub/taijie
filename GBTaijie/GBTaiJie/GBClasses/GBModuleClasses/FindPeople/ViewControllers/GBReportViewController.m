//
//  GBReportViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/11.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 举报
//  @discussion <#类的功能#>
//

#import "GBReportViewController.h"

// Controllers
#import "DCFiltrateViewController.h"

// ViewModels


// Models
#import "DCContentItem.h"


// Views
#import "GBReportTableViewCell.h"
#import "GBPersonalSectionHeadView.h"
#import "FSTextView.h"

static NSString *const kGBReportTableViewCellID = @"GBReportTableViewCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

@interface GBReportViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 表尾 */
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) FSTextView *textView;
/* 提示语 */
@property (nonatomic, strong) UILabel *noticeLabel;
/** 最大数提示 */
@property (nonatomic, strong) UILabel *maxNoticeLabel;

/* 举报内容模型 */
@property (nonatomic, strong) NSMutableArray <DCFiltrateItem *> *filtrateItem;
/* 已选 */
@property (strong , nonatomic)NSMutableArray *seleArray;

@end

@implementation GBReportViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"举报";

    [self setupNav];
    
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.rowHeight = 55;
    self.baseTableView.sectionHeaderHeight = 60;
    self.baseTableView.sectionFooterHeight = 0.00001;

    [self.baseTableView registerClass:[GBReportTableViewCell class] forCellReuseIdentifier:kGBReportTableViewCellID];
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 60) title:@"举报"];
    self.baseTableView.tableFooterView = [self setTablViewFooterView];
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
}

#pragma mark - # Setup Methods
- (void)setupNav {
    [self.customNavBar wr_setRightButtonWithTitle:@"提交" titleColor:[UIColor kBaseColor]];

    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
    @GBStrongObj(self);
        if (!self.seleArray.count) {
            return [UIView showHubWithTip:@"请选择举报原因" timeintevel:1.5];
        }
        GBFindPeopleViewModel *findPeopleVM = [[GBFindPeopleViewModel alloc] init];
        [findPeopleVM loadRequestRelatedId:self.relatedId reportReason:self.seleArray[0][0] relatedType:self.relatedType remark:self.textView.text];
        
        [findPeopleVM setSuccessReturnBlock:^(id returnValue) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert addButton:@"确定" actionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];

            }];
            alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromCenter;
            [alert showSuccess:self title:@"举报成功" subTitle:@"平台会在24小时之内给出回复，感谢您对台阶的支持!" closeButtonTitle:nil duration:0.0f];
        }];
    }];
}

- (UIView *)setTablViewFooterView {
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    // 达到最大限制时提示的Label
    UILabel *maxNoticeLabel = [[UILabel alloc] init];
    maxNoticeLabel.font = Fit_Font(12);
    maxNoticeLabel.textColor = [UIColor kPlaceHolderColor];
    maxNoticeLabel.textAlignment = NSTextAlignmentRight;
    [_footView addSubview:maxNoticeLabel];
    self.maxNoticeLabel = maxNoticeLabel;
    
    // FSTextView
    FSTextView *textView = [FSTextView textView];
    textView.placeholder = @"输入详细原因";
    textView.editable = YES;
    textView.font = Fit_Font(14);
    // 限制输入最大字符数.
    textView.maxLength = 300;
    
    // 弱化引用, 以免造成内存泄露.
    __weak __typeof (&*maxNoticeLabel) weakNoticeLabel = maxNoticeLabel;
    weakNoticeLabel.text = [NSString stringWithFormat:@"0/300"];
    
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        if (textView.text.length < textView.maxLength) {
            weakNoticeLabel.text = [NSString stringWithFormat:@"%zu/300", textView.text.length];
            weakNoticeLabel.textColor = [UIColor kPlaceHolderColor];
            
        }else {
            weakNoticeLabel.text = [NSString stringWithFormat:@"最多输入%zi个字符", textView.maxLength];
            weakNoticeLabel.textColor = [UIColor kBaseColor];
        }
        //
    }];
    
    [_footView addSubview:textView];
    self.textView = textView;
    GBViewBorderRadius(self.textView, 2, 1, [UIColor kSegmentateLineColor]);
    
    // 达到最大限制时提示的Label
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.font = Fit_Font(12);
    noticeLabel.text = @"台阶App将对用户方案信息、违法有害信息等采取零容忍态度！一经核实，立即封号！";
    noticeLabel.textAlignment = NSTextAlignmentLeft;
    noticeLabel.numberOfLines = 2;
    noticeLabel.textColor = [UIColor kPlaceHolderColor];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    [_footView addSubview:noticeLabel];
    self.noticeLabel = noticeLabel;
    
    [self addMasonry];
    
    return _footView;
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods
- (void)addMasonry {
    [self.maxNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GBMargin/2);
        make.right.mas_equalTo(-GBMargin);
        make.height.equalTo(@16);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.top.equalTo(self.maxNoticeLabel.mas_bottom).offset(GBMargin/2);
        make.height.equalTo(@160);
    }];

    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(GBMargin/2);
        make.left.mas_equalTo(self.footView).offset(GBMargin);
        make.right.mas_equalTo(self.footView).offset(-GBMargin);
    }];
    
    
}

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
    headerView.titleLabel.text = @"请选择举报原因";
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
    if (self.isMutableSelect != YES) {
        //限制每组内的Item只能选中一个(加入质数选择)
        if (_filtrateItem[indexPath.section].content[indexPath.row].isSelect == NO) {
            for (NSInteger j = 0; j < _filtrateItem[indexPath.section].content.count; j++) {
                _filtrateItem[indexPath.section].content[j].isSelect = NO;
            }
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
        _filtrateItem = [DCFiltrateItem mj_objectArrayWithFilename:@"ReportItem.plist"];
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
