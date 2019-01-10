//
//  GBCommonPersonalHomePageViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/20.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 个人主页 - 通用
//  @discussion <#类的功能#>
//

#import "GBCommonPersonalHomePageViewController.h"

// Controllers
#import "GBMoreCommentViewController.h"
#import "GBServiceDetailsViewController.h"
#import "GBReportViewController.h"
#import "GBMoreDecryptionListViewController.h"
// ViewModels


// Models
#import "GBFindViewModel.h"
#import "GBFindColleaguesModel.h"
#import "GBFindPeopleModel.h"
#import "GBPersonalCommentModel.h"
#import "GBPastExperienceModel.h"
#import "GBPositionServiceModel.h"
#import "GBAssureContentTagModel.h"

// Views
#import "GBFindDecryptionCell.h"
#import "GBPersonalSectionHeadView.h"
#import "GBFindColleaguesTableViewCell.h"
#import "GBPersonalHomePageCardHeadView.h"
#import "GBPersonalHomePageStoryHeadView.h"
#import "GBPraiseTableViewCell.h"
#import "GBMoreCommentListCell.h"
#import "GBPersonalCertificationInfoCell.h"
#import "HXTagsCell.h"
#import "GBPersonalServiceCell.h"
#import "GBPastExperienceTableViewCell.h"

static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";
static NSString *const kGBFindDecryptionCellID = @"GBFindDecryptionCell";
static NSString *const kGBFindColleaguesTableViewCellID = @"GBFindColleaguesTableViewCell";

static NSString *const kGBPraiseTableViewCellID = @"GBPraiseTableViewCell";
static NSString *const kGBMoreCommentListCellID = @"GBMoreCommentListCell";
static NSString *const kGBPersonalCertificationInfoCellID = @"GBPersonalCertificationInfoCell";
static NSString *const kGBPersonalServiceCellID = @"GBPersonalServiceCell";
static NSString *const kDWQLogisticCellID = @"DWQLogisticCell";

static NSString *const kGBPastExperienceTableViewCellID = @"GBPastExperienceTableViewCell";

@interface GBCommonPersonalHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 评论 */
@property (nonatomic, strong) NSMutableArray <GBPersonalCommentModel *>*comments;


/* <#describe#> */
@property (nonatomic, strong) NSArray *sectionTitleArray;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBFindColleaguesModel *> *colleaguesModels;

/* <#describe#> */
@property (nonatomic, strong) UIView *headView;

/* <#describe#> */
@property (nonatomic, strong) GBPersonalHomePageCardHeadView *headCardView;
/* <#describe#> */
@property (nonatomic, strong) GBPersonalHomePageStoryHeadView *storyHeadView;

/* 入职保过 */
@property (nonatomic, strong) NSMutableArray <GBPositionServiceModel *> *assuredArray;
/* 私聊解密 */
@property (nonatomic, strong) NSMutableArray <GBPositionServiceModel*> *decryptionArray;
/* 过往经验 */
@property (nonatomic, strong) NSMutableArray <GBPastExperienceModel *>*pastExperienceArray;

/* 认证信息图标 */
@property (nonatomic, strong) NSMutableArray *certificatIcons;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *tags;
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBAssureContentTagModel *> *positonTagModels;
/* 个人信息 */
@property (nonatomic, strong) GBFindPeopleModel *peopleModel;

@property (nonatomic,strong) HXTagCollectionViewFlowLayout *layout;//布局layout
@property (nonatomic,strong) HXTagAttribute *tagAttribute;//按钮样式对象

/* 口碑 */
@property (nonatomic, strong) NSMutableArray *praises;
/* <#describe#> */
@property (nonatomic, assign) NSInteger tagViewHeight;

// 下拉菜单数据
@property (nonatomic,strong) NSArray *menuItemNames;

/* 半透明遮罩视图 */
@property (nonatomic, strong) UIView *maskView;

/* <#describe#> */
@property (nonatomic, assign) NSInteger decryptCount;

@end

@implementation GBCommonPersonalHomePageViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GBNotificationCenter removeObserver:self name:YCXMenuWillDisappearNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView setAnimationsEnabled:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.decryptCount = -1;
    // 下拉菜单通知
    [GBNotificationCenter addObserver:self selector:@selector(menuWillDisappear) name:YCXMenuWillDisappearNotification object:nil];
    
    [self headerRereshing];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.sectionFooterHeight = 0.00001;
    self.baseTableView.sectionHeaderHeight = 50;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    
    [self.baseTableView registerClass:[GBPersonalCertificationInfoCell class] forCellReuseIdentifier:kGBPersonalCertificationInfoCellID];
    
    [self.baseTableView registerClass:[GBMoreCommentListCell class] forCellReuseIdentifier:kGBMoreCommentListCellID];
    [self.baseTableView registerClass:[GBPastExperienceTableViewCell class] forCellReuseIdentifier:kGBPastExperienceTableViewCellID];
    
    [self.baseTableView registerClass:[GBPraiseTableViewCell class] forCellReuseIdentifier:kGBPraiseTableViewCellID];
    
    [self.baseTableView registerClass:[GBPersonalServiceCell class] forCellReuseIdentifier:kGBPersonalServiceCellID];
    [self.view addSubview:self.baseTableView];
    
    // 故事
    [self.headView addSubview:self.storyHeadView];
    // 名片
    [self.headView addSubview:self.headCardView];
    
    self.baseTableView.tableHeaderView = self.headView;
    
    @GBWeakObj(self);
    self.headCardView.exchangeBlock = ^{
        @GBStrongObj(self);
        // 切换 - 名片故事
        [self exchangeSubviewWithSuperView:self.headView isRight:YES];
    };
    
    self.storyHeadView.exchangeBlock = ^{
        @GBStrongObj(self);
        // 切换
        [self exchangeSubviewWithSuperView:self.headView isRight:NO];
    };
    
    // 新增访问量
    [self loadRequestPersonalHomePageVisitOnce];
}

#pragma mark - # Setup Methods
- (void)headerRereshing {
    [super headerRereshing];
    // 个人信息
    [self getPersonalInfo];
    // 服务
    [self getPersonalServiceInfo];
    // 经验
    [self loadRequestMineMicroExperienceList];
}

- (void)setUpNavigationBar {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_more")];
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
        [self menuFunction];
    }];
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
    
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 60, SafeAreaTopHeight, 50, 0) menuItems:self.menuItemNames selected:^(NSInteger index, YCXMenuItem *item) {
        
        self.maskView.alpha = 0;
        
        switch (index) {
            case 0:
            {
                [self collectRequset];
            }
                break;
            case 1:
            {
                // 分享
                [KEYWINDOW addSubview:[ShareManagerInstance shareView]];
                ShareManagerInstance.shareTitle = GBNSStringFormat(@"我是%@%@，帮你职场弯道超车",self.peopleModel.companyName,self.peopleModel.nickName);
                ShareManagerInstance.shareText = GBNSStringFormat(@"已在职%zu年，%@年工作经验 | 【台阶】真实认证员工",self.peopleModel.inServiceTime,ValidStr(self.peopleModel.workingYear) ? self.peopleModel.workingYear : @"0");
                ShareManagerInstance.shareUrl = GBNSStringFormat(@"%@%zu",HTML_HomePage_Share,self.peopleModel.userId);
                ShareManagerInstance.imageData = [UIImage getImageDataURL:GBImageURL(self.peopleModel.headImg)];
                [[ShareManagerInstance shareView] showWithContentType:JSHARELink];
            }
                break;
            case 2:
            {
                GBReportViewController *reportVC = [[GBReportViewController alloc] init];
                reportVC.relatedType = @"REPORT_TYPE_USER";
                reportVC.relatedId = GBNSStringFormat(@"%zu",self.peopleModel.userId);
                [self.navigationController pushViewController:reportVC animated:YES];
            }
                break;
            default:
                break;
        }
    }];
}


- (void)collectRequset {
    
    if ([self.peopleModel.isCollected isEqualToString:@"1"]) {
        GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
        [positionVM loadRequestCollectCancel:GBNSStringFormat(@"%zu",self.peopleModel.userId)];
        [positionVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"取消收藏成功"];
            self.peopleModel.isCollected = @"0";
        }];
    }else {
        // 未收藏
        GBFindPeopleViewModel *peopleVM = [[GBFindPeopleViewModel alloc] init];
        [peopleVM loadRequestCollect:GBNSStringFormat(@"%zu",self.peopleModel.userId)  type:@"COLLECTION_TYPE_USER"];
        [peopleVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"收藏成功"];
            self.peopleModel.isCollected = @"1";
        }];
    }
    
}

