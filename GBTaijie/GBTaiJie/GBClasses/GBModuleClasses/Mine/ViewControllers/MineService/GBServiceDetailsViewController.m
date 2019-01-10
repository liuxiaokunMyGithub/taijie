//
//  GBServiceDetailsViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/29.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 解密详情
//  @discussion <#类的功能#>
//

#import "GBServiceDetailsViewController.h"
#import "ApplyDecryptViewController.h"
// Controllers
#import "GBCommonPersonalHomePageViewController.h"
#import "GBMoreCommentListCell.h"
#import "GBMoreCommentViewController.h"

// ViewModels

// Models
#import "GBPersonalCommentModel.h"

// Views
#import "GBSettingCell.h"
#import "GBPersonalHeadView.h"
#import "GBPersonalSectionHeadView.h"
#import "GBBigTitleHeadView.h"
#import "GBSubscribeAssuredViewController.h"
#import "HXTagsCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

static NSString *const kGBMoreCommentListCellID = @"GBMoreCommentListCell";

@interface GBServiceDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 发布者用户id */
@property (assign, nonatomic) NSInteger publisherId;
/* <#describe#> */
@property (nonatomic, strong) NSMutableArray *tags;

/* 列表 */
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSString *> *sectionTitleListArray;

/* <#describe#> */
@property (nonatomic, strong) NSArray *textListArray;
@property (nonatomic, strong) NSArray *textContentListArray;

/* 底部按钮 */
@property (nonatomic, strong) UIView *bottomView;

/* 分割线 */
@property (nonatomic, strong) UIView *lineView;

/* 确认按钮 */
@property (nonatomic, strong) UIButton *confirmButton;

/* 价格 */
@property (nonatomic, strong) UILabel *priceLabel;

/* <#describe#> */
@property (nonatomic, strong) GBBigTitleHeadView *bigTitleHeadView;

/* 头部视图 */
@property (nonatomic, strong) GBPersonalHeadView *personalHeadView;


@property (nonatomic,strong) HXTagCollectionViewFlowLayout *layout;//布局layout
@property (nonatomic,strong) HXTagAttribute *tagAttribute;//按钮样式对象
/* 标签视图高 */
@property (nonatomic, assign) CGFloat tagViewheight;
@property (nonatomic,strong) NSMutableArray *coustomNormalTitleColors;// 自定义常规色
@property (nonatomic,strong) NSMutableArray *tempNormalBackgroundColors;// 自定义常规色
/* 评论 */
@property (nonatomic, strong) NSMutableArray <GBPersonalCommentModel *>*comments;

@end

@implementation GBServiceDetailsViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"解密详情";
    self.publisherId = self.serviceModel.publisherId;
    
    self.customNavBar.backgroundColor = [UIColor whiteColor];
    [self headerRereshing];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[[GBSettingCell alloc] class] forCellReuseIdentifier:kGBSettingCellID];
    [self.baseTableView registerClass:[[GBMoreCommentListCell alloc] class] forCellReuseIdentifier:kGBMoreCommentListCellID];
    
    [self.view addSubview:self.baseTableView];
//    self.baseTableView.tableHeaderView = self.bigTitleHeadView;

    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.lineView];
    [self.bottomView addSubview:self.confirmButton];
    [self.bottomView addSubview:self.priceLabel];
    
    [self p_addMasonry];
}

#pragma mark - # Data Methods
- (void)headerRereshing {
    [super headerRereshing];
    if (self.serviceDetailsType == ServiceDetailsTypeDecryption) {
        // 解密
        [self getDecryptData];
        
        // 增加解密浏览量
        GBCommonViewModel *commonVM = [[GBCommonViewModel alloc] init];
        [commonVM loadRequestWatchDecrypt:GBNSStringFormat(@"%zu",self.serviceModel.incumbentDecryptId)];
    }else {
        // 保过
        [self getAssuredData];
        
        // 增加保过浏览量
        GBCommonViewModel *commonVM = [[GBCommonViewModel alloc] init];
        [commonVM loadRequestWatchPosition:GBNSStringFormat(@"%zu",self.serviceModel.incumbentAssurePassId)];
    }
    
}

