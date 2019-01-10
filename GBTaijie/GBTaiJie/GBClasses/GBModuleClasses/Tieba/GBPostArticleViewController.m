//
//  GBPostArticleViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/9.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBPostArticleViewController.h"
#import "XKSelPhotos.h"
// Controllers


// ViewModels


// Models


// Views
#import "GBPostArticleImageCell.h"
#import "FSTextView.h"
#import "XKTextField.h"

static NSString *const kGBPostArticleImageCellID = @"GBPostArticleImageCellID";

@interface GBPostArticleViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UIToolbar *textFieldToolbar;
@property (nonatomic, strong) FSTextView *textView;

@property (nonatomic, assign) CGFloat keyboardSpacingHeight;

/* 底部工具条 */
@property (nonatomic, strong) UIView *bottomToolView;
@property (nonatomic, strong) UICollectionView *pickerCollectionView;
/* 图片 */
@property (nonatomic, strong) NSMutableArray *imageArray;
/* 图片路径 */
@property (nonatomic, strong) NSString *picUrl;

/* 输入框右侧限制数 */
@property (nonatomic, strong) UILabel *rightNubLabel;

/* 提示框 */
@property (nonatomic, strong)  SCLAlertView *alert;
/* 昵称输入框 */
@property (nonatomic, strong) XKTextField *nickTextField;
/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* 最大数限制 */
@property (nonatomic, strong) UILabel *noticeLabel;

/* 选择图片 */
@property (nonatomic, strong) UIButton *imageButton;
/* 昵称 */
@property (nonatomic, strong) UIButton *nickButton;
/* <#describe#> */
@property (nonatomic, copy) UIImage *gossipHeadImg;

@end

@implementation GBPostArticleViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 输入框距离键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"发布吾聊";
    [GBNotificationCenter addObserver:self
                             selector:@selector(keyboardWillHide:)
                                 name:UIKeyboardWillHideNotification
                               object:nil];
    [GBNotificationCenter addObserver:self selector:@selector(keybardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.customNavBar wr_setRightButtonWithTitle:@"发布" titleColor:[UIColor kAssistInfoTextColor]];
    
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
    @GBStrongObj(self);
        if (self.textView.text.length == 0) {
            return ;
        }
        
        // 发布帖子
        GBTiebaViewModel *tiebaVM = [[GBTiebaViewModel alloc] init];
        [tiebaVM loadRequestPublishTiebaContent:self.textView.text picture:self.picUrl];
        [tiebaVM setSuccessReturnBlock:^(id returnValue) {
            [GBNotificationCenter postNotificationName:TiebaDataRefreshNotification object:nil];
            [UIView showHubWithTip:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    [self initSubViews];
    
    [self getNickName];

    
}

- (void)getNickName {
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
#pragma mark - # Setup Methods
- (void)initSubViews {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"说点啥";
    label.font = Fit_B_Font(28);
    label.textColor = [UIColor kImportantTitleTextColor];
    [self.view addSubview:label];
    self.titleLabel = label;
    
    // 达到最大限制时提示的Label
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.font = Fit_Font(12);
    noticeLabel.textColor = [UIColor kPlaceHolderColor];
    noticeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:noticeLabel];
    self.noticeLabel = noticeLabel;
    
    // FSTextView
    FSTextView *textView = [FSTextView textView];
    textView.placeholder = @"匿名发布,快来报个料,吐个槽吧!";
    textView.placeholderFont = Fit_Font(14);
    textView.font = Fit_Font(14);
    textView.editable = YES;
    // 限制输入最大字符数.
    textView.maxLength = 140;
    
    // 弱化引用, 以免造成内存泄露.
    __weak __typeof (&*noticeLabel) weakNoticeLabel = noticeLabel;
    weakNoticeLabel.text = [NSString stringWithFormat:@"0/140"];
    
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        if (textView.text.length < textView.maxLength) {
            weakNoticeLabel.text = [NSString stringWithFormat:@"%lu/140", (unsigned long)textView.text.length];
            weakNoticeLabel.textColor = [UIColor kPlaceHolderColor];
            if (textView.text.length > 0) {
                [self.customNavBar wr_setTintColor:[UIColor kBaseColor]];
            }else {
                [self.customNavBar wr_setTintColor:[UIColor kAssistInfoTextColor]];
            }
            self.customNavBar.titleLabelColor = [UIColor clearColor];

        }else {
            weakNoticeLabel.text = [NSString stringWithFormat:@"最多输入%lu个字符", (unsigned long)textView.maxLength];
            weakNoticeLabel.textColor = [UIColor kBaseColor];
        }
    }];
    
    [self.view addSubview:textView];
    self.textView = textView;
    
    _bottomToolView = [[UIView alloc] init];
    self.bottomToolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomToolView];

    UIButton *nickBtn = [[UIButton alloc] init];
        [nickBtn setTitle:@"匿名用户" forState:UIControlStateNormal];
    [nickBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
    nickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    nickBtn.titleLabel.font = Fit_M_Font(12);
    [nickBtn addTarget:self action:@selector(nickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolView addSubview:nickBtn];
    self.nickButton = nickBtn;
    
    UIButton *imageBtn = [[UIButton alloc] init];
    [imageBtn setImage:[UIImage imageNamed:@"tieba_post_addImage"] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(imageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolView addSubview:imageBtn];
    self.imageButton = imageBtn;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor kSegmentateLineColor];
    [self.bottomToolView addSubview:lineView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.pickerCollectionView registerClass:[GBPostArticleImageCell class] forCellWithReuseIdentifier:kGBPostArticleImageCellID];
    [self.view addSubview:self.pickerCollectionView];
    
    self.pickerCollectionView.delegate = self;
    self.pickerCollectionView.dataSource = self;
    self.pickerCollectionView.scrollEnabled = NO;
    self.pickerCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.bottomToolView];
    
    // 添加约束
    [self addMasonry];
}

- (void)addMasonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SafeAreaTopHeight+16);
        make.left.mas_equalTo(GBMargin);
        make.height.equalTo(@30);
    }];
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-GBMargin);
        make.height.equalTo(@16);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(32);
        make.height.equalTo(@160);
    }];
    
    [self.pickerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-0);
        make.top.equalTo(self.textView.mas_bottom).offset(16);
        make.height.equalTo(@120);
    }];
    
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.mas_equalTo(SCREEN_HEIGHT - SafeAreaBottomHeight - 56);
        make.height.equalTo(@56);
    }];
    
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-GBMargin);
        make.centerY.mas_equalTo(self.bottomToolView.centerY);
        make.height.mas_equalTo(40);
    }];
    
    [self.nickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.centerY.mas_equalTo(self.bottomToolView.centerY);
        make.height.mas_equalTo(40);
    }];

}

