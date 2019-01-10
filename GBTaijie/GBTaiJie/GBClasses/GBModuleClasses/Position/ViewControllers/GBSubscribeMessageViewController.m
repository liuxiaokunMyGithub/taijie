//
//  GBSubscribeMessageViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/22.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBSubscribeMessageViewController.h"

// Controllers



// ViewModels


// Models


// Views
#import "FSTextView.h"

@interface GBSubscribeMessageViewController ()
@property (nonatomic, strong) FSTextView *textView;

/* 输入框右侧限制数 */
@property (nonatomic, strong) UILabel *rightNubLabel;
/* 昵称输入框 */
@property (nonatomic, strong) UITextField *nickTextField;
/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* 标题 */
@property (nonatomic, strong) UILabel *sublabel;
/* 编辑图标 */
@property (nonatomic, strong) UIImageView *editImageView;
/* 最大数限制 */
@property (nonatomic, strong) UILabel *noticeLabel;

@end

@implementation GBSubscribeMessageViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"描述预约";
    
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    
    [self initSubViews];
    
    [self.view addSubview:[self setupBottomViewWithtitle:@"保存"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
        @GBStrongObj(self);
        if (self.textView.text.length < 10) {
            return [UIView showHubWithTip:@"请输入不少于10字的留言"];
        }
        
        !self.saveButtonClickBlock ? : self.saveButtonClickBlock(self.textView.text);
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self addMasonry];
}

#pragma mark - # Setup Methods
- (void)initSubViews {
    UILabel *label = [[UILabel alloc] init];
    label.text = self.inputShowType == InputShowTypeSubscribeMessage ?  @"保过留言" : @"保过服务内容";
    label.font = Fit_B_Font(28);
    label.textColor = [UIColor kImportantTitleTextColor];
    [self.view addSubview:label];
    self.titleLabel = label;
    
    UILabel *sublabel = [[UILabel alloc] init];
    sublabel.text = self.inputShowType == InputShowTypeSubscribeMessage ? @"详细且清晰的自我能力介绍和描述，有助于同事更加针对性的为你服务" : @"我能提供哪些具体服务？请描述";
    sublabel.numberOfLines = 2;
    sublabel.font = Fit_Font(17);
    sublabel.textColor = [UIColor kImportantTitleTextColor];
    [self.view addSubview:sublabel];
    self.sublabel = sublabel;
    
    UIImageView *editImageView = [[UIImageView alloc] initWithImage:GBImageNamed(@"position_question")];
    [self.view addSubview:editImageView];
    self.editImageView = editImageView;
    
    // 达到最大限制时提示的Label
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.font = Fit_Font(12);
    noticeLabel.textColor = [UIColor kPlaceHolderColor];
    noticeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:noticeLabel];
    self.noticeLabel = noticeLabel;
    
    // FSTextView
    FSTextView *textView = [FSTextView textView];
    textView.placeholder = self.inputShowType == InputShowTypeSubscribeMessage ? @"请输入您想要说的话" : @"1.你可以遇到的问题。\n2.我能帮你什么？\n3.为什么选择我？";
    textView.placeholderFont = Fit_Font(14);
    textView.font = Fit_Font(14);
    textView.editable = YES;
    // 限制输入最大字符数.
    textView.maxLength = self.inputShowType == InputShowTypeSubscribeMessage ? 500 : 800;
    
    // 弱化引用, 以免造成内存泄露.
    __weak __typeof (&*noticeLabel) weakNoticeLabel = noticeLabel;
    weakNoticeLabel.text = [NSString stringWithFormat:self.inputShowType == InputShowTypeSubscribeMessage ? @"0/500" : @"0/800"];
    
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        if (textView.text.length < textView.maxLength) {
            weakNoticeLabel.text = [NSString stringWithFormat:self.inputShowType == InputShowTypeSubscribeMessage ? @"%zu/500" : @"%zu/800", textView.text.length];
            weakNoticeLabel.textColor = [UIColor kPlaceHolderColor];
        }else {
            weakNoticeLabel.text = [NSString stringWithFormat:@"最多输入%zi个字符", textView.maxLength];
            weakNoticeLabel.textColor = [UIColor kBaseColor];
        }
    }];
    
    [self.view addSubview:textView];
    self.textView = textView;
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods
- (void)addMasonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SafeAreaTopHeight+16);
        make.left.mas_equalTo(GBMargin);
        make.height.equalTo(@30);
    }];
    
    [self.sublabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(GBMargin/2);
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.height.equalTo(@56);
    }];
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-GBMargin);
        make.height.equalTo(@16);
        make.bottom.mas_equalTo(self.sublabel.mas_bottom);
    }];
    
    [self.editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.height.width.equalTo(@12);
        make.top.equalTo(self.sublabel.mas_bottom).offset(GBMargin);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.editImageView.mas_right);
        make.right.mas_equalTo(-GBMargin);
        make.top.equalTo(self.sublabel.mas_bottom).offset(GBMargin/2);
        make.height.equalTo(@180);
    }];
    
}

#pragma mark - # Delegate


#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
