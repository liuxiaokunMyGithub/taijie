//
//  GBTiebaDetailsViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/9.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBTiebaDetailsViewController.h"

// Controllers
#import "GBReportViewController.h"


// ViewModels


// Models
#import "GBTiebaDetailsCommentModel.h"

// Views
#import "GBBigTitleHeadView.h"
#import "GBPersonalSectionHeadView.h"
#import "GBTiebaOnePicTableViewCell.h"
#import "GBTiebaDetailsCommentCell.h"
// 评论输入框
#import "CommentPad.h"
#import "XKTextField.h"

static NSString *const kGBTiebaOnePicTableViewCellID = @"GBTiebaOnePicTableViewCell";
static NSString *const kGBTiebaDetailsCommentCellID = @"GBTiebaDetailsCommentCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

@interface GBTiebaDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CommentPadDelegate>
/* 评论 */
@property (nonatomic, strong) NSMutableArray <GBTiebaDetailsCommentModel *> *commentModels;
/* 标题 */
@property (nonatomic, strong) GBBigTitleHeadView *bigTitleHeadView;
/**
 评论输入视图，包含一个输入框和发布按钮
 */
@property (nonatomic, strong) CommentPad *commentPad;
/* 评论按钮
 点击之后跳转到commentPad评论输入视图
 */
@property (nonatomic, strong) UIButton *commentButton;
/* 底部评论视图 */
@property (nonatomic, strong) UIView *bottomToolView;

/* 提示框 */
@property (nonatomic, strong)  SCLAlertView *alert;
/* 昵称输入框 */
@property (nonatomic, strong) XKTextField *nickTextField;
/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* 输入框右侧限制数 */
@property (nonatomic, strong) UILabel *rightNubLabel;

/* 昵称 */
@property (nonatomic, strong) UIButton *nickButton;
// 下拉菜单数据
@property (nonatomic,strong) NSArray *menuItemNames;
/* 半透明遮罩视图 */
@property (nonatomic, strong) UIView *maskView;

/* <#describe#> */
@property (nonatomic, copy) UIImage *gossipHeadImg;

@end

