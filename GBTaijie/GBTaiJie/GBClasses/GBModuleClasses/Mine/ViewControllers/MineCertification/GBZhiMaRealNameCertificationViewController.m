//
//  GBZhiMaRealNameCertificationViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 芝麻信用实名认证
//  @discussion <#类的功能#>
//

#import "GBZhiMaRealNameCertificationViewController.h"

// Controllers
#import "GBUploadCertificationInformationViewController.h"
#import "GBCertificationSuccessViewController.h"
#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机
#import <ZMCert/ZMCert.h>
#endif

// ViewModels


// Models


// Views


@interface GBZhiMaRealNameCertificationViewController ()
@property (nonatomic, strong) UIScrollView *scrollV;
@property (nonatomic, strong) UIButton *backB;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *cardTextField;
@property (nonatomic, copy) NSString *authCode;

@end

@implementation GBZhiMaRealNameCertificationViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"芝麻认证";

    [self setupSubViews];
}


#pragma mark - # Setup Methods


#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate


#pragma mark - # Getters and Setters
- (void)setupSubViews {
    _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollV];

    // centerLabel
    UIImageView *centerIV = [[UIImageView alloc] initWithFrame:CGRectMake(GBMargin, 0, SCREEN_WIDTH - GBMargin *2, SCREEN_HEIGHT / 3 )];
    centerIV.image = [UIImage imageNamed:@"img_Authentication"];
    [_scrollV addSubview:centerIV];
    centerIV.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(30, centerIV.mj_h + centerIV.mj_y + 30, SCREEN_WIDTH - 60, 50)];
    backView1.backgroundColor = UIColorFromRGB(0XE4ECF4);
    backView1.clipsToBounds = YES;
    backView1.layer.cornerRadius = 5;
    [_scrollV addSubview:backView1];
    
    UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    nameTitle.text = @"真实姓名";
    nameTitle.textColor = [UIColor kImportantTitleTextColor];
    nameTitle.font = Fit_Font(14);
    nameTitle.textAlignment = NSTextAlignmentLeft;
    [backView1 addSubview:nameTitle];
    
    self.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(nameTitle.mj_x+nameTitle.mj_w, 0, backView1.mj_w - nameTitle.mj_x  - nameTitle.mj_w - 15, 50)];
    self.nameTextField.placeholder = @"请填写身份证上的姓名";
    self.nameTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.nameTextField.textAlignment = NSTextAlignmentRight;
    [backView1 addSubview:self.nameTextField];
    
    UIView *backView2 = [[UIView alloc]initWithFrame:CGRectMake(30, backView1.mj_h + backView1.mj_y + 15, SCREEN_WIDTH - 60, 50)];
    backView2.backgroundColor = UIColorFromRGB(0XE4ECF4);
    backView2.clipsToBounds = YES;
    backView2.layer.cornerRadius = 5;
    [_scrollV addSubview:backView2];
    
    UILabel *cardTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    cardTitle.text = @"身份证号";
    cardTitle.textColor = [UIColor kImportantTitleTextColor];
    cardTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    cardTitle.textAlignment = NSTextAlignmentLeft;
    [backView2 addSubview:cardTitle];
    
    self.cardTextField = [[UITextField alloc]initWithFrame:CGRectMake(nameTitle.mj_x+nameTitle.mj_w, 0, backView2.mj_w - nameTitle.mj_x  - nameTitle.mj_w - 15, 50)];
    self.cardTextField.placeholder = @"请填写正确的身份证号";
    self.cardTextField.font = Fit_Font(14);
    self.cardTextField.textAlignment = NSTextAlignmentRight;
    [backView2 addSubview:self.cardTextField];
    
    UILabel *desTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, backView2.mj_h + backView2.mj_y + 15, SCREEN_WIDTH - 30, 15)];
    desTitle.text = @"*请您如实填写本人信息，否则驳回认证";
    desTitle.textColor = [UIColor kAssistInfoTextColor];
    desTitle.font = Fit_Font(12);
    desTitle.textAlignment = NSTextAlignmentCenter;
    [_scrollV addSubview:desTitle];
    
    // 提交按钮
    [self.view addSubview:[self setupBottomViewWithtitle:@"提交"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
    @GBStrongObj(self);
        [self jumpBtnClick];
    };
    
    
    _scrollV.contentSize = CGSizeMake(0, desTitle.mj_y +desTitle.mj_h + 60);
    _scrollV.showsVerticalScrollIndicator = NO;
}

- (void)backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK: 提交身份认证
- (void)jumpBtnClick {
    if (self.nameTextField.text.length == 0) {
        [UIView showHubWithTip:@"请输入姓名"];
        return;
    }else if (self.cardTextField.text.length == 0) {
        [UIView showHubWithTip:@"请输入您的身份证号"];
        return;
    }
    
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineInitAntAuthenticate:self.nameTextField.text certNo:self.cardTextField.text];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
#if TARGET_IPHONE_SIMULATOR//模拟器
        
#elif TARGET_OS_IPHONE//真机
        ZMCertification *manager = [[ZMCertification alloc] init];
        
        //  不进行动作检测视频录制
        [manager startWithBizNO:returnValue[@"bizNo"]
                     merchantID:returnValue[@"pid"]
                      extParams:nil
                 viewController:self
                       onFinish:^(BOOL isCanceled, BOOL isPassed, ZMStatusErrorType errorCode) {
                           if (isCanceled) {
                               
                               [UIView showHubWithTip:@"用户取消了认证"];
                               
                               
                           }else{
                               if (isPassed) {
                                   NSLog(@"认证成功");
                                   GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
                                   [mineVM loadRequestMineIncumbentAuthenticationInfoSubmition:self.params];
                                   [mineVM setSuccessReturnBlock:^(id returnValue) {
                                       [self postAuditionSubmition:returnValue];
                                   }];
                                   
                               }else{
                                   [UIView showHubWithTip:@"认证失败"];
                                   
                               }
                           }
                       }];
#endif
        
    }];
}

- (void)postAuditionSubmition:(NSString *)authenticationId {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineAuditionSubmition:authenticationId];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        GBCertificationSuccessViewController *certificationSuccessVC = [[GBCertificationSuccessViewController alloc] init];
        [self.navigationController pushViewController:certificationSuccessVC animated:YES];
    }];
}

- (void)getZMScore {
//    WS(weakSelf)
//    [self showProgressWithView:self.view animated:YES];
//    [SendRequest getZmScoreByToken:self.authCode result:^(NSDictionary *result, NSError *error) {
//        [weakSelf hideProgress:self.view animated:YES];
//        result = [CommonUtils decryptDicWithResult:result];
//        if([result[@"result"] integerValue] == 1) {
//            NSLog(@"获取芝麻分成功 = %@", [result objectForKey:@"data"]);
//            [[NSUserDefaults standardUserDefaults] setValue:[result objectForKey:@"data"] forKey:@"zhimaScore"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            CompanyInfoCertificateVC *companyVC = [[CompanyInfoCertificateVC alloc] init];
//            [weakSelf.navigationController pushViewController:companyVC animated:YES];
//        } else {
//            [CommonUtils showToast:[result objectForKey:@"msg"]];
//        }
//    }];
}

- (void)selectBtnClick {
    self.selectBtn.selected = !self.selectBtn.selected;
}

- (IBAction)zhimaBtnClick:(id)sender {
//    JobCertificationViewController *jobCVC = [[JobCertificationViewController alloc] init];
//    [self.navigationController pushViewController:jobCVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    
    return _params;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