/** MARK: 保过详情信息 */
- (void)getAssuredData {
    GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
    [positionVM loadPositionsAssurePassDetail:self.serviceModel.incumbentAssurePassId pageNo:1 pageSize:10 targetUserId:self.publisherId];
    [positionVM setSuccessReturnBlock:^(id returnValue) {
        self.serviceModel = [GBPositionServiceModel mj_objectWithKeyValues:returnValue[@"detail"]];
        self.comments = [GBPersonalCommentModel mj_objectArrayWithKeyValuesArray:returnValue[@"comments"][@"list"]];

        self.baseTableView.tableHeaderView = [self setupPersonalHeadView];
        
        NSString *tempPric = [self.serviceModel.discountType isEqualToString:@"FREE"] ? @"限免" : GBNSStringFormat(@"%zu币",self.serviceModel.price);
        NSString *priceStr = GBNSStringFormat(@"%@/保过\n",tempPric);
        NSMutableAttributedString *purchaseCount = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kNormoalInfoTextColor] changeFont:Fit_Font(12) totalString:GBNSStringFormat(@"%zu人已购",self.serviceModel.purchasedCount) changeString:GBNSStringFormat(@"%zu人已购",self.serviceModel.purchasedCount)];
        NSMutableAttributedString *priceAttributedStr = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kPromptRedColor] changeFont:Fit_M_Font(20) totalString:priceStr changeString:tempPric];
        [priceAttributedStr appendAttributedString:purchaseCount];
        self.priceLabel.attributedText = priceAttributedStr;
        
        if (ValidStr(self.serviceModel.labelNames)) {
            self.tags = [NSMutableArray arrayWithArray:[self.serviceModel.labelNames componentsSeparatedByString:@","]];
        }

        self.tagViewheight = [HXTagsView getHeightWithTags:self.tags layout:self.layout tagAttribute:self.tagAttribute width:SCREEN_WIDTH ];
        
        [self.baseTableView reloadData];
    }];
}

/** MARK: 解密详情信息 */
- (void)getDecryptData {
    GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
    [positionVM loadPositionsDecryptDetail:self.serviceModel.incumbentDecryptId pageNo:1 pageSize:10 targetUserId:self.publisherId];
    [positionVM setSuccessReturnBlock:^(id returnValue) {
        self.serviceModel = [GBPositionServiceModel mj_objectWithKeyValues:returnValue[@"detail"]];
        
        self.comments = [GBPersonalCommentModel mj_objectArrayWithKeyValuesArray:returnValue[@"comments"][@"list"]];
        for (NSDictionary *type in self.serviceModel.types) {
            [self.tags addObject:type[@"name"]];
            if ([type[@"isCustomized"] integerValue] == 1) {
                [self.tempNormalBackgroundColors addObject:[UIColor colorWithHexString:@"#EDF8EC"]];
                
                [self.coustomNormalTitleColors addObject:[UIColor colorWithHexString:@"#28B261"]];
                
            }else {
                [self.tempNormalBackgroundColors addObject:[UIColor colorWithHexString:@"#ECECF8"]];
                [self.coustomNormalTitleColors addObject:[UIColor kBaseColor]];
            }
        }
        
        self.tagViewheight = [HXTagsView getHeightWithTags:self.tags layout:self.layout tagAttribute:self.tagAttribute width:SCREEN_WIDTH];
        
        self.baseTableView.tableHeaderView = [self setupPersonalHeadView];
        NSString *tempPric = [self.serviceModel.discountType isEqualToString:@"FREE"] ? @"限免" : GBNSStringFormat(@"%zu币",self.serviceModel.price);
        NSString *priceStr = GBNSStringFormat(@"%@/%@小时\n",tempPric,@"48");
        NSMutableAttributedString *purchaseCount = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kAssistInfoTextColor] changeFont:Fit_Font(12) totalString:GBNSStringFormat(@"%zu人已购",self.serviceModel.purchasedCount) changeString:GBNSStringFormat(@"%zu人已购",self.serviceModel.purchasedCount)];
        NSMutableAttributedString *priceAttributedStr = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kPromptRedColor] changeFont:Fit_M_Font(20) totalString:priceStr changeString:tempPric];
        [priceAttributedStr appendAttributedString:purchaseCount];
        self.priceLabel.attributedText = priceAttributedStr;
        
        [self.baseTableView reloadData];
    }];
}