// 个人信息，评论
- (void)getPersonalInfo {
    GBFindPeopleViewModel *findPeopleVM = [[GBFindPeopleViewModel alloc] init];
    [findPeopleVM loadRequestPersonComment:1 pageSize:1 targetUserId:self.targetUsrid];
    [findPeopleVM setSuccessReturnBlock:^(id returnValue) {
        self.peopleModel = [GBFindPeopleModel mj_objectWithKeyValues:returnValue[@"incumbentDetail"]];
        
        [self setUpNavigationBar];
        
        if (ValidStr(self.peopleModel.adeptSkill)) {
            NSArray *skillTags = [self.peopleModel.adeptSkill componentsSeparatedByString:@","];
            self.tags = [NSMutableArray arrayWithArray:skillTags];
            
            self.tagViewHeight = [HXTagsCell getCellHeightWithTags:self.tags layout:self.layout tagAttribute:self.tagAttribute width:SCREEN_WIDTH - GBMargin*2];
        }
        
        self.headCardView.personalInfoModel = self.peopleModel;
        self.headCardView.tags = self.tags;
        [self.headCardView reloadTags];
        
        self.storyHeadView.personalInfoModel = self.peopleModel;
        
        
        self.praises = [[NSMutableArray alloc] initWithArray:@[GBNSStringFormat(@"%@%@",self.peopleModel.goodRate,@"%") ,self.peopleModel.orderCount,self.peopleModel.responseTimeStr,GBNSStringFormat(@"%@%@",self.peopleModel.proficiencyRate,@"%"),GBNSStringFormat(@"%@%@",self.peopleModel.receiveRate,@"%")]];
        
        // 评论
        if (ValidArray(returnValue[@"commentList"][@"list"])) {
            self.comments = [GBPersonalCommentModel mj_objectArrayWithKeyValuesArray:returnValue[@"commentList"][@"list"]];
        }
        // 芝麻
        if (self.peopleModel.zhimaCreditAuthentication) {
            [self.certificatIcons addObject:GBImageNamed(@"icon_credit_green")];
        }
        
        // 公司邮箱
        if (self.peopleModel.companyEmailAuthentication) {
            [self.certificatIcons addObject:GBImageNamed(@"icon_email_orange")];
        }else {
            [self.certificatIcons addObject:GBImageNamed(@"icon_email")];
        }
        
        // 工牌
        if (self.peopleModel.badgeAuthentication) {
            [self.certificatIcons addObject:GBImageNamed(@"icon_card_yellow")];
        }else {
            [self.certificatIcons addObject:GBImageNamed(@"icon_card")];
        }
        
        // 在职证明
        if (self.peopleModel.incumbencyCertification) {
            [self.certificatIcons addObject:GBImageNamed(@"icon_jobcertificate_green")];
        }else {
            [self.certificatIcons addObject:GBImageNamed(@"icon_jobcertificate")];
        }
        
        // 劳动合同
        if (self.peopleModel.laborContract) {
            [self.certificatIcons addObject:GBImageNamed(@"icon_Laborcontract_purple")];
        }else {
            [self.certificatIcons addObject:GBImageNamed(@"icon_Laborcontract")];
        }
        
        self.baseTableView.tableFooterView = [self setupTableViewFooter];
    }];
    
    [self.baseTableView reloadData];
}

// 个人服务
- (void)getPersonalServiceInfo {
    GBFindPeopleViewModel *findPeopleVM = [[GBFindPeopleViewModel alloc] init];
    [findPeopleVM loadRequestPersonalService:1 pageSize:10 targetUserId:self.targetUsrid];
    [findPeopleVM setSuccessReturnBlock:^(id returnValue) {
        if (ValidArray(returnValue[@"decryptServices"][@"list"])) {
            self.decryptionArray = [GBPositionServiceModel mj_objectArrayWithKeyValuesArray:returnValue[@"decryptServices"][@"list"]];
        }
        
        self.decryptCount = [returnValue[@"decryptServices"][@"totalCount"] integerValue];
        
        if (ValidArray(returnValue[@"assureServices"][@"list"])) {
            self.assuredArray = [GBPositionServiceModel mj_objectArrayWithKeyValuesArray:returnValue[@"assureServices"][@"list"]];
        }
        
        [self.baseTableView reloadData];
        
    }];
}

// 过往经验
- (void)loadRequestMineMicroExperienceList {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineMicroExperienceList:self.targetUsrid];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.pastExperienceArray = [GBPastExperienceModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.baseTableView reloadData];
    }];
}

// 浏览量
- (void)loadRequestPersonalHomePageVisitOnce {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestPersonalHomePageVisitOnce:self.targetUsrid];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        
    }];
}

