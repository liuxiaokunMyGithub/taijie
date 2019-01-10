//
//  GBAddStoryViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/23.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 添加故事
//  @discussion <#类的功能#>
//

#import "GBAddStoryViewController.h"

// Controllers


// ViewModels


// Models


// Views


@interface GBAddStoryViewController ()
/* <#describe#> */
@property (nonatomic, strong) FSTextView *textView;
/* <#describe#> */
@property (nonatomic, strong) UILabel *maxNoticeLabel;

@end

@implementation GBAddStoryViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:[UIColor kBaseColor]];
    @GBWeakObj(self);
    self.customNavBar.onClickRightButton = ^{
    @GBStrongObj(self);
        if (!ValidStr(self.textView.text)) {
            return [UIView showHubWithTip:@"请输入你的故事"];
        }
        
        NSDictionary *param = @{
                                @"story":self.textView.text
                                };
        
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestPersonalEditInfoUpdate:param];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            self.userModel.story = self.textView.text;
            [userManager saveCurrentUser:self.userModel];
            
            [self.navigationController popViewControllerAnimated:YES];
            [UIView showHubWithTip:@"更新成功"];

        }];
    };
    
    [self setupSubView];
    
    [self.view addSubview:[self setupBigTitleHeadViewWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, 80) title:@"我的故事"]];
}


#pragma mark - # Setup Methods
- (void)setupSubView {
    // 达到最大限制时提示的Label
    UILabel *maxNoticeLabel = [[UILabel alloc] init];
    maxNoticeLabel.font = Fit_Font(12);
    maxNoticeLabel.textColor = [UIColor kPlaceHolderColor];
    maxNoticeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:maxNoticeLabel];
    self.maxNoticeLabel = maxNoticeLabel;
    
    // FSTextView
    FSTextView *textView = [FSTextView textView];
    textView.placeholder = @"输入故事详情";
    textView.font = Fit_Font(14);
    textView.editable = YES;
    // 限制输入最大字符数.
    textView.maxLength = 150;
    if (ValidStr(self.userModel.story)) {
        textView.text = self.userModel.story;
    }
    
    // 弱化引用, 以免造成内存泄露.
    __weak __typeof (&*maxNoticeLabel) weakNoticeLabel = maxNoticeLabel;
    weakNoticeLabel.text = [NSString stringWithFormat:@"0/150"];
    
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        if (textView.text.length < textView.maxLength) {
            weakNoticeLabel.text = [NSString stringWithFormat:@"%zu/150", textView.text.length];
            weakNoticeLabel.textColor = [UIColor kPlaceHolderColor];
            
        }else {
            weakNoticeLabel.text = [NSString stringWithFormat:@"最多输入%zi个字符", textView.maxLength];
            weakNoticeLabel.textColor = [UIColor kBaseColor];
        }
    }];
    
    [self.view addSubview:textView];
    self.textView = textView;
    GBViewBorderRadius(self.textView, 2, 1, [UIColor kSegmentateLineColor]);
    
    [self.maxNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SafeAreaTopHeight + 80);
        make.right.mas_equalTo(-GBMargin);
        make.height.equalTo(@16);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.top.equalTo(self.maxNoticeLabel.mas_bottom).offset(10);
        make.height.equalTo(@160);
    }];
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate


#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