#pragma mark - # Event Response
- (void)gotoPersonalHomeVC {
    GBCommonPersonalHomePageViewController *homePageVC = [[GBCommonPersonalHomePageViewController alloc] init];
    homePageVC.targetUsrid = GBNSStringFormat(@"%ld",(long)self.publisherId);
    [[GBAppHelper getPushNavigationContr] pushViewController:homePageVC animated:YES];
}

- (void)confirmButtonTouchUpInside:(UIButton *)sender {
    if (!userManager.currentUser) {
        // 未登录不允许浏览
        GBPostNotification(LoginStateChangeNotification, @NO);
        return [UIView showHubWithTip:@"当前操作需要您先注册登录" timeintevel:2.0];
    }else if ([[GBUserDefaults stringForKey:UDK_UserId] isEqualToString:GBNSStringFormat(@"%zu",self.publisherId)]){
        return [UIView showHubWithTip:@"不能预约自己的服务"];
    }
    
    if (self.serviceDetailsType == ServiceDetailsTypeDecryption) {
        // 解密可预约性检测
        GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
        [positionVM loadPositionsDecryptAvailability:self.serviceModel.incumbentDecryptId];
        [positionVM setSuccessReturnBlock:^(id returnValue) {
            ApplyDecryptViewController *applyDecrypt = [[ApplyDecryptViewController alloc] init];
            applyDecrypt.decryptModel = self.serviceModel ;
            [self.navigationController pushViewController:applyDecrypt animated:YES];
        }];
    }else {
        // 保过可预约性检测
        GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
        [positionVM loadPositionsAssurePassAvailability:self.serviceModel.assurePassId];
        [positionVM setSuccessReturnBlock:^(id returnValue) {
            GBSubscribeAssuredViewController *subscribAssuredVC = [[GBSubscribeAssuredViewController alloc] init];
            subscribAssuredVC.serviceModel = self.serviceModel;
            [self.navigationController pushViewController:subscribAssuredVC animated:YES];
        }];
    }
}

#pragma mark - # Privater Methods
- (GBPersonalHeadView *)setupPersonalHeadView {
    if (!_personalHeadView) {
        _personalHeadView = [[GBPersonalHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160) name:self.serviceModel.publisher position:GBNSStringFormat(@"%@",self.serviceModel.publisherManualPositionName) company:GBNSStringFormat(@"%@ · %@",self.serviceModel.publisherRegionName,self.serviceModel.companyName) headImage:self.serviceModel.publisherHeadImg];
        _personalHeadView.isShowBigTitle = YES;
        _personalHeadView.titleLabel.text = self.serviceDetailsType == ServiceDetailsTypeDecryption ? @"私聊解密" : @"入职保过";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPersonalHomeVC)];
        [_personalHeadView addGestureRecognizer:tap];
    }
    
    return _personalHeadView;
}

- (void)p_addMasonry {
    // 底部按钮
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
        make.height.mas_equalTo(72);
    }];
    // 分割线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(0.5);
    }];
    // 确认按钮
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Fit_W_H(160));
        make.right.mas_equalTo(-24);
        make.centerY.mas_equalTo(self.bottomView);
    }];
    
    // 价格按钮
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.centerX.mas_equalTo(self.bottomView);
        make.centerY.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(Fit_W_H(180));
    }];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(SafeAreaTopHeight);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight-72);
    }];
}

