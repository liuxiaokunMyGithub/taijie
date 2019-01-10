//
//  ApplyDecryptViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/88.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "ApplyDecryptViewController.h"

#import "YQPayKeyWordVC.h"
#import "GBTaiJieBiRechargeViewController.h"
#import "GBModifyViewController.h"

@interface ApplyDecryptViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *backV;

/* 支付密码输入框 */
@property (nonatomic, strong) YQPayKeyWordVC *payPsdVC;

@end

@implementation ApplyDecryptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    self.navigationItem.title = @"预约私聊解密";
    self.titleL.font = Fit_M_Font(17);
    self.titleL.textColor = [UIColor kImportantTitleTextColor];
    
    self.topCountL.font = Fit_Font(12);
    self.topCountL.textColor = [UIColor kAssistInfoTextColor];
    
    self.bottomCountL.font = Fit_Font(12);
    self.bottomCountL.textColor = [UIColor kAssistInfoTextColor];
    
    self.topTextView.placeholder = @"详细的问题描述有助于同事有的放矢的，更加有针对性的解决你的实际问题。";
    self.bottomTextView.placeholder = @"你填写的信息只有同事可以看到，不会公开给其他人。";
    self.bottomTextView.zw_placeHolderColor = [UIColor kAssistInfoTextColor];
    self.topTextView.zw_placeHolderColor = [UIColor kAssistInfoTextColor];
    NSString *tempPric =  ([self.decryptModel.discountType isEqualToString:@"FREE"] ? @"限免" : GBNSStringFormat(@"%zu币",self.decryptModel.price));
    self.titleL.text = self.titleStr;
    NSString *priceStr = GBNSStringFormat(@"%@/%@小时\n",tempPric,@"48");
    NSMutableAttributedString *purchaseCount = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kAssistInfoTextColor] changeFont:Fit_Font(12) totalString:GBNSStringFormat(@"%zu人已购",self.decryptModel.purchasedCount) changeString:GBNSStringFormat(@"%zu人已购",self.decryptModel.purchasedCount)];
    NSMutableAttributedString *priceAttributedStr = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kPromptRedColor] changeFont:Fit_M_Font(20) totalString:priceStr changeString:tempPric];
    [priceAttributedStr appendAttributedString:purchaseCount];
    self.priceL.attributedText = priceAttributedStr;
    
    [self setupPopupView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = YES;
}
- (void)setupPopupView {
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.backV = backV;
    
    UIView *whiteV = [[UIView alloc] initWithFrame:CGRectMake(38, 251, SCREEN_WIDTH - 76, 194)];
    whiteV.backgroundColor = [UIColor whiteColor];
    whiteV.layer.cornerRadius = 10.0f;
    whiteV.layer.masksToBounds = YES;
    [backV addSubview:whiteV];
    
    UIImageView *imageIV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 87) * 0.5, 202, 87, 84)];
    imageIV.image = [UIImage imageNamed:@"decrypt_submit_success"];
//    imageIV.backgroundColor = UIColorFromRGB(0xFAB600);
    imageIV.backgroundColor = [UIColor clearColor];
    [backV addSubview:imageIV];
    
    UILabel *oneL = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, whiteV.width, 16)];
    oneL.textColor = UIColorFromRGB(0x383F42);
    oneL.textAlignment = NSTextAlignmentCenter;
    oneL.text = @"提交成功";
    oneL.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [whiteV addSubview:oneL];
    
    UILabel *twoL = [[UILabel alloc] initWithFrame:CGRectMake(0, 111, whiteV.width, 13)];
    twoL.textColor = UIColorFromRGB(0x9DB1BA);
    twoL.textAlignment = NSTextAlignmentCenter;
    twoL.numberOfLines = 0;
    twoL.text = @"认证同事将在24小时内反馈是否预约成功，请耐心等待";
    twoL.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    [whiteV addSubview:twoL];
    
    UIButton *closeB = [[UIButton alloc] initWithFrame:CGRectMake(0, whiteV.height - 41, whiteV.width, 41)];
    [closeB setBackgroundColor:UIColorFromRGB(0x00BCCC)];
    [closeB setTitle:@"我知道了" forState:UIControlStateNormal];
    closeB.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    [closeB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeB addTarget:self action:@selector(backViewOnPress) forControlEvents:UIControlEventTouchUpInside];
    [whiteV addSubview:closeB];
}