@implementation GBTiebaDetailsViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver: self.commentPad];
    [[NSNotificationCenter defaultCenter] removeObserver: self.commentPad name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self.commentPad name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self.commentPad name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self.commentPad name:UIKeyboardDidHideNotification object:nil];
    
    [GBNotificationCenter removeObserver:self.commentPad];
    
    [GBNotificationCenter removeObserver:self name:YCXMenuWillDisappearNotification object:nil];

    self.commentPad.delegate = nil;
    [self.commentPad removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 输入框距离键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NetDataServerInstance.forbidShowLoading = YES;
    // 评论
    [self getTiebaDetailsCommentData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"吾聊详情";
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [self.baseTableView registerClass:[GBPersonalSectionHeadView class] forHeaderFooterViewReuseIdentifier:kGBPersonalSectionHeadViewID];
    [self.baseTableView registerClass:[GBTiebaOnePicTableViewCell class] forCellReuseIdentifier:kGBTiebaOnePicTableViewCellID];
    [self.baseTableView registerClass:[GBTiebaDetailsCommentCell class] forCellReuseIdentifier:kGBTiebaDetailsCommentCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = self.bigTitleHeadView;
    self.baseTableView.height = SCREEN_HEIGHT - SafeAreaTopHeight - BottomViewFitHeight(56);

    if (userManager.currentUser) {
        // 获取昵称
        [self getNickName];
    }
    
    [self setupCustomBottomViewView];

    if ([self.tiebaModel.publisherId isEqualToString:[GBUserDefaults stringForKey:UDK_UserId]]) {
        // 删除
        [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_delete_top")];
        @GBWeakObj(self);
        [self.customNavBar setOnClickRightButton:^{
            @GBStrongObj(self);
            GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
            [tiebaVM  loadRequestCloseTieba:self.tiebaModel.gossipId];
            [tiebaVM setSuccessReturnBlock:^(id returnValue) {
                [GBNotificationCenter postNotificationName:TiebaDataRefreshNotification object:nil];
                [UIView showHubWithTip:@"删除成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
    }else {
        // 举报
        [self.customNavBar wr_setRightButtonWithImage:GBImageNamed(@"icon_whistle-blowing_black_top")];
        @GBWeakObj(self);
        [self.customNavBar setOnClickRightButton:^{
            @GBStrongObj(self);
            GBReportViewController *reportVC = [[GBReportViewController alloc] init];
            reportVC.relatedType = @"REPORT_GOSSIP";
            reportVC.relatedId = self.tiebaModel.gossipId;
            [self.navigationController pushViewController:reportVC animated:YES];
        }];
    }
}

#pragma mark - # Data
- (void)headerRereshing {
    [super headerRereshing];
    [self getTiebaDetailsCommentData];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getTiebaDetailsCommentData];
}

// MARK: 评论数据
- (void)getTiebaDetailsCommentData {
    GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
    [tiebaVM loadRequestTiebaCommentList:page pageSize:10 gossipId:self.tiebaModel.gossipId];
    [tiebaVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBTiebaDetailsCommentModel mj_objectArrayWithKeyValuesArray:returnValue[@"list"]];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.commentModels = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.commentModels addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
    }];
}

- (void)getNickName {
    NSLog(@"page %ld",(long)page);
     GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
    [tiebaVM loadRequestTiebaUserNick];
    [tiebaVM setSuccessReturnBlock:^(id returnValue) {
        if (ValidStr(returnValue[@"gossipNickName"])) {
            [self.nickButton setTitle:returnValue[@"gossipNickName"] forState:UIControlStateNormal];
        }
        
        if (ValidStr(returnValue[@"gossipHeadImg"])) {
            self.gossipHeadImg = [UIImage getImageURL:GBImageURL(returnValue[@"gossipHeadImg"])];
        }
    }];
}

#pragma mark - # UI
//创建TabBarView
- (void)setupCustomBottomViewView {
    _bottomToolView = [[UIView alloc] init];
    self.bottomToolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomToolView];
    
    UIButton *nickBtn = [[UIButton alloc] init];
    [nickBtn setTitle:@"匿名用户" forState:UIControlStateNormal];
    [nickBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    nickBtn.titleLabel.font = Fit_M_Font(12);
    nickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [nickBtn addTarget:self action:@selector(nickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolView addSubview:nickBtn];
    self.nickButton = nickBtn;
    
    //点击评论按钮
    UIButton *commentButton = [[UIButton alloc] init];
    [commentButton setTitle:@"随便扒点什么..." forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentButton:) forControlEvents:UIControlEventTouchUpInside];
    commentButton.titleLabel.font = Fit_Font(12);
    [self.bottomToolView addSubview:commentButton];
    self.commentButton = commentButton;
    GBViewBorderRadius(commentButton, 2, 0.5, [UIColor kSegmentateLineColor]);
    
    UIButton *sendBtn = [[UIButton alloc] init];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = Fit_M_Font(12);
    [sendBtn addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolView addSubview:sendBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor kSegmentateLineColor];
    [self.bottomToolView addSubview:lineView];
    
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(BottomViewFitHeight(56));
    }];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-GBMargin);
        make.centerY.equalTo(self.bottomToolView).offset(-(SafeAreaBottomHeight/2));
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
    }];
    
    [nickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.centerY.equalTo(self.bottomToolView).offset(-(SafeAreaBottomHeight/2));
        make.width.mas_equalTo(60);
        make.height.greaterThanOrEqualTo(@44);
    }];
    
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickBtn.mas_right).offset(8);
        make.right.equalTo(sendBtn.mas_left).offset(-12);
        make.centerY.equalTo(self.bottomToolView).offset(-(SafeAreaBottomHeight/2));
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - # Event Response
// MARK: 评论输入
- (void)commentButton:(UIButton *)commentButton {
    if (!userManager.currentUser) {
        GBPostNotification(LoginStateChangeNotification, @NO);
        return [UIView showHubWithTip:@"当前操作需要您先注册登录" timeintevel:2.0];
    }
    
    [self.commentPad showWithTag:222];
}

// MARK: 发布
- (void)sendButtonAction {
    if (!userManager.currentUser) {
        GBPostNotification(LoginStateChangeNotification, @NO);
        return [UIView showHubWithTip:@"当前操作需要您先注册登录" timeintevel:2.0];
    }
    
    [self updateCommentRequest];
}