#pragma mark - # Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.serviceDetailsType == ServiceDetailsTypeDecryption ? 1 : ValidStr(self.serviceModel.details) ? 2 : 1;
    }
    
    return section == 0 ? self.serviceDetailsType == ServiceDetailsTypeDecryption ? 2 : 4 : section == 4 ?  self.textListArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 1 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }]+ (indexPath.row == 0 ? GBMargin/2 : 0);
        //        return indexPath.row == 0 ? [tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
        //            [self configureCell:cell atIndexPath:indexPath];
        //        }] : (self.serviceDetailsType == ServiceDetailsTypeAssured  && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3)) ? 20 : [tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
        //            [self configureCell:cell atIndexPath:indexPath];
        //        }] + GBMargin;
    }
    
    if (indexPath.section == 1) {
        return indexPath.row == 0 ? self.tagViewheight + (ValidStr(self.serviceModel.details) ? 8 : 0) : [tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
    if (indexPath.section == 2) {
        return self.comments.count > 0 ? [tableView fd_heightForCellWithIdentifier:kGBMoreCommentListCellID cacheByIndexPath:indexPath configuration:^(GBMoreCommentListCell *cell) {
            [self configureCommentListCell:cell atIndexPath:indexPath];
        }] : 0.1;
    }
    
    if (indexPath.section == 3) {
        return 100;
    }
    
    return [tableView fd_heightForCellWithIdentifier:kGBSettingCellID cacheByIndexPath:indexPath configuration:^(GBSettingCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }] +3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = (GBPersonalSectionHeadView *)[tableView headerViewForSection:section];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = [self.sectionTitleListArray objectAtIndex:section];
    headerView.titleLabel.font = section == 0 ? Fit_B_Font(28) : Fit_M_Font(17);
    headerView.moreButton.hidden = YES;
    if (section == 2) {
        BOOL hasComment = self.comments.count ? YES : NO;
        [headerView.moreButton setTitle: hasComment ? @"" : @"暂无评价" forState:UIControlStateNormal];
        headerView.moreButton.hidden = NO;
        headerView.moreButton.userInteractionEnabled = hasComment;
        [headerView.moreButton setTitleColor:hasComment ? [UIColor kBaseColor] : [UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        [headerView.moreButton setImage:hasComment ? GBImageNamed(@"ic_more_right") : nil forState:UIControlStateNormal];
    }
    
    headerView.moreButtonClickBlock = ^(NSInteger section) {
        GBMoreCommentViewController *moreCommentVC = [[GBMoreCommentViewController alloc] init];
        moreCommentVC.targetUsrid = GBNSStringFormat(@"%zu",self.publisherId);
        moreCommentVC.serviceDetailsType = self.serviceDetailsType == ServiceDetailsTypeDecryption ? @"DECRYPT" : @"ASSURE_PASS";
        if (self.serviceDetailsType == ServiceDetailsTypeDecryption) {
            moreCommentVC.decryptionId = GBNSStringFormat(@"%zu",self.serviceModel.incumbentDecryptId) ;
        }else {
            moreCommentVC.assuredId = GBNSStringFormat(@"%zu",self.serviceModel.incumbentAssurePassId);
        }
        [self.navigationController pushViewController:moreCommentVC animated:YES];
    };
    //    if (section == 1) {
    //        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(GBMargin, 0, SCREEN_WIDTH-GBMargin*2, 0.5)];
    //        line.backgroundColor = [UIColor kSegmentateLineColor];
    //        [headerView addSubview:line];
    //    }else {
    //
    //    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
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
        
        if (self.serviceDetailsType == ServiceDetailsTypeDecryption) {
            cell.coustomNormalBackgroundColors = self.tempNormalBackgroundColors;
            cell.coustomNormalTitleColors = self.coustomNormalTitleColors;
        }
        [cell reloadData];
        
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    if (indexPath.section == 2) {
        // MARK: 评价
        GBMoreCommentListCell *commentCell = [tableView cellForRowAtIndexPath:indexPath];
        if (!commentCell) {
            commentCell = [[GBMoreCommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBMoreCommentListCellID];
        }
        
        [self configureCommentListCell:commentCell atIndexPath:indexPath];
        return commentCell;
    }
    
    GBSettingCell *settingCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!settingCell) {
        settingCell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    settingCell.cellType =  indexPath.section == 1 ? CellTypeContentImageView : CellTypeDetailsLabel;
    
    [self configureCell:settingCell atIndexPath:indexPath];
    
    
    return settingCell;
}

- (void)configureCommentListCell:(GBMoreCommentListCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.commentModel = self.comments[indexPath.row];
}

- (void)configureCell:(GBSettingCell *)settingCell atIndexPath:(NSIndexPath *)indexPath {
    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    settingCell.indicateButton.hidden = YES;
    settingCell.line.hidden = YES;
    settingCell.contentTextField.textAlignment = NSTextAlignmentRight;
    settingCell.titleLabel.numberOfLines = 0;
    settingCell.titleLabel.textColor = [UIColor kNormoalInfoTextColor];
    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    settingCell.titleLabel.font = Fit_Font(14);
    if (indexPath.section == 0) {
        if (self.serviceDetailsType == ServiceDetailsTypeDecryption) {
            // 解密第一组
            settingCell.titleLabel.text = indexPath.row == 0 ? self.serviceModel.title : self.serviceModel.detail;
        }else {
            // 保过第一组
            settingCell.titleLabel.text = indexPath.row == 0 ? self.serviceModel.title : indexPath.row == 1 ? self.serviceModel.jobName :  indexPath.row == 2 ? GBNSStringFormat(@"%@ · %@",self.serviceModel.regionName,self.serviceModel.companyName) :  indexPath.row == 3 ? GBNSStringFormat(@"%@ · %@",self.serviceModel.experienceName,self.serviceModel.dilamorName) : self.serviceModel.details;
            
            settingCell.titleLabel.textColor = (indexPath.row == 2 || indexPath.row == 3) ? [UIColor kAssistInfoTextColor] : [UIColor kNormoalInfoTextColor];
            
            if (indexPath.row == 1) {
                settingCell.titleLabel.font = Fit_Font(18);
                settingCell.titleLabel.textColor = [UIColor kBaseColor];
            }
        }
        settingCell.titleLabel.font = indexPath.row == 0 ? Fit_M_Font(20) : Fit_Font(14);
    }
    
    if (indexPath.section == 1) {
        settingCell.cellType =  CellTypeDetailsLabel;
        settingCell.indicateButton.hidden = YES;
        settingCell.line.hidden = YES;
        settingCell.titleLabel.numberOfLines = 0;
        settingCell.titleLabel.textColor = [UIColor kImportantTitleTextColor];
        settingCell.titleLabel.font = Fit_Font(14);
        settingCell.titleLabel.text = self.serviceModel.details;
    }
    
    if (indexPath.section == 3) {
        settingCell.cellType = CellTypeContentImageView;
        settingCell.contentImageView.image = self.serviceDetailsType ==  ServiceDetailsTypeDecryption ? GBImageNamed(@"position_ decryption") : GBImageNamed(@"icon_service_assuredImg");
        settingCell.topMargin = 8;
        settingCell.contentImageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    
    if (indexPath.section == 4) {
        settingCell.cellType = CellTypeIconImageView;
        settingCell.titleLabel.textColor =  (self.serviceDetailsType ==  ServiceDetailsTypeDecryption ? indexPath.row == 3 : indexPath.row == 2) ? [UIColor kBaseColor] : [UIColor kNormoalInfoTextColor];
        settingCell.topMargin = 10;
        settingCell.titleLabel.text = self.textListArray[indexPath.row];
        if (indexPath.row < self.textListArray.count-1) {
            settingCell.contentImageView.backgroundColor = [UIColor kAssistInfoTextColor];
        }
        settingCell.contentImageViewRadius = 2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4 && indexPath.row == self.textListArray.count -1) {
        GBBaseWebViewController *webView = [[GBBaseWebViewController alloc] initWithUrl:GBNSStringFormat(@"%@%@",URL_GB_HTML,HTML_Service_Garantee)];
        webView.titleStr = @"服务保障计划";
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark - # Getters and Setters
- (NSArray *)sectionTitleListArray {
    if (!_sectionTitleListArray) {
        if (self.serviceDetailsType == ServiceDetailsTypeDecryption) {
            _sectionTitleListArray = @[@"",@"解密类型",@"评价",@"服务流程",@"服务保障计划"];
        }else {
            _sectionTitleListArray = @[@"",@"保过内容",@"评价",@"服务流程",@"服务保障计划"];
        }
    }
    
    return _sectionTitleListArray;
}

- (NSArray *)textListArray {
    if (!_textListArray) {
        if (self.serviceDetailsType == ServiceDetailsTypeDecryption) {
        _textListArray = @[@"在同事确认服务前随时可以无条件退款",@"平台托管赏金，确认服务满意，平台才支付给对方",@"聊天记录将自动保存本地，方便随时回看或回听",@"阅读全部《服务保障计划》"];
        }else {
            _textListArray = @[@"你可以免费与服务同事初次沟通，确认已向后再向平台支付托管赏金",@"服务过程中有任何不满意或没有入职，皆可随时无条件全额退款或选择性打赏",@"阅读全部《服务保障计划》"];
        }
    }
    return _textListArray;
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

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.numberOfLines = 2;
        _priceLabel.font = Fit_Font(12);
        _priceLabel.textColor = [UIColor kNormoalInfoTextColor];
    }
    
    return _priceLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton addTarget:self action:@selector(confirmButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setTitle:  self.serviceDetailsType == ServiceDetailsTypeDecryption ? @"立即预约" : @"免费预约" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = Fit_B_Font(17);
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage imageNamed:@"button_bg_long"] forState:UIControlStateNormal];
    }
    return _confirmButton;
}

- (GBBigTitleHeadView *)bigTitleHeadView {
    if (!_bigTitleHeadView) {
        _bigTitleHeadView = [[GBBigTitleHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _bigTitleHeadView.titleLabel.text = self.serviceDetailsType == ServiceDetailsTypeDecryption ? @"私聊解密" : @"入职保过";
    }
    
    return _bigTitleHeadView;
}

- (GBPositionServiceModel *)serviceModel {
    if (!_serviceModel) {
        _serviceModel = [[GBPositionServiceModel alloc] init];
    }
    
    return _serviceModel;
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
        _layout.sectionInset = UIEdgeInsetsMake(8, GBMargin, 0, 0);
    }
    
    return _layout;
}

- (HXTagAttribute *)tagAttribute {
    if (!_tagAttribute) {
        _tagAttribute = [[HXTagAttribute alloc] init];
        _tagAttribute.cornerRadius = 2;
        _tagAttribute.tagSpace = GBMargin;
        _tagAttribute.titleSize = 12;
        _tagAttribute.textColor = [UIColor kBaseColor];

        _tagAttribute.normalBackgroundColor = [UIColor colorWithHexString:@"#ECECF8"];
        _tagAttribute.borderColor = [UIColor clearColor];
    }
    
    return _tagAttribute;
}

- (NSMutableArray *)coustomNormalTitleColors {
    if (!_coustomNormalTitleColors) {
        _coustomNormalTitleColors = [[NSMutableArray alloc] init];
    }
    
    return _coustomNormalTitleColors;
}

- (NSMutableArray *)tempNormalBackgroundColors {
    if (!_tempNormalBackgroundColors) {
        _tempNormalBackgroundColors = [[NSMutableArray alloc] init];
    }
    
    return _tempNormalBackgroundColors;
}

- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [[NSMutableArray alloc] init];
    }
    
    return _comments;
}
// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
