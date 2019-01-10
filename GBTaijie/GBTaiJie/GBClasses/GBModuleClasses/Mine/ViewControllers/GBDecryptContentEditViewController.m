//
//  ApplyDecryptViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/88.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBDecryptContentEditViewController.h"
 
#import "YQPayKeyWordVC.h"
#import "GBTaiJieBiRechargeViewController.h"
#import "GBModifyViewController.h"

@interface GBDecryptContentEditViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *backV;
/* 支付密码输入框 */
@property (nonatomic, strong) YQPayKeyWordVC *payPsdVC;

@end

@implementation GBDecryptContentEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"解密内容编辑";

    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:[UIColor kBaseColor]];
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
    @GBStrongObj(self);
        [self saveBtnClick];
    }];
    
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    self.navigationItem.title = @"预约私聊解密";
    self.titleL.font = Fit_M_Font(17);
    self.titleL.textColor = [UIColor kImportantTitleTextColor];
    
    self.topCountL.font = Fit_Font(12);
    self.topCountL.textColor = [UIColor kAssistInfoTextColor];
    
    self.bottomCountL.font = Fit_Font(12);
    self.bottomCountL.textColor = [UIColor kAssistInfoTextColor];
    
    self.topTextView.placeholder = @"请为你的解密写一个吸引人的标题";
    self.bottomTextView.placeholder = @"1.你肯能遇到的问题\n2.我能帮你什么？\n3.为什么选择我？";
    self.bottomTextView.zw_placeHolderColor = [UIColor kAssistInfoTextColor];
    self.topTextView.zw_placeHolderColor = [UIColor kAssistInfoTextColor];
    
    self.titleL.text = self.titleStr;
    NSString *priceStr = GBNSStringFormat(@"%zu币/%@小时\n",self.decryptModel.price,@"48");
    NSMutableAttributedString *purchaseCount = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kAssistInfoTextColor] changeFont:Fit_Font(12) totalString:GBNSStringFormat(@"%zu人已购",self.decryptModel.purchasedCount) changeString:GBNSStringFormat(@"%zu人已购",self.decryptModel.purchasedCount)];
    NSMutableAttributedString *priceAttributedStr = [DCSpeedy dc_setSomeOneChangeColor:[UIColor kImportantTitleTextColor] changeFont:Fit_M_Font(20) totalString:priceStr changeString:GBNSStringFormat(@"%zu币",self.decryptModel.price)];
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
    if (textView == self.topTextView) {

    if (result.length > 20) {
        [UIView showHubWithTip:@"最多输入20个字符"];
        return NO;
    }
    }else {
        if (result.length > 800) {
            [UIView showHubWithTip:@"最多输入800个字符"];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.topTextView) {
        self.topCountL.text = [NSString stringWithFormat:@"%zd/20", textView.text.length];
    } else {
        self.bottomCountL.text = [NSString stringWithFormat:@"%zd/800", textView.text.length];
    }
}

#pragma mark - 付款按钮点击事件
// MARK: 保存
- (void)saveBtnClick {
    if (!self.topTextView.text || self.topTextView.text.length == 0) {
        [UIView showHubWithTip:@"请输入解密标题"];
        return;
    }
    if (!self.bottomTextView.text || self.bottomTextView.text.length == 0) {
        [UIView showHubWithTip:@"请描述一下解密内容"];
        
        return;
    }
    
    !_contentSaveBlock ? : _contentSaveBlock(self.topTextView.text,self.bottomTextView.text);
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