/** MARK:修改昵称 */
- (void)nickBtnClick:(UIButton *)nickButton {
    if (!userManager.currentUser) {
        GBPostNotification(LoginStateChangeNotification, @NO);
        return [UIView showHubWithTip:@"当前操作需要您先注册登录" timeintevel:2.0];
    }
    
    _alert = [[SCLAlertView alloc] init];
    [_alert setHorizontalButtons:YES];
    XKTextField *textField = [[XKTextField alloc] initWithFrame:CGRectMake(0, 0, 215, 30)];
    textField.margin = 5;
    textField.placeholder = @"输入您的昵称";
    [textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.font = Fit_Font(14);
    textField.delegate = self;
    self.nickTextField = textField;
    GBViewBorderRadius(textField, 1, 1, [UIColor kSegmentateLineColor]);
    [_alert addCustomView:textField];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.text = @"0/5";
    rightLabel.textColor = [UIColor kAssistInfoTextColor];
    rightLabel.font = Fit_Font(12);
    textField.rightView = rightLabel;
    self.rightNubLabel = rightLabel;
    
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *cancelButton = [_alert addButton:@"取消" actionBlock:nil];
    [cancelButton setBackgroundImage:GBImageNamed(@"button_bg_short") forState:UIControlStateNormal];
    
    @GBWeakObj(self);
    UIButton *sureButton = [_alert addButton:@"确定" validationBlock:^BOOL {
        NSLog(@"确定: %@", textField.text);
        if (textField.text.length <= 0) {
            [UIView showHubWithTip:@"请输入昵称"];
            return NO;
        }
        return YES;
    }actionBlock:^{
        @GBStrongObj(self);
        GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
        [tiebaVM loadRequestUpdateTiebaUserNick:textField.text];
        [tiebaVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"更新成功"];
            [self.nickButton setTitle:textField.text forState:UIControlStateNormal];
        }];
    }];
    [sureButton setBackgroundImage:GBImageNamed(@"button_bg_short") forState:UIControlStateNormal];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 215, 16)];
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.text = @"如昵称违规,我们将删除您的发帖和评论";
    subLabel.textColor = [UIColor kAssistInfoTextColor];
    subLabel.font = Fit_Font(10);
    [_alert addCustomView:subLabel];
    _alert.circleIconHeight = 25;
    [_alert showCustom:self image:self.gossipHeadImg ? self.gossipHeadImg : GBImageNamed(@"icon_anonymousHead") color:[UIColor whiteColor] title:@"输入一个有趣的名字吧" subTitle:nil closeButtonTitle:nil duration:0.0f];
    
    [textField becomeFirstResponder];
}

#pragma mark - Privater Methods
- (void)updateCommentRequest {
    // 评论上传
    if (self.commentPad.textView.text.length > 0) {
        GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
        [tiebaVM loadRequestPublishTiebaComment:self.commentPad.textView.text gossipId:self.tiebaModel.gossipId];
        NSMutableArray *temp = [NSMutableArray new];
        
        @GBWeakObj(self);
        [tiebaVM setSuccessReturnBlock:^(id returnValue) {
        @GBStrongObj(self);
            GBTiebaDetailsCommentModel *commnetModel = [GBTiebaDetailsCommentModel mj_objectWithKeyValues:returnValue];
//            commnetModel.content = self.commentPad.textView.text;
//            commnetModel.createTime = [GBAppHelper getCurrentDate];
//            commnetModel.commentUserNickName = self.nickButton.titleLabel.text;
            [temp addObject:commnetModel];
            [temp addObjectsFromArray:self.commentModels];
            
            self.commentModels = [NSMutableArray arrayWithArray:temp];
            [self.baseTableView reloadData];
            
            [UIView showHubWithTip:@"发布成功" timeintevel:1.5];
            [self.commentPad exitPad:nil];
        }];
    }else {
        [UIView showHubWithTip:@"请输入评论"];
    }
}