#pragma mark - # Event Response
- (void)keybardWillChangeFrame:(NSNotification *)note {
    CGFloat keyboardH  = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    if (keyboardH < SCREEN_HEIGHT ) {
        [self.bottomToolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(keyboardH-56);
        }];
    }
    
    if (!self.nickTextField.isFirstResponder) {
        // 让底部工具栏随键盘移动更自然 防止影响昵称输入框弹出的动画效果
        CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
    }else {
        IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
        // 输入框距离键盘的距离
        keyboardManager.keyboardDistanceFromTextField = 120.0f;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.bottomToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREEN_HEIGHT - SafeAreaBottomHeight - 56);
    }];
        if (self.alert) {
            self.alert.view.center = KEYWINDOW.center;
        }
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    // 输入框距离键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}

/** MARK:修改昵称 */
- (void)nickBtnClick:(UIButton *)nickButton {
    _alert = [[SCLAlertView alloc] init];
    [_alert setHorizontalButtons:YES];
    XKTextField *textField = [[XKTextField alloc] initWithFrame:CGRectMake(0, 0, 215, 30)];
    textField.margin = 5;
    textField.placeholder = @"输入您的昵称";
    [textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.font = Fit_Font(14);
    textField.delegate = self;
    self.nickTextField = textField;
    //监听输入
    [self.nickTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
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

- (void)textValueChanged:(UITextField *)textField {
    self.rightNubLabel.text = GBNSStringFormat(@"%lu/5",textField.text.length);
}

- (void)finishBirthChange {
    [self.textView resignFirstResponder];
}

- (void)imageButtonAction {
    [self ActionSheetWithTitle:nil message:nil destructive:nil destructiveAction:nil andOthers:@[@"取消",@"上传图片"] animated:YES action:^(NSInteger index) {
        if (index == 1) {
            XKSelPhotos *imageManager = [XKSelPhotos selPhotos];
            [imageManager pushImagePickerControllerWithImagesCount:1 WithColumnNumber:3 didFinish:^(TZImagePickerController *imagePickerVc) {
                [self presentViewController:imagePickerVc animated:YES completion:nil];
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    [self updateImage:[photos lastObject]];
                }];
            }];
        }
    }];
}

- (void)updateImage:(UIImage *)image {
    // 判断图片是不是png格式的文件
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    if (UIImagePNGRepresentation(image)) {
        // 返回为png图像。
    }else if (imageData){
        // 返回为JPEG图像
    }else {
        [UIView showHubWithTip:@"请上传 jpeg或是png格式"];
        return;
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_IMAGE_GetQiuNiuUpToken httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        if([responseData[@"result"] integerValue] == 1)
        {
            NSString *token = responseData[@"data"][@"upToken"];
            // 七牛云图片上传
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.zone = [QNFixedZone zone1];
            }];
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
            [upManager putData:imageData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (ValidStr(resp[@"key"])) {
                    self.picUrl = resp[@"key"];
                    [self.imageArray addObject:image];
                    [self.pickerCollectionView reloadData];
                }else {
                    [UIView showHubWithTip:@"图片上传失败"];
                }
                
            } option:nil];
        }
        
    }fail:^(NSError *error) {
        NSLog(@"更新七牛云token error:%@",error);
    }];
}

- (void)deletePhoto:(UIButton *)deleButton {
    [self.imageArray removeObjectAtIndex:deleButton.tag];
    [self.pickerCollectionView reloadData];
}

#pragma mark - # Delegate


// MARK <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GBPostArticleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: kGBPostArticleImageCellID forIndexPath:indexPath];
    cell.profilePhoto.image = self.imageArray[indexPath.row];
    cell.closeButton.tag = [indexPath item];
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120,120);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, GBMargin, 5, 8);
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.nickTextField) {
        if (textField.text.length > 5) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:5];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
}

#pragma mark - # Getters and Setters
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    
    return _imageArray;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
