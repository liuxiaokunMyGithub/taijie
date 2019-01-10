//
//  GBModifyViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBModifyViewController.h"

// Controllers


// ViewModels
#import "GBLoginViewModel.h"
// Models


// Views
#import "GBSettingCell.h"
#import "GBBigTitleHeadView.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBModifyViewController ()<UITableViewDelegate,UITableViewDataSource>
/* 布局表视图 */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIButton *saveButton;
@property (nonatomic, weak) UITextField *checkNumField;

@property (nonatomic, strong) GBModifyPhoneTempModel *tempItem;

/* 表头视图 */
@property (nonatomic, strong) UIView *blanceHeadView;
@property (nonatomic, strong) UILabel *headTitleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *sendCheckNumBtn;

@property (nonatomic, assign) NSTimer *timer;

@end

@implementation GBModifyViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"修改手机号";

//    // 设置导航栏颜色
//    [self wr_setNavBarBarTintColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
//    // 设置初始导航栏透明度
//    [self wr_setNavBarBackgroundAlpha:0];
//    // 设置导航栏按钮和标题颜色
//    [self wr_setNavBarTintColor:[UIColor whiteColor]];
   
    //  添加tableView
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 56;
        tableView.sectionFooterHeight = 15;
        tableView.sectionHeaderHeight = 0.00000001;
        [tableView registerClass:[[GBSettingCell alloc] class] forCellReuseIdentifier:kGBSettingCellID];
        [self.view addSubview:tableView];
        
        tableView;
    });
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = self.blanceHeadView;
    self.tableView.tableFooterView = [self customFooterView];
    self.tableView.scrollEnabled = NO;
    
}


#pragma mark - # Setup Methods


#pragma mark - # Event Response
/** MARK:保存 */
- (void)saveButtonClick {
    if (self.modifyType == ModifyControllerTypePhone) {
        // 修改手机号
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestUserTelRenewal:self.tempItem.phone smsCode:self.tempItem.checkNum];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else if (self.modifyType == ModifyControllerTypePayPassWord) {
        if (self.tempItem.passWord.length != 6) {
            return [UIView showHubWithTip:@"请设置6位数字密码"];
        }
        
        if (![self.tempItem.passWord isEqualToString:self.tempItem.validationPassWord]) {
            return [UIView showHubWithTip:@"两次密码输入不一致"];
        }
        
        // 修改支付密码
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestPayPwdRenewal:self.tempItem.passWord smsCode:self.tempItem.checkNum];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else if (self.modifyType == ModifyControllerTypeLoginPassWord) {
        if (![GBAppHelper checkPassword:self.tempItem.passWord]){
            return [UIView showHubWithTip:@"请设置6-20位数字字母组合密码"];
        }
        
        if (![self.tempItem.passWord isEqualToString:self.tempItem.validationPassWord]) {
            return [UIView showHubWithTip:@"两次密码输入不一致"];
        }
        
        // 修改登录密码
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestLoginPasswordRenewal:userManager.currentUser.mobile password:self.tempItem.passWord smsCode:self.tempItem.checkNum];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else if (self.modifyType == ModifyControllerTypeAliPayCount) {
        if (![self.tempItem.aliPayCount isEqualToString:self.tempItem.validationAliPayCount]) {
            return [UIView showHubWithTip:@"两次账户输入不一致"];
        }
        
        // 修改支付宝账户
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestUpdateUserAlipayAccount:self.tempItem.aliPayCount smsCode:self.tempItem.checkNum];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - # Privater Methods
//尾部视图
- (UIView *)customFooterView {
    CGFloat topMargin = 95*0.5;
    CGFloat titleTopMargin = 48*0.5;
    CGFloat titleheight = 60*0.5;
    
    CGFloat btnH = 40;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topMargin+btnH+titleTopMargin+titleheight+60)];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(GBMargin, GBMargin, SCREEN_WIDTH - GBMargin*2, btnH)];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"保 存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = Fit_Font(17);
    [saveButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [saveButton setBackgroundColor:[[UIColor kBaseColor]colorWithAlphaComponent:0.5] ];
    self.saveButton = saveButton;
    [footView addSubview:saveButton];
    
    /** rac 设置是否能够点击*/
    RACSignal *modifyPhoneSignal = [RACSignal combineLatest:@[RACObserve(self, tempItem.phone),RACObserve(self, tempItem.checkNum),] reduce:^id(NSString *phone,NSString *checkNum){
        return @((phone && [GBAppHelper isMobileNumber:phone]) && (checkNum && checkNum.length > 0));}];
    
    // 更改密码
    RACSignal *modifyPwdSignal = [RACSignal combineLatest:@[RACObserve(self, tempItem.passWord),RACObserve(self, tempItem.validationPassWord),RACObserve(self, tempItem.checkNum),] reduce:^id(NSString *passWord,NSString *validationPassWord,NSString *checkNum){
        return @((passWord && passWord.length>0) && (validationPassWord && validationPassWord.length>0) && (checkNum && checkNum.length > 0));}];
    
    // 阿里支付宝账户
    RACSignal *aliPayCountSignal = [RACSignal combineLatest:@[RACObserve(self, tempItem.aliPayCount),RACObserve(self, tempItem.validationAliPayCount),RACObserve(self, tempItem.checkNum),] reduce:^id(NSString *aliPayCount,NSString *validationAliPayCount,NSString *checkNum){
        return @((aliPayCount && aliPayCount.length>0) && (validationAliPayCount && validationAliPayCount.length>0) && (checkNum && checkNum.length > 0));}];
    
    if (self.modifyType == ModifyControllerTypeAliPayCount) {
        RAC(saveButton,userInteractionEnabled) = aliPayCountSignal;
    }else {
        RAC(saveButton,userInteractionEnabled) = self.modifyType == ModifyControllerTypePhone ? modifyPhoneSignal : modifyPwdSignal;
    }
    
    return footView;
}