#pragma mark - # Event Response
//根据父视图旋转切换子视图
- (void)exchangeSubviewWithSuperView:(UIView *)superView isRight:(BOOL)isRight
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.35];
    [UIView setAnimationTransition:isRight ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight forView:superView cache:YES];
    
    //切换该视图两个子视图的索引位置
    [superView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    [UIView commitAnimations];
}
#pragma mark - # Privater Methods
- (UIView *)setupTableViewFooter {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UILabel *titleLabel = [UILabel createLabelWithFrame:CGRectMake(GBMargin, GBMargin/2, 180, 30) text:@"已成为认证同事" font:Fit_M_Font(18) textColor:[UIColor kImportantTitleTextColor]];
    [footerView addSubview:titleLabel];
    
    UILabel *titleLabel2 = [UILabel createLabelWithFrame:CGRectMake(SCREEN_WIDTH - GBMargin - 180, GBMargin/2, 180, 30) text:GBNSStringFormat(@"%zu天",self.peopleModel.entryDays) font:Fit_Font(16) textColor:[UIColor colorWithHexString:@"#FA513B"] textAlignment:NSTextAlignmentRight];
    
    [footerView addSubview:titleLabel2];
    
    return footerView;
}

#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.decryptionArray.count;
    }
    
    if (section == 2) {
        return self.assuredArray.count;
    }
    
    if (section == 4) {
        return self.pastExperienceArray.count;
    }
    
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 1 ) {
//        return 0.00001;
//    }
//
//    if (section == 2) {
//                return 6;
//            }
//    return 50;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 95;
    }
    
    if (indexPath.section == 1 || indexPath.section == 2) {
        return [tableView fd_heightForCellWithIdentifier:kGBPersonalServiceCellID cacheByIndexPath:indexPath configuration:^(GBPersonalServiceCell *cell) {
            [self configureServiceCell:cell atIndexPath:indexPath];
        }];
    }
    
    if (indexPath.section == 3) {
        return self.comments.count > 0 ? [tableView fd_heightForCellWithIdentifier:kGBMoreCommentListCellID cacheByIndexPath:indexPath configuration:^(GBMoreCommentListCell *cell) {
            [self configureCommentListCell:cell atIndexPath:indexPath];
        }] : 0.1;
    }
    
    if (indexPath.section == 4) {
        return 85;
    }
    
    if (indexPath.section == 5) {
        return self.tagViewHeight;
    }
    
    return 220;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.section = section;
    headerView.titleLabel.text = [self.sectionTitleArray objectAtIndex:section];
    [headerView.moreButton setTitle:@"更多" forState:UIControlStateNormal];
    headerView.moreButton.hidden = YES;
    if (section == 1) {
        BOOL hasDecrypt = self.decryptionArray.count ? YES : NO;

        headerView.moreButton.hidden = (0 < self.decryptCount && self.decryptCount <= 5) ? YES : NO;
        [headerView.moreButton setTitleColor:self.decryptCount > 5 ? [UIColor kBaseColor] : [UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        if (!hasDecrypt) {
            [headerView.moreButton setTitle:@"暂未添加" forState:UIControlStateNormal];
        }
        headerView.moreButton.userInteractionEnabled = YES;
    }
    
    if (section == 2) {
        BOOL hasAssured = self.assuredArray.count ? YES : NO;
        [headerView.moreButton setTitle:@"暂未添加" forState:UIControlStateNormal];
        headerView.moreButton.hidden = hasAssured;
        [headerView.moreButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
    }
    
    if (section == 3) {
        BOOL hasComment = self.comments.count ? YES : NO;
        [headerView.moreButton setTitle: hasComment ? @"更多" : @"暂无评价" forState:UIControlStateNormal];
        headerView.moreButton.hidden = NO;
        headerView.moreButton.userInteractionEnabled = hasComment;
        [headerView.moreButton setTitleColor:hasComment ? [UIColor kBaseColor] : [UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
    }
    
    if (section == 4) {
        BOOL hasPastExperience = self.pastExperienceArray.count ? YES : NO;
        [headerView.moreButton setTitle:@"暂未添加" forState:UIControlStateNormal];
        headerView.moreButton.hidden = hasPastExperience;
        [headerView.moreButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
    }
    
    if (section == 5) {
        BOOL hasSkill = self.tags.count ? YES : NO;
        [headerView.moreButton setTitle:@"暂未添加" forState:UIControlStateNormal];
        headerView.moreButton.hidden = hasSkill;
        [headerView.moreButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
    }
    
    [headerView.moreButton setImage:nil forState:UIControlStateNormal];
    headerView.moreButtonClickBlock = ^(NSInteger section) {
        if (section == 1) {
            GBMoreDecryptionListViewController *moreDecryptionListVC = [[GBMoreDecryptionListViewController alloc] init];
            moreDecryptionListVC.targetUserId = self.targetUsrid;
            [self.navigationController pushViewController:moreDecryptionListVC animated:YES];
            return ;
        }
        
        GBMoreCommentViewController *moreCommentVC = [[GBMoreCommentViewController alloc] init];
        moreCommentVC.targetUsrid = self.targetUsrid;
        [self.navigationController pushViewController:moreCommentVC animated:YES];
    };
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GBPraiseTableViewCell *findColleaguesTableViewCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!findColleaguesTableViewCell) {
            findColleaguesTableViewCell = [[GBPraiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBPraiseTableViewCellID];
        }
        
        findColleaguesTableViewCell.praises = self.praises;
        [findColleaguesTableViewCell.collectionView reloadData];
        
        return findColleaguesTableViewCell;
    }
    
    if (indexPath.section == 1 || indexPath.section == 2) {
        GBPersonalServiceCell *serviceCell = [[GBPersonalServiceCell alloc] init];
        if (!serviceCell) {
            serviceCell = [[GBPersonalServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBPersonalServiceCellID];
        }
        
        [self configureServiceCell:serviceCell atIndexPath:indexPath];
        
        return serviceCell;
    }
    
    if (indexPath.section == 3) {
        // MARK: 评价
        GBMoreCommentListCell *commentCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!commentCell) {
            commentCell = [[GBMoreCommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBMoreCommentListCellID];
        }
        
        [self configureCommentListCell:commentCell atIndexPath:indexPath];
        return commentCell;
    }
    
    if (indexPath.section == 4) {
        GBPastExperienceTableViewCell *pastExperienceCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!pastExperienceCell) {
            pastExperienceCell = [[GBPastExperienceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBPastExperienceTableViewCellID];
        }
        pastExperienceCell.line.hidden = indexPath.row == self.pastExperienceArray.count - 1 ? YES : NO;
        
        pastExperienceCell.pastExperienceModel = self.pastExperienceArray[indexPath.row];
        
        return pastExperienceCell;
    }
    
    if (indexPath.section == 5) {
        HXTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (!cell) {
            cell = [[HXTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        }
        
        cell.tags = self.tags;
        cell.layout = self.layout;
        cell.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
            NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
        };
        cell.tagAttribute = self.tagAttribute;
        
        [cell reloadData];
        
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    // MARK: 认证信息
    GBPersonalCertificationInfoCell *certificationCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!certificationCell) {
        certificationCell = [[GBPersonalCertificationInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBPersonalCertificationInfoCellID];
    }
    
    certificationCell.certificatIcons = self.certificatIcons;
    [certificationCell.collectionView reloadData];
    
    return certificationCell;
}

- (void)configureServiceCell:(GBPersonalServiceCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        cell.decryptionModel = self.decryptionArray[indexPath.row];
    }else if (indexPath.section == 2) {
        cell.assureModel = self.assuredArray[indexPath.row];
    }
}

- (void)configureCommentListCell:(GBMoreCommentListCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.commentModel = self.comments[indexPath.row];
}


- (void)configureFindColleaguesTableViewCell:(GBFindColleaguesTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.colleaguesModels = self.colleaguesModels;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1:
        case 2:
        {
            GBServiceDetailsViewController *decryptionDetails = [[GBServiceDetailsViewController alloc] init];
            if (indexPath.section == 1) {
                decryptionDetails.serviceDetailsType = ServiceDetailsTypeDecryption;
                decryptionDetails.serviceModel.incumbentDecryptId = self.decryptionArray[indexPath.row].incumbentDecryptId;
            }else if (indexPath.section == 2) {
                decryptionDetails.serviceDetailsType = ServiceDetailsTypeAssured;
                decryptionDetails.serviceModel.incumbentAssurePassId = self.assuredArray[indexPath.row].incumbentAssurePassId;
            }
            
            decryptionDetails.serviceModel.publisherId = [self.targetUsrid integerValue];
            
            [self.navigationController pushViewController:decryptionDetails animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - # Getters and Setters
- (GBFindPeopleModel *)peopleModel {
    if (!_peopleModel) {
        _peopleModel = [[GBFindPeopleModel alloc] init];
    }
    
    return _peopleModel;
}

- (NSArray *)sectionTitleArray {
    if (!_sectionTitleArray) {
        _sectionTitleArray = @[@"口碑与服务",@"解密服务",@"保过服务",@"评价",@"过往经验",@"擅长领域",@"认证信息"];
    }
    
    return _sectionTitleArray;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    }
    
    return _headView;
}

- (GBPersonalHomePageCardHeadView *)headCardView {
    if (!_headCardView) {
        _headCardView = [[GBPersonalHomePageCardHeadView alloc] initWithFrame:CGRectMake(GBMargin,10 , SCREEN_WIDTH-GBMargin*2, 160)];
    }
    
    return _headCardView;
}

- (GBPersonalHomePageStoryHeadView *)storyHeadView {
    if (!_storyHeadView) {
        _storyHeadView = [[GBPersonalHomePageStoryHeadView alloc] initWithFrame:CGRectMake(GBMargin,10 , SCREEN_WIDTH-GBMargin*2, 160)];
    }
    
    return _storyHeadView;
}

- (NSMutableArray *)decryptionArray {
    if (!_decryptionArray) {
        _decryptionArray = [[NSMutableArray alloc] init];
    }
    
    return _decryptionArray;
}

- (NSMutableArray *)assuredArray {
    if (!_assuredArray) {
        _assuredArray = [[NSMutableArray alloc] init];
    }
    
    return _assuredArray;
}

- (NSMutableArray *)pastExperienceArray {
    if (!_pastExperienceArray) {
        _pastExperienceArray = [[NSMutableArray alloc] init];
    }
    
    return _pastExperienceArray;
}

- (NSMutableArray *)certificatIcons {
    if (!_certificatIcons) {
        _certificatIcons = [[NSMutableArray alloc] init];
    }
    
    return _certificatIcons;
}

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [[NSMutableArray alloc] init];
    }
    
    return _tags;
}

- (HXTagCollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [HXTagCollectionViewFlowLayout new];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.itemSize = CGSizeMake(100, 20);
        _layout.minimumInteritemSpacing = 10;
        _layout.minimumLineSpacing = 10;
        _layout.sectionInset = UIEdgeInsetsMake(GBMargin/2, GBMargin, 0, 0);
    }
    
    return _layout;
}

- (HXTagAttribute *)tagAttribute {
    if (!_tagAttribute) {
        _tagAttribute = [[HXTagAttribute alloc] init];
        _tagAttribute.cornerRadius = 2;
        _tagAttribute.tagSpace = GBMargin;
        _tagAttribute.titleSize = 12;
        _tagAttribute.textColor = [UIColor colorWithHexString:@"#28B261"];
        _tagAttribute.normalBackgroundColor = [UIColor colorWithHexString:@"#EDF8EC"];
        _tagAttribute.borderColor = [UIColor clearColor];
    }
    
    return _tagAttribute;
}

- (NSMutableArray *)praises {
    if (!_praises) {
        _praises = [[NSMutableArray alloc] init];
    }
    
    return _praises;
}

- (NSMutableArray *)positonTagModels {
    if (!_positonTagModels) {
        _positonTagModels = [[NSMutableArray alloc] init];
    }
    
    return _positonTagModels;
}

- (NSArray *)menuItemNames {
    //set item
    YCXMenuItem *item1 = nil;
    if ([self.peopleModel.isCollected isEqualToString:@"1"]) {
        item1 = [YCXMenuItem menuItem:@"取消收藏"
                                image:nil
                                  tag:100
                             userInfo:@{@"title":@"Menu"}];
    }else {
        item1 = [YCXMenuItem menuItem:@"收藏"
                                image:nil
                                  tag:100
                             userInfo:@{@"title":@"Menu"}];        }
    item1.foreColor = [UIColor kImportantTitleTextColor];
    
    
    YCXMenuItem *item2 = [YCXMenuItem menuItem:@"分享"
                                         image:nil
                                           tag:101
                                      userInfo:@{@"title":@"Menu"}];
    item2.foreColor = [UIColor kImportantTitleTextColor];
    
    YCXMenuItem *item3 = [YCXMenuItem menuItem:@"举报"
                                         image:nil
                                           tag:102
                                      userInfo:@{@"title":@"Menu"}];
    item3.foreColor = [UIColor kImportantTitleTextColor];
    
    _menuItemNames = @[item1,item2,item3];
    
    return _menuItemNames;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor blackColor];
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
