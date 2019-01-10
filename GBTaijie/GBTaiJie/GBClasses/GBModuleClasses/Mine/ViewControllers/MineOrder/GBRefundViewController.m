//
//  GBRefundViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/24.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 申请退款
//  @discussion <#类的功能#>
//

#import "GBRefundViewController.h"

// Controllers


// ViewModels


// Models


// Views


@interface GBRefundViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

/* 输入字符提示 */
@property (nonatomic, strong) UILabel *noticeLabel;

/* 综合评价 */
@property (strong , nonatomic) UILabel *orderNubLabel;
/* 回复速度 */
@property (strong , nonatomic) UILabel *replyLabel;
/* 专业程度 */
@property (strong , nonatomic) UILabel *professionalLabel;
@property (strong , nonatomic) UILabel *bountyTitleLabel;

/* <#describe#> */
@property (nonatomic, strong) UIView *pointView;

/* 星评提示 */
@property (nonatomic, strong) UILabel *serviceTitleLabel;
@property (nonatomic, strong) UILabel *orderMoney;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *bountyLabel;

/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* 标题 */
@property (nonatomic, strong) UILabel *sublabel;
/* <#describe#> */
@property (nonatomic, strong) UIView *headView;

@end

@implementation GBRefundViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"订单评价";
    
    [self initSubViews];
    
    //    [self data];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.rowHeight = 15;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.view addSubview:self.baseTableView];
    self.baseTableView.height = SCREEN_HEIGHT - SafeAreaTopHeight - BottomViewFitHeight(72);
    
    [self.view addSubview:[self setupBottomViewWithtitle:@"提交"]];
    
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
        @GBStrongObj(self);
        if ([self.textField.text integerValue] > self.orderDeailsModel.price) {
            return [UIView showHubWithTip:@"输入退款金额不能大于可退金额"];
        }
        
        // 提交
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestMineAssurePassFinish:self.orderDeailsModel.assurePassId reasonType:self.reasonType remark:self.remark refundAmount:self.textField.text rewardAmount:GBNSStringFormat(@"%zu",self.orderDeailsModel.price - [self.textField.text integerValue])];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            // 退款计数统计
            [GBAppDelegate setupJAnalyticsCountEvent:@"orderRefund_GB"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [UIView showHubWithTip:@"提交成功"];
        }];
    };
    
    self.baseTableView.tableHeaderView = self.headView;
    
    [self addMasonry];
}


