//
//  GBOrderServiceEvaluationViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/24.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 订单服务评价
//  @discussion <#类的功能#>
//

#import "GBOrderServiceEvaluationViewController.h"

// Controllers


// ViewModels


// Models


// Views
#import "FSTextView.h"


@interface GBOrderServiceEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FSTextView *textView;
/* 输入字符提示 */
@property (nonatomic, strong) UILabel *noticeLabel;

/* 星星-综合评价 */
@property (strong , nonatomic) HCSStarRatingView *starView;
/* 星星-回复速度 */
@property (strong , nonatomic) HCSStarRatingView *starView2;
/* 星星-专业程度 */
@property (strong , nonatomic) HCSStarRatingView *starView3;

/* 综合评价 */
@property (strong , nonatomic) UILabel *comprehensiveLabel;
/* 回复速度 */
@property (strong , nonatomic) UILabel *replyLabel;
/* 专业程度 */
@property (strong , nonatomic) UILabel *professionalLabel;


/* 星评提示 */
@property (nonatomic, strong) UILabel *starNoticeLabel;
@property (nonatomic, strong) UILabel *starNoticeLabel2;
@property (nonatomic, strong) UILabel *starNoticeLabel3;

/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* 标题 */
@property (nonatomic, strong) UILabel *sublabel;
/* <#describe#> */
@property (nonatomic, strong) UIView *headView;

@end

@implementation GBOrderServiceEvaluationViewController

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
        // 提交
        if (self.textView.text.length <= 0) {
            return [UIView showHubWithTip:@"请输入评价内容"];
        }
        
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        if (self.orderDetailsType == OrderDetailsTypeDecrypt) {
            [mineVM loadRequestMineDecryptEvaluate:self.orderDeailsModel.decryptId content:self.textView.text star:GBNSStringFormat(@"%.f",self.starView.value) responseStar:GBNSStringFormat(@"%.f",self.starView2.value) proficiencyStar:GBNSStringFormat(@"%.f",self.starView3.value)];
        }else {
            [mineVM loadRequestMineAssurePassEvaluate:self.orderDeailsModel.assurePassId content:self.textView.text star:GBNSStringFormat(@"%.f",self.starView.value) responseStar:GBNSStringFormat(@"%.f",self.starView2.value) proficiencyStar:GBNSStringFormat(@"%.f",self.starView3.value)];
        }
        
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            [self.navigationController popViewControllerAnimated:YES];
            [UIView showHubWithTip:@"评价成功"];
        }];
    };
    
    self.baseTableView.tableHeaderView = self.headView;
    
    [self addMasonry];
}


