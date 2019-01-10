//
//  YQPayKeyWordVC.m
//  Youqun
//
//  Created by 王崇磊 on 16/6/1.
//  Copyright © 2016年 W_C__L. All rights reserved.
//

#import "YQPayKeyWordVC.h"
#import "Masonry.h"
#import "UIColor+PPCategory.h"
#import "GBModifyViewController.h"

@interface YQPayKeyWordVC ()<WCLPassWordViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *leftBT;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cutomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewCenterY;

@end

@implementation YQPayKeyWordVC

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
    self.backGroundView.alpha = 0;
    self.contentView.alpha = 0;
    [self addKeyWordView];
}

- (void)addKeyWordView {
    self.titleLabel.text = @"请输入支付密码";
    [self.leftBT setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [self.leftBT setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateHighlighted];
    [self.customView addSubview:self.keyWordView];
    [self.keyWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(215);
    }];
    self.cutomViewHeight.constant = 215;
    self.contentViewCenterY.constant = -100;
    [self.view setNeedsLayout];
}

- (void)disMissKeyWordView {
    if ([self.keyWordView superview]) {
        [self disMiss];
    }
//    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.contentView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self.keyWordView removeFromSuperview];
//        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//            self.contentView.alpha = 1;
//        } completion:nil];
//        [self addKeyAnimation];
//    }];
}

- (void)disMissSelectPayStyleView {
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.contentView.alpha = 1;
        } completion:nil];
        [self addKeyAnimation];
    }];
}

- (void)showInViewController:(UIViewController *)vc {
    if (vc) {
        [vc addChildViewController:self];
        [vc.view addSubview:self.view];
        [self show];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (YQInputPayKeyWordView *)keyWordView {
    if (_keyWordView == nil) {
        _keyWordView = [YQInputPayKeyWordView initFromNibSelectBlock:^{
            // [weakSelf disMissKeyWordView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                GBModifyViewController *modifyPhoneVC = [[GBModifyViewController alloc] init];
                modifyPhoneVC.modifyType = ModifyControllerTypePayPassWord;
                [self.navigationController pushViewController:modifyPhoneVC animated:YES];
            });
        }];
        _keyWordView.passWord.delegate = self;
    }
    return _keyWordView;
}

- (IBAction)disMissAction:(UIButton *)sender {
    if ([self.keyWordView superview]) {
        [self disMiss];
    }
}

- (void)show {
    self.backGroundView.alpha = 0.7;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.alpha = 1;
    } completion:nil];
    
    [self addKeyAnimation];
}

- (void)addKeyAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.calculationMode = kCAAnimationCubic;
    animation.values = @[@1.07,@1.06,@1.05,@1.03,@1.02,@1.01,@1.0];
    animation.duration = 0.4;
    [self.contentView.layer addAnimation:animation forKey:@"transform.scale"];
}

- (void)disMiss {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - WCLPassWordViewDelegate
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(WCLPassWordView *)passWord {
    NSLog(@"======密码改变：%@",passWord.textStore);
}

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(WCLPassWordView *)passWord {
    NSLog(@"+++++++密码输入完成：%@",passWord.textStore);
    if (self.payPassWordBlock) {
        self.payPassWordBlock(passWord.textStore);
    }
}

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(WCLPassWordView *)passWord {
    NSLog(@"-------密码开始输入");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