#pragma mark - # Setup Methods
- (void)initSubViews {
    UIView *bgScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BottomViewFitHeight(72))];
    self.headView = bgScrollView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"申请退款";
    label.font = Fit_B_Font(28);
    label.textColor = [UIColor kImportantTitleTextColor];
    [bgScrollView addSubview:label];
    self.titleLabel = label;
    
    UILabel *sublabel = [[UILabel alloc] init];
    sublabel.text = @"已选退款服务";
    sublabel.numberOfLines = 0;
    sublabel.font = Fit_M_Font(18);
    sublabel.textColor = [UIColor kImportantTitleTextColor];
    [bgScrollView addSubview:sublabel];
    self.sublabel = sublabel;
    
    // 达到最大限制时提示的Label
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.font = Fit_Font(12);
    noticeLabel.numberOfLines = 0;
    noticeLabel.textColor = [UIColor kAssistInfoTextColor];
    noticeLabel.text = @"提示：审核成功后将扣除0.15%的退款手续费。如果您没有全部退款，剩余部分将作为酬赏打赏给服务提供者。退款金额将在7个工作日内审核并退至原账户。";
    [bgScrollView addSubview:noticeLabel];
    self.noticeLabel = noticeLabel;
    
    [bgScrollView addSubview:self.pointView];
    
    /** 综合评价 */
    UILabel *orderNubLabel = [[UILabel alloc] init];
    orderNubLabel.textColor = [UIColor kAssistInfoTextColor];
    orderNubLabel.font = Fit_Font(12);
    orderNubLabel.textAlignment = NSTextAlignmentLeft;
    orderNubLabel.text = GBNSStringFormat(@"订单号：%@",self.orderDeailsModel.orderNo);
    [bgScrollView addSubview:orderNubLabel];
    self.orderNubLabel = orderNubLabel;

    UILabel *serviceTitleLabel = [[UILabel alloc] init];
    serviceTitleLabel.textColor = [UIColor kImportantTitleTextColor];
    serviceTitleLabel.font = Fit_Font(14);
    serviceTitleLabel.numberOfLines = 0;
    serviceTitleLabel.text = self.orderDeailsModel.title;
    [bgScrollView addSubview:serviceTitleLabel];
    self.serviceTitleLabel = serviceTitleLabel;
    
    /** 回复速度 */
    UILabel *replyLabel = [[UILabel alloc] init];
    replyLabel.textColor = [UIColor kImportantTitleTextColor];
    replyLabel.font = Fit_Font(14);
    replyLabel.textAlignment = NSTextAlignmentLeft;
    replyLabel.text = @"此订单可退金额";
    [bgScrollView addSubview:replyLabel];
    self.replyLabel = replyLabel;

    UILabel *orderMoney = [[UILabel alloc] init];
    orderMoney.textColor = [UIColor kPromptRedColor];
    orderMoney.font = Fit_Font(14);
    orderMoney.textAlignment = NSTextAlignmentLeft;
    orderMoney.text = GBNSStringFormat(@"%zu元",self.orderDeailsModel.price);
    [bgScrollView addSubview:orderMoney];
    self.orderMoney = orderMoney;
    
    /** 专业程度 */
    UILabel *professionalLabel = [[UILabel alloc] init];
    professionalLabel.textColor = [UIColor kImportantTitleTextColor];
    professionalLabel.font = Fit_Font(14);
    professionalLabel.textAlignment = NSTextAlignmentLeft;
    professionalLabel.text = @"请填写申请退款金额";
    [bgScrollView addSubview:professionalLabel];
    self.professionalLabel = professionalLabel;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(188, 374, 126, 16);
    textField.placeholder = @"请输入折扣后的价格";
    textField.font = Fit_Font(14);
    textField.delegate = self;
    textField.textColor = [UIColor kAssistInfoTextColor];
    [bgScrollView addSubview:textField];
    self.textField = textField;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    /** 回复速度 */
    UILabel *bountyTitleLabel = [[UILabel alloc] init];
    bountyTitleLabel.textColor = [UIColor kImportantTitleTextColor];
    bountyTitleLabel.font = Fit_Font(14);
    bountyTitleLabel.textAlignment = NSTextAlignmentLeft;
    bountyTitleLabel.text = @"酬赏金额";
    [bgScrollView addSubview:bountyTitleLabel];
    self.bountyTitleLabel = bountyTitleLabel;
    
    UILabel *bountyLabel = [[UILabel alloc] init];
    bountyLabel.textColor = [UIColor kPromptRedColor];
    bountyLabel.font = Fit_Font(14);
    bountyLabel.textAlignment = NSTextAlignmentLeft;
    bountyLabel.text = @"0元";
    [bgScrollView addSubview:bountyLabel];
    self.bountyLabel = bountyLabel;
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods
- (void)addMasonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(GBMargin);
        make.height.equalTo(@30);
    }];
    
    [self.sublabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(GBMargin/2);
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.height.equalTo(@30);
    }];
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderNubLabel);
        make.left.equalTo(self.headView).offset(GBMargin);
        make.height.width.equalTo(@4);
    }];

    GBViewRadius(self.pointView, 2);
    
    [self.orderNubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sublabel.mas_bottom).offset(GBMargin);
        make.left.equalTo(self.pointView.mas_right).offset(5);
        make.height.equalTo(@20);
    }];
    
    [self.serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNubLabel).offset(0);
        make.right.equalTo(self.headView).offset(-GBMargin);
        make.top.equalTo(self.orderNubLabel.mas_bottom).offset(3);
    }];
    
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serviceTitleLabel.mas_bottom).offset(GBMargin);
        make.left.equalTo(self.headView).offset(GBMargin);
        make.height.equalTo(@20);
    }];
    
    
    [self.orderMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyLabel.mas_right).offset(8);
        make.top.equalTo(self.serviceTitleLabel.mas_bottom).offset(GBMargin);
        make.height.equalTo(@20);
    }];
    
    [self.professionalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderMoney.mas_bottom).offset(GBMargin);
        make.left.equalTo(self.headView).offset(GBMargin);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.professionalLabel.mas_right).offset(3);
        make.right.equalTo(self.headView).offset(-GBMargin);
        make.height.equalTo(@20);
        make.top.equalTo(self.orderMoney.mas_bottom).offset(GBMargin);
    }];
    
    [self.bountyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(GBMargin);
        make.left.equalTo(self.headView).offset(GBMargin);
        make.height.equalTo(@20);
    }];
    
    [self.bountyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(GBMargin);
        make.left.equalTo(self.bountyTitleLabel.mas_right).offset(8);
        make.height.equalTo(@20);
    }];
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(GBMargin);
        make.right.equalTo(self.headView).offset(-GBMargin);
        make.height.equalTo(@80);
        make.top.equalTo(self.bountyTitleLabel.mas_bottom).offset(GBMargin/2);
    }];
    
    [DCSpeedy dc_setUpAcrossPartingLineWith:self.textField WithColor:[UIColor kSegmentateLineColor] margin:0];
}

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - # Getters and Setters
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.textField.text integerValue] > self.orderDeailsModel.price) {
        self.bountyLabel.text = @"0元";
    }else {
        self.bountyLabel.text = GBNSStringFormat(@"%zu元",self.orderDeailsModel.price - [textField.text integerValue]);
    }
}

- (UIView *)pointView {
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        _pointView.backgroundColor = [UIColor colorWithHexString:@"#C6C6C9"];
    }
    
    return _pointView;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