- (void)initSubViews {
    UIView *bgScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BottomViewFitHeight(72))];
    self.headView = bgScrollView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"服务评价";
    label.font = Fit_B_Font(28);
    label.textColor = [UIColor kImportantTitleTextColor];
    [bgScrollView addSubview:label];
    self.titleLabel = label;
    
    UILabel *sublabel = [[UILabel alloc] init];
    sublabel.text = @"请选择服务星级";
    sublabel.numberOfLines = 0;
    sublabel.font = Fit_Font(17);
    sublabel.textColor = [UIColor kImportantTitleTextColor];
    [bgScrollView addSubview:sublabel];
    self.sublabel = sublabel;
    
    // 达到最大限制时提示的Label
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.font = Fit_Font(12);
    noticeLabel.textColor = [UIColor kPlaceHolderColor];
    noticeLabel.textAlignment = NSTextAlignmentRight;
    [bgScrollView addSubview:noticeLabel];
    self.noticeLabel = noticeLabel;
    
    /** 综合评价 */
    UILabel *comprehensiveLabel = [[UILabel alloc] init];
    comprehensiveLabel.textColor = [UIColor kImportantTitleTextColor];
    comprehensiveLabel.font = Fit_Font(14);
    comprehensiveLabel.textAlignment = NSTextAlignmentLeft;
    comprehensiveLabel.text = @"综合评价";
    [bgScrollView addSubview:comprehensiveLabel];
    self.comprehensiveLabel = comprehensiveLabel;
    
    self.starView = [[HCSStarRatingView alloc] init];
    self.starView.emptyStarColor = UIColorFromRGB(0xBFBFBF);
    self.starView.emptyStarImage = [UIImage imageNamed:@"icon_star_empty"];
    self.starView.filledStarImage = [UIImage imageNamed:@"icon_star_sel"];
    self.starView.maximumValue = 5;
    self.starView.minimumValue = 0;
    self.starView.value = 5;
    [self.starView addTarget:self action:@selector(didChange:) forControlEvents:UIControlEventValueChanged];
    [bgScrollView addSubview:_starView];
    
    UILabel *starNoticeLabel = [[UILabel alloc] init];
    starNoticeLabel.textColor = [UIColor kAssistInfoTextColor];
    starNoticeLabel.font = Fit_Font(14);
    starNoticeLabel.textAlignment = NSTextAlignmentLeft;
    starNoticeLabel.text = @"很棒很奶斯~你就是大神~";
    [bgScrollView addSubview:starNoticeLabel];
    self.starNoticeLabel = starNoticeLabel;
    
    /** 回复速度 */
    UILabel *replyLabel = [[UILabel alloc] init];
    replyLabel.textColor = [UIColor kImportantTitleTextColor];
    replyLabel.font = Fit_Font(14);
    replyLabel.textAlignment = NSTextAlignmentLeft;
    replyLabel.text = @"回复速度";
    [bgScrollView addSubview:replyLabel];
    self.replyLabel = replyLabel;

    self.starView2 = [[HCSStarRatingView alloc] init];
    self.starView2.emptyStarColor = UIColorFromRGB(0xBFBFBF);
    self.starView2.emptyStarImage = [UIImage imageNamed:@"icon_star_empty"];
    self.starView2.filledStarImage = [UIImage imageNamed:@"icon_star_sel"];
    self.starView2.maximumValue = 5;
    self.starView2.minimumValue = 0;
    self.starView2.value = 5;
    [self.starView2 addTarget:self action:@selector(didChange:) forControlEvents:UIControlEventValueChanged];
    [bgScrollView addSubview:_starView2];
    
    UILabel *starNoticeLabel2 = [[UILabel alloc] init];
    starNoticeLabel2.textColor = [UIColor kAssistInfoTextColor];
    starNoticeLabel2.font = Fit_Font(14);
    starNoticeLabel2.textAlignment = NSTextAlignmentLeft;
    starNoticeLabel2.text = @"很棒很奶斯~你就是大神~";
    [bgScrollView addSubview:starNoticeLabel2];
    self.starNoticeLabel2 = starNoticeLabel2;
    
    /** 专业程度 */
    UILabel *professionalLabel = [[UILabel alloc] init];
    professionalLabel.textColor = [UIColor kImportantTitleTextColor];
    professionalLabel.font = Fit_Font(14);
    professionalLabel.textAlignment = NSTextAlignmentLeft;
    professionalLabel.text = @"专业程度";
    [bgScrollView addSubview:professionalLabel];
    self.professionalLabel = professionalLabel;
    
    self.starView3 = [[HCSStarRatingView alloc] init];
    self.starView3.emptyStarColor = UIColorFromRGB(0xBFBFBF);
    self.starView3.emptyStarImage = [UIImage imageNamed:@"icon_star_empty"];
    self.starView3.filledStarImage = [UIImage imageNamed:@"icon_star_sel"];
    self.starView3.maximumValue = 5;
    self.starView3.minimumValue = 0;
    self.starView3.value = 5;
    [self.starView3 addTarget:self action:@selector(didChange:) forControlEvents:UIControlEventValueChanged];
    [bgScrollView addSubview:_starView3];
    
    UILabel *starNoticeLabel3 = [[UILabel alloc] init];
    starNoticeLabel3.textColor = [UIColor kAssistInfoTextColor];
    starNoticeLabel3.font = Fit_Font(14);
    starNoticeLabel3.textAlignment = NSTextAlignmentLeft;
    starNoticeLabel3.text = @"很棒很奶斯~你就是大神~";
    [bgScrollView addSubview:starNoticeLabel3];
    self.starNoticeLabel3 = starNoticeLabel3;
    
    // FSTextView
    FSTextView *textView = [FSTextView textView];
    textView.placeholder =  @"请输入评价内容";
    textView.placeholderFont = Fit_Font(14);
    textView.font = Fit_Font(14);
    textView.editable = YES;
    // 限制输入最大字符数.
    textView.maxLength = 140;
    
    // 弱化引用, 以免造成内存泄露.
    __weak __typeof (&*noticeLabel) weakNoticeLabel = noticeLabel;
    weakNoticeLabel.text = @"0/140";
    
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        if (textView.text.length < textView.maxLength) {
            weakNoticeLabel.text = [NSString stringWithFormat:@"%zu/140", textView.text.length];
            weakNoticeLabel.textColor = [UIColor kPlaceHolderColor];
        }else {
            weakNoticeLabel.text = [NSString stringWithFormat:@"最多输入%zi个字符", textView.maxLength];
            weakNoticeLabel.textColor = [UIColor kBaseColor];
        }
    }];
    
    [bgScrollView addSubview:textView];
    self.textView = textView;
    
    GBViewBorderRadius(self.textView, 2, 1, [UIColor kSegmentateLineColor]);
}