#pragma mark - # Delegate

// MARK - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modifyType == ModifyControllerTypePhone ? 2 : 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBSettingCell *settingCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!settingCell) {
        settingCell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    settingCell.cellType = CellTypeDetailsTextfield;
    settingCell.titleLabel.hidden = YES;
    settingCell.indicateButton.hidden = YES;
    
    if (indexPath.row == 0) {
        self.checkNumField = settingCell.contentTextField;
    }else {
        if (self.modifyType != ModifyControllerTypePhone) {
            settingCell.showSecureTextButton = YES;
        }
    }
    
    if (self.modifyType == ModifyControllerTypePhone) {
        settingCell.contentTextField.placeholder = indexPath.row == 0 ? @"请输入验证码" : @"请输入新手机号码";
        settingCell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;

        // 修改手机号
        settingCell.textValueChangedBlock = ^(NSString *valueStr) {
            if (indexPath.row == 0) {
                self.tempItem.checkNum = valueStr;
                
            }else {
                self.tempItem.phone = valueStr;
                
            }
            
            if ([GBAppHelper isMobileNumber:self.tempItem.phone] && (self.tempItem.checkNum && ![self.tempItem.checkNum isEqualToString:@""])) {
                [self.saveButton setBackgroundColor:[UIColor kBaseColor]];
            }else {
                [self.saveButton setBackgroundColor:[[UIColor kBaseColor]colorWithAlphaComponent:.5]];
            }
        };
    }else if (self.modifyType == ModifyControllerTypePayPassWord) {
        settingCell.contentTextField.placeholder = indexPath.row == 0 ? @"请输入验证码" : indexPath.row == 1 ? @"请输入6位数字支付密码" : @"请确认您的支付密码";
        
        settingCell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
        // 设置支付密码
        settingCell.textValueChangedBlock = ^(NSString *valueStr) {
            if (indexPath.row == 0) {
                self.tempItem.checkNum = valueStr;
            }
            
            if (indexPath.row == 1) {
                self.tempItem.passWord = valueStr;
            }
            
            if (indexPath.row == 2) {
                self.tempItem.validationPassWord = valueStr;
            }
            
            if ((self.tempItem.checkNum && ![self.tempItem.checkNum isEqualToString:@""]) && (self.tempItem.passWord && ![self.tempItem.passWord isEqualToString:@""]) && (self.tempItem.validationPassWord && ![self.tempItem.validationPassWord isEqualToString:@""])) {
                [self.saveButton setBackgroundColor:[UIColor kBaseColor]];
                
            }else {
                [self.saveButton setBackgroundColor:[[UIColor kBaseColor]colorWithAlphaComponent:.5]];
            }
        };
    }else if (self.modifyType == ModifyControllerTypeLoginPassWord){
        settingCell.contentTextField.placeholder = indexPath.row == 0 ? @"请输入验证码" : indexPath.row == 1 ? @"请输入6-20位数字和字母新密码" : @"请确认新密码";
        
        // 设置支付密码
        settingCell.textValueChangedBlock = ^(NSString *valueStr) {
            if (indexPath.row == 0) {
                self.tempItem.checkNum = valueStr;
            }
            
            if (indexPath.row == 1) {
                self.tempItem.passWord = valueStr;
            }
            
            if (indexPath.row == 2) {
                self.tempItem.validationPassWord = valueStr;
            }
            
            if ((self.tempItem.checkNum && ![self.tempItem.checkNum isEqualToString:@""]) && (self.tempItem.passWord && ![self.tempItem.passWord isEqualToString:@""]) && (self.tempItem.validationPassWord && ![self.tempItem.validationPassWord isEqualToString:@""])) {
                [self.saveButton setBackgroundColor:[UIColor kBaseColor]];
                
            }else {
                [self.saveButton setBackgroundColor:[[UIColor kBaseColor]colorWithAlphaComponent:.5]];
            }
        };
    }else if (self.modifyType == ModifyControllerTypeAliPayCount) {
        settingCell.contentTextField.placeholder = indexPath.row == 0 ? @"请输入验证码" : indexPath.row == 1 ? @"请输入支付宝账户" : @"请确认支付宝账户";
        
        // 设置支付宝账户
        settingCell.textValueChangedBlock = ^(NSString *valueStr) {
            if (indexPath.row == 0) {
                self.tempItem.checkNum = valueStr;
            }
            
            if (indexPath.row == 1) {
                self.tempItem.aliPayCount = valueStr;
            }
            
            if (indexPath.row == 2) {
                self.tempItem.validationAliPayCount = valueStr;
            }
            
            if ((self.tempItem.checkNum && ![self.tempItem.checkNum isEqualToString:@""]) && (self.tempItem.aliPayCount && ![self.tempItem.aliPayCount isEqualToString:@""]) && (self.tempItem.validationAliPayCount && ![self.tempItem.validationAliPayCount isEqualToString:@""])) {
                [self.saveButton setBackgroundColor:[UIColor kBaseColor]];
                
            }else {
                [self.saveButton setBackgroundColor:[[UIColor kBaseColor]colorWithAlphaComponent:.5]];
            }
        };
    }
    
    settingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return settingCell;
}