#pragma mark - # Delegate

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
                GBReportViewController *reportVC = [[GBReportViewController alloc] init];
                reportVC.relatedType = @"REPORT_GOSSIP";
                reportVC.relatedId = self.tiebaModel.gossipId;
                [self.navigationController pushViewController:reportVC animated:YES];
            }
                break;
            case 1:
            {
                GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
                [tiebaVM  loadRequestCloseTieba:self.tiebaModel.gossipId];
                [tiebaVM setSuccessReturnBlock:^(id returnValue) {
                    [GBNotificationCenter postNotificationName:TiebaDataRefreshNotification object:nil];
                    [UIView showHubWithTip:@"删除成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
                break;
            default:
                break;
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  section == 0 ? 1 : self.commentModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 帖子详情
        return [tableView fd_heightForCellWithIdentifier:kGBTiebaOnePicTableViewCellID cacheByIndexPath:indexPath configuration:^(GBTiebaOnePicTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
    
    // 帖子评论
    return [tableView fd_heightForCellWithIdentifier:kGBTiebaDetailsCommentCellID cacheByIndexPath:indexPath configuration:^(GBTiebaDetailsCommentCell *cell) {
        [self configureCommentCell:cell atIndexPath:indexPath];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = (section == 0 ? @"" : section == 1 ? @"评价" : @"认证信息");
    headerView.moreButton.hidden = YES;
    
    if (section == 0) {
        headerView.titleLabel.text = GBNSStringFormat(@"发布者：%@",self.tiebaModel.gossipNickName);
        headerView.titleLabel.textColor = [UIColor kAssistInfoTextColor];
        headerView.titleLabel.font = Fit_Font(14);
    }else {
        headerView.titleLabel.text = @"评论";
        headerView.titleLabel.textColor = [UIColor kImportantTitleTextColor];
        headerView.titleLabel.font = Fit_M_Font(17);
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GBTiebaOnePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGBTiebaOnePicTableViewCellID];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
   
    GBTiebaDetailsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kGBTiebaDetailsCommentCellID];
    [self configureCommentCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)configureCell:(GBTiebaOnePicTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tiebaModel = self.tiebaModel;
    // 分割线
    [cell.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell);
        make.width.mas_equalTo(cell);
    }];
}

- (void)configureCommentCell:(GBTiebaDetailsCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tiebaCommentModel = self.commentModels[indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (indexPath.section == 1 && !self.commentModels[indexPath.row].reported) ? YES : NO;
}

//添加两个按钮（编辑按钮和删除按钮）
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if ([self.commentModels[indexPath.row].commentUserId isEqualToString:[GBUserDefaults stringForKey:UDK_UserId]])  {
    UITableViewRowAction *deleteRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        [self AlertWithTitle:@"提示" message:@"删除此评论?" andOthers:@[@"取消",@"删除"] animated:YES action:^(NSInteger index) {
            if (index == 1) {
                GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
                [tiebaVM loadRequestCommentClose:self.commentModels[indexPath.row].gossipId gossipCommentId:self.commentModels[indexPath.row].gossipCommentId];
                [tiebaVM setSuccessReturnBlock:^(id returnValue) {
                    [UIView showHubWithTip:@"删除成功"];
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.commentModels];
                    [temp removeObjectAtIndex:indexPath.row];
                    self.commentModels = [NSMutableArray arrayWithArray:temp];
                    [self.baseTableView reloadData];
                }];
            }
        }];
    }];
       return  @[deleteRow];
   }
   
    UITableViewRowAction *reportRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"举报" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self AlertWithTitle:@"提示" message:@"举报此评论?" andOthers:@[@"取消",@"举报"] animated:YES action:^(NSInteger index) {
            if (index == 1) {
                GBReportViewController *reportVC = [[GBReportViewController alloc] init];
                reportVC.relatedType = @"REPORT_GOSSIP_COMMENT";
                reportVC.relatedId =  self.commentModels[indexPath.row].gossipCommentId;
                [self.navigationController pushViewController:reportVC animated:YES];
            }
        }];
    }];
    
    reportRow.backgroundColor = [UIColor kBaseColor];
    
    return  @[reportRow];
    
}

#pragma mark - ------ textFieldDelegate ------
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.nickTextField.isFirstResponder) {
        IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
        // 输入框距离键盘的距离
        keyboardManager.keyboardDistanceFromTextField = 120.0f;
    }
}

- (void)textValueChanged:(UITextField *)textField {
    self.rightNubLabel.text = GBNSStringFormat(@"%zu/5",textField.text.length);
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_alert) {
        _alert.view.center = self.view.center;
    }
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 输入框距离键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}

#pragma mark - ------ CommentPadDelegate ------
- (void)commentPadHide:(CommentPad *)commentPad {
    if (commentPad.textView.text.length > 0) {
        [self.commentButton setTitle:commentPad.textView.text forState:UIControlStateNormal];
    }else {
        [self.commentButton setTitle:@"随便扒点什么..." forState:UIControlStateNormal];
    }
}

// 发布
- (void)commentPadSubmit:(CommentPad *)commentPad {
    [self updateCommentRequest];
}

#pragma mark - # Getters and Setters
- (NSMutableArray *)commentModels {
    if (!_commentModels) {
        _commentModels = [[NSMutableArray alloc] init];
    }
    
    return _commentModels;
}

- (GBBigTitleHeadView *)bigTitleHeadView {
    if (!_bigTitleHeadView) {
        _bigTitleHeadView = [[GBBigTitleHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _bigTitleHeadView.titleLabel.text = @"详情";
        _bigTitleHeadView.bottomSubTitleLabel.text = GBNSStringFormat(@"发布者：%@",self.tiebaModel.gossipNickName);
    }
    
    return _bigTitleHeadView;
}


- (CommentPad *)commentPad {
    if (!_commentPad) {
        _commentPad = [[CommentPad alloc] init];
        _commentPad.delegate = self;
    }
    
    return _commentPad;
}

- (NSArray *)menuItemNames {
    if (!_menuItemNames) {
        //set item
        YCXMenuItem *item1 = [YCXMenuItem menuItem:@"举报"
                                             image:nil
                                               tag:100
                                          userInfo:@{@"title":@"Menu"}];
        item1.foreColor = [UIColor kImportantTitleTextColor];
        
        YCXMenuItem *item2 = [YCXMenuItem menuItem:@"删除"
                                             image:nil
                                               tag:101
                                          userInfo:@{@"title":@"Menu"}];
        item2.foreColor = [UIColor kImportantTitleTextColor];
        
        if ([self.tiebaModel.publisherId isEqualToString:[GBUserDefaults stringForKey:UDK_UserId]]) {
            _menuItemNames = @[item1,item2];
        }else {
            _menuItemNames = @[item1];
        }
    }
    
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