#pragma mark - # Event Response
- (void)didChange:(HCSStarRatingView *)sender {
    if (sender.value <= 1) {
        if (sender == self.starView) {
            self.starNoticeLabel.text = @"本宝宝很不满意~";
        }else if (sender == self.starView2) {
            self.starNoticeLabel2.text = @"本宝宝很不满意~";

        }else if (sender == self.starView3) {
            self.starNoticeLabel3.text = @"本宝宝很不满意~";
        }
    }else if (sender.value <= 2) {
        if (sender == self.starView) {
            self.starNoticeLabel.text = @"还有待提高哦~";
        }else if (sender == self.starView2) {
            self.starNoticeLabel2.text = @"还有待提高哦~";
            
        }else if (sender == self.starView3) {
            self.starNoticeLabel3.text = @"还有待提高哦~";
        }
    }else if (sender.value <= 3) {
        if (sender == self.starView) {
            self.starNoticeLabel.text = @"还不错啦~";
        }else if (sender == self.starView2) {
            self.starNoticeLabel2.text = @"还不错啦~";
            
        }else if (sender == self.starView3) {
            self.starNoticeLabel3.text = @"还不错啦~";
        }
    }else if (sender.value <= 4) {
        if (sender == self.starView) {
        }else if (sender == self.starView2) {
            self.starNoticeLabel2.text = @"很给力哦~";
            
        }else if (sender == self.starView3) {
            self.starNoticeLabel3.text = @"很给力哦~";
        }
    }else if (sender.value <= 5) {
        if (sender == self.starView) {
            self.starNoticeLabel.text = @"很棒很奶斯~你就是大神~";
        }else if (sender == self.starView2) {
            self.starNoticeLabel2.text = @"很棒很奶斯~你就是大神~";
            
        }else if (sender == self.starView3) {
            self.starNoticeLabel3.text = @"很棒很奶斯~你就是大神~";
        }
    }
}

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
        make.height.equalTo(@48);
    }];
    
    // 综合评价
    [self.comprehensiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sublabel.mas_bottom).offset(GBMargin);
        make.left.equalTo(self.headView).offset(GBMargin);
        make.width.mas_equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sublabel.mas_bottom).offset(GBMargin);
        make.width.mas_equalTo(150);
        make.left.equalTo(self.comprehensiveLabel.mas_right).offset(GBMargin/2);
        make.height.equalTo(@30);
    }];
    
    [self.starNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView).offset(0);
        make.right.equalTo(self.headView).offset(-GBMargin);
        make.height.equalTo(@16);
        make.top.equalTo(self.starView.mas_bottom).offset(GBMargin/2);
    }];
    
    
    // 回复速度
    
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starNoticeLabel.mas_bottom).offset(GBMargin);
        make.left.equalTo(self.headView).offset(GBMargin);
        make.width.mas_equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    [self.starView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starNoticeLabel.mas_bottom).offset(GBMargin);
        make.width.mas_equalTo(150);
        make.left.equalTo(self.replyLabel.mas_right).offset(GBMargin/2);
        make.height.equalTo(@30);
    }];
    
    [self.starNoticeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView2).offset(0);
        make.right.equalTo(self.headView).offset(-GBMargin);
        make.height.equalTo(@16);
        make.top.equalTo(self.starView2.mas_bottom).offset(GBMargin/2);
    }];
    
    // 专业程度
    [self.professionalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starNoticeLabel2.mas_bottom).offset(GBMargin);
        make.left.equalTo(self.headView).offset(GBMargin);
        make.width.mas_equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    [self.starView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starNoticeLabel2.mas_bottom).offset(GBMargin);
        make.width.mas_equalTo(150);
        make.left.equalTo(self.professionalLabel.mas_right).offset(GBMargin/2);
        make.height.equalTo(@30);
    }];
    
    [self.starNoticeLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView3).offset(0);
        make.right.equalTo(self.headView).offset(-GBMargin);
        make.height.equalTo(@16);
        make.top.equalTo(self.starView3.mas_bottom).offset(GBMargin/2);
    }];
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headView).offset(-GBMargin);
        make.height.equalTo(@16);
    make.top.mas_equalTo(self.starNoticeLabel3.mas_bottom).offset(GBMargin);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).offset(GBMargin);
        make.right.equalTo(self.headView).offset(-GBMargin);
        make.top.equalTo(self.noticeLabel.mas_bottom).offset(GBMargin/2);
        make.bottom.equalTo(self.headView);
        make.height.equalTo(@120);
    }];
    
    
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


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