#pragma mark - # Getters and Setters
- (GBModifyPhoneTempModel *)tempItem{
    if (!_tempItem) {
        _tempItem = [GBModifyPhoneTempModel new];
    }
    return _tempItem;
}

//头部视图
- (UIView *)blanceHeadView {
    if (!_blanceHeadView) {
        _blanceHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        [_blanceHeadView addSubview:self.headTitleLabel];
        [_blanceHeadView addSubview:self.subTitleLabel];
        [_blanceHeadView addSubview:self.phoneLabel];
        [_blanceHeadView addSubview:self.sendCheckNumBtn];
        CGSize size = [@"    获取验证码    " sizeWithAttributes:@{NSFontAttributeName:Fit_Font(14)}];
        [_sendCheckNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(SCREEN_WIDTH).offset(-GBMargin);
            make.top.mas_equalTo(120 -30 -GBMargin/2);
            make.height.equalTo(@30);
            make.width.equalTo(@(size.width));
        }];
    }
    
    return _blanceHeadView;
}

- (UILabel *)headTitleLabel {
    if (!_headTitleLabel) {
        CGRect frame = CGRectMake(GBMargin, GBMargin/2, SCREEN_WIDTH-GBMargin*2, 30);
        NSString *title = @"";
        switch (self.modifyType) {
            case ModifyControllerTypePhone:
            {
                title = @"修改手机号";
            }
                break;
            case ModifyControllerTypeLoginPassWord:
            {
                title = @"修改登录密码";

            }
                break;
            case ModifyControllerTypePayPassWord:
            {
                title = @"设置支付密码";

            }
                break;
            case ModifyControllerTypeAliPayCount:
            {
                title = @"设置支付宝账户";

            }
                break;
            default:
                break;
        }
        
        _headTitleLabel = [UILabel createLabelWithFrame:frame
                                                   text:title
                                                   font:Fit_M_Font(20)
                                              textColor:[UIColor kImportantTitleTextColor]
                                          textAlignment:NSTextAlignmentLeft];
    }
    
    return _headTitleLabel;
}



- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        CGRect frame = CGRectMake(GBMargin, 120 -30 -GBMargin/2-20,80, 20);
        
        _subTitleLabel = [UILabel createLabelWithFrame:frame
                                                  text:@"当前手机号"
                                                  font:Fit_Font(14)
                                             textColor:[UIColor kAssistInfoTextColor]
                                         textAlignment:NSTextAlignmentLeft];
        
    }
    
    return _subTitleLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        CGRect frame = CGRectMake(GBMargin, 120 -30 -GBMargin/2,180, 30);
        
        _phoneLabel = [UILabel createLabelWithFrame:frame
                                                  text:[DCSpeedy dc_EncryptionDisplayMessageWith:userManager.currentUser.mobile WithFirstIndex:4 surplus:4]
                                                  font:Fit_Font(14)
                                             textColor:[UIColor kImportantTitleTextColor]
                                         textAlignment:NSTextAlignmentLeft];
        
    }
    
    return _phoneLabel;
}

- (UIButton *)sendCheckNumBtn {
    if (!_sendCheckNumBtn) {
        _sendCheckNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_sendCheckNumBtn setTitle:@"    获取验证码    " forState: UIControlStateNormal];
        [_sendCheckNumBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
        
        [_sendCheckNumBtn.titleLabel setFont:Fit_Font(14)];
        [_sendCheckNumBtn addTarget:self action:@selector(sendCheckNumBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_sendCheckNumBtn setBackgroundColor:[UIColor kFunctionBackgroundColor]];
    }
    
    return _sendCheckNumBtn;
}

- (void)sendCheckNumBtnClicked:(UIButton *)btn {
    NSString *type = @"";
    switch (self.modifyType) {
        case ModifyControllerTypePhone:
        {
            type = @"modifyMobile";
        }
            break;
        case ModifyControllerTypeLoginPassWord:
        {
            type = @"modifyPassWord";
            
        }
            break;
        case ModifyControllerTypePayPassWord:
        {
            type = @"modifyPayPwd";
            
        }
            break;
        case ModifyControllerTypeAliPayCount:
        {
            type = @"modifyAlipayAccount";
            
        }
            break;
        default:
            break;
    }
    
     GBLoginViewModel *loginVM = [[GBLoginViewModel alloc] init];
    [loginVM loadRequestCheckCode:userManager.currentUser.mobile type:type];
    [loginVM  setSuccessReturnBlock:^(id returnValue) {
        // 倒计时
        [self updateSendCodeButton];
        // 验证码输入框获取焦点
        [self.checkNumField becomeFirstResponder];
    }];
    // 验证码输入框获取焦点
    [self.checkNumField becomeFirstResponder];
}

- (void)updateSendCodeButton {
    __weak typeof(self) weakSelf = self;
    //    _isSendCheckBtnCanClick = NO;
    self.sendCheckNumBtn.userInteractionEnabled = NO;
    if (kiOS10Later) {
        __block int count = 60;
        CGSize size = [[NSString stringWithFormat:@"      %@ds      ", @"60"] sizeWithAttributes:@{NSFontAttributeName:Fit_Font(14)}];
        [weakSelf.sendCheckNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
        }];
        
        NSString *timeStr = [NSString stringWithFormat:@"      %02ds      ", count];
        [weakSelf.sendCheckNumBtn setTitle:timeStr forState:UIControlStateNormal];
        count--;
        
        
        //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (@available(iOS 10.0, *)) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                //            [weakSelf.sendCheckNumBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
                if (count!=0) {
                    NSString *timeStr = [NSString stringWithFormat:@"      %02ds      ", count];
                    [weakSelf.sendCheckNumBtn setTitle:timeStr forState:UIControlStateNormal];
                }
                else {
                    [self.timer invalidate];
                    weakSelf.timer = nil;
                    //                    if (_delegate && [_delegate respondsToSelector:@selector(LCHomeCheckNumCellCheckBtnInvalid)]) {
                    //                        [_delegate LCHomeCheckNumCellCheckBtnInvalid];
                    //                    }
                    
                    // 按钮复原
                    self.sendCheckNumBtn.userInteractionEnabled = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        NSString *timeStr = [NSString stringWithFormat:@"    获取验证码    "];
                        [self.sendCheckNumBtn setTitle:timeStr  forState:UIControlStateNormal];
                        CGSize size = [timeStr sizeWithAttributes:@{NSFontAttributeName:Fit_Font(14)}];
                        
                        [UIView animateWithDuration:2.0 animations:^{
                            [self.sendCheckNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                                make.width.equalTo(@(size.width));
                            }];
                        }];
                        
                    });
                }
                count--;
            }];
        } else {
            // Fallback on earlier versions
        }
    }else {
        __block int timeout=60; //倒计时时间
        CGSize size = [[NSString stringWithFormat:@"      %@ds      ", @"60"] sizeWithAttributes:@{NSFontAttributeName:Fit_Font(14)}];
        [weakSelf.sendCheckNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
        }];
        
        NSString *timeStr = [NSString stringWithFormat:@"      %02ds      ", timeout];
        [weakSelf.sendCheckNumBtn setTitle:timeStr forState:UIControlStateNormal];
        
        timeout--;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 按钮复原
                    weakSelf.sendCheckNumBtn.userInteractionEnabled = YES;
                    
                    //设置界面的按钮显示 根据自己需求设置
                    NSString *timeStr = [NSString stringWithFormat:@"    获取验证码    "];
                    [weakSelf.sendCheckNumBtn setTitle:timeStr  forState:UIControlStateNormal];
                    [weakSelf.sendCheckNumBtn.layer setBorderColor:[UIColor kBaseColor].CGColor];
                    CGSize size = [timeStr sizeWithAttributes:@{NSFontAttributeName:Fit_Font(14)}];
                    [UIView animateWithDuration:2.0 animations:^{
                        [self.sendCheckNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(@(size.width));
                        }];
                    }];
                });
            }else{
                int seconds = timeout;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    NSString *timeStr = [NSString stringWithFormat:@"      %2@s      ", strTime];
                    [self.sendCheckNumBtn setTitle:timeStr forState:UIControlStateNormal];
                    [UIView commitAnimations];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
    
    //    });
}


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end


@implementation GBModifyPhoneTempModel

@end