- (void)backViewOnPress {
    [self.backV removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *result = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (result.length > 300) {
        [UIView showHubWithTip:@"最多输入300个字符"];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.topTextView) {
        self.topCountL.text = [NSString stringWithFormat:@"%zd/300", textView.text.length];
    } else {
        self.bottomCountL.text = [NSString stringWithFormat:@"%zd/300", textView.text.length];
    }
}

#pragma mark - 付款按钮点击事件

- (IBAction)payBtnClick:(id)sender {
    if (!self.topTextView.text || self.topTextView.text.length == 0) {
        [UIView showHubWithTip:@"告诉同事你最想请教的问题"];
        return;
    }
    if (!self.bottomTextView.text || self.bottomTextView.text.length == 0) {
        [UIView showHubWithTip:@"请描述一下你的个人情况"];
        
        return;
    }
    
    NSString *tempDiscountType = nil;
    if ([self.decryptModel.discountType isEqualToString:@"FREE"]) {
        tempDiscountType = self.decryptModel.discountType;
        // 提交问题、描述 - 限时免费的服务下单
        GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
        [positionVM loadPositionsOrderDecrypt:self.topTextView.text personalSituation:self.bottomTextView.text incumbentDecryptId:self.decryptModel.incumbentDecryptId];
        [positionVM setSuccessReturnBlock:^(id returnValue) {
            // 支付
            [self payMoneyPassWord:nil discountType:tempDiscountType relatedId:returnValue[@"decryptId"]];
        }];
        
        return;
    }
    
    // 非限时免费的服务下单
    GBCommonViewModel *mineVM = [[GBCommonViewModel alloc] init];
    [mineVM loadRequestCheckUserHasPayPwd];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        if ([returnValue[@"hasPayPwd"] integerValue] == 1) {
            // 提交问题、描述
            GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
            [positionVM loadPositionsOrderDecrypt:self.topTextView.text personalSituation:self.bottomTextView.text incumbentDecryptId:self.decryptModel.incumbentDecryptId];
            [positionVM setSuccessReturnBlock:^(id returnValue) {
                self.payPsdVC = [[YQPayKeyWordVC alloc] init];
                [self.payPsdVC showInViewController:self];
                self.payPsdVC.keyWordView.priceLabel.text = [NSString stringWithFormat:@"%zu台阶币",self.decryptModel.price];
                @GBWeakObj(self);
                self.payPsdVC.payPassWordBlock = ^(NSString *passWord) {
                    @GBStrongObj(self);
                    
                    [self payMoneyPassWord:passWord discountType:tempDiscountType relatedId:returnValue[@"decryptId"]];
                };
            }];
        }else {
            [self AlertWithTitle:nil message:@"请先设置支付密码" andOthers:@[@"取消",@"去设置"] animated:YES action:^(NSInteger index) {
                if (index == 1) {
                    GBModifyViewController *modifyPhoneVC = [[GBModifyViewController alloc] init];
                    modifyPhoneVC.modifyType = ModifyControllerTypePayPassWord;
                    [self.navigationController pushViewController:modifyPhoneVC animated:YES];
                }
            }];
        }
    }];
}

- (void)payMoneyPassWord:(NSString *)passWord discountType:(NSString *)discountType relatedId:(NSString *)relatedId {
    GBPositionViewModel *positionVM = [[GBPositionViewModel alloc] init];
    [positionVM loadPositionPayWithType:@"GOODS_TYPE_JM" relatedId:relatedId payPwd:passWord discountType:discountType];
    [positionVM setSuccessReturnBlock:^(id returnValue) {
        if ([returnValue[@"result"] integerValue] == 1) {
            NSDictionary *param = @{
                                    @"goodsID":GBNSStringFormat(@"%zu",self.decryptModel.incumbentDecryptId), @"price":GBNSStringFormat(@"%zu",self.decryptModel.price),
                                    @"goodsName":@"GOODS_TYPE_JM",
                                    @"goodsType":@"PAY_TYPE_PG_TJB",
                                    
                                    };
            [GBAppDelegate setupJAnalyticsPurchaseEvent:param];
            
            // 成功
            [UIView showHubWithTip:@"支付成功"];
            [self.payPsdVC disMissKeyWordView];
            [self.navigationController popViewControllerAnimated:YES];
        }else if([returnValue[@"result"] integerValue] == 2) {
            // 余额不足
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"余额不足"
                                                                                     message:@"您的台阶币余额不足，请充值"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            // 2.创建并添加按钮
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                GBTaiJieBiRechargeViewController *taijiebiVC = [[GBTaiJieBiRechargeViewController alloc]init];
                [GBRootViewController presentViewController:taijiebiVC animated:YES completion:nil];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            
            [GBAppDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            
        }else {
            [UIView showHubWithTip:returnValue[@"msg"]];
        }
    }];
}

@end
