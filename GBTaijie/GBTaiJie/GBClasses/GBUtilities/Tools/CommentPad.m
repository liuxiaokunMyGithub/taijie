//
//  CommentPad.m
//  TestKeyBoard
//
//  Created by 刘小坤 on 15/1/22.
//  Copyright (c) 2015年 刘小坤. All rights reserved.
//

#import "CommentPad.h"
#import "AppDelegate.h"

#define SUBCOMMENTTAG 222

@interface CommentPad ()

@property (nonatomic, strong) UIView *corePad;
@property (nonatomic, strong) UIButton *btnHidden;
@property (nonatomic, strong) UIButton *btnSub;

@property (nonatomic, assign) BOOL isHide;
@property (nonatomic, assign) BOOL isAnimationTime;

@property (nonatomic, assign) BOOL isChange;

@property (nonatomic, assign) CGRect inputViewRect;

@end

@implementation CommentPad

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [GBNotificationCenter removeObserver:self];
    
}

-(id)init{
    CGRect boudle = [UIScreen mainScreen].bounds;
    if (self = [super initWithFrame:boudle]) {
        
        _isHide = NO;
        _isAnimationTime = NO;
        
        [self initLayout];
    }
    return self;
}
-(void)initLayout {
    CGRect boudle = [UIScreen mainScreen].bounds;
    
    _btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnHidden setTitle:@"退出" forState:UIControlStateNormal];
    _btnHidden.frame = boudle;
    _btnHidden.backgroundColor = [UIColor whiteColor];
    _btnHidden.alpha = 0.15;
    [_btnHidden addTarget:self action:@selector(exitPad:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnHidden];
    
    _corePad = [[UIView alloc] init];
    _corePad.frame = CGRectMake(0, boudle.size.height, boudle.size.width, 50);
    _corePad.backgroundColor = [UIColor whiteColor];
    [self addSubview:_corePad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    titleLabel.font = Fit_Font(14);
    titleLabel.backgroundColor = RGBA(234, 234, 234, 1.0);
    [_corePad addSubview:titleLabel];
    
    self.btnExit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnExit setTitle:@"退出" forState:UIControlStateNormal];
    self.btnExit.frame = CGRectMake(0, 5, 40, 40);
    [self.btnExit setImage:[UIImage imageNamed:@"img_icon"] forState:UIControlStateNormal];
    
    [self.btnExit addTarget:self action:@selector(selectedImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [_corePad addSubview:self.btnExit];
    
    _btnSub = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSub setTitle:@"发布" forState:UIControlStateNormal];
    [_btnSub setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
    _btnSub.titleLabel.font = Fit_M_Font(14);
    _btnSub.frame = CGRectMake(_corePad.right-40, 5, 40, 40);
    [_btnSub addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [_corePad addSubview:_btnSub];
    _btnSub.userInteractionEnabled = NO;
    _btnSub.alpha = 0.4;
    
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(self.btnExit.right + 5, titleLabel.bottom+10, _corePad.frame.size.width-self.btnExit.width - _btnSub.width-8, 30);
    _textView.delegate = self;
    _textView.zw_placeHolder = @"优质评论将会被优先展示";
    [_corePad addSubview:_textView];
    GBViewBorderRadius(_textView, 2, 0.5, [UIColor kSegmentateLineColor]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)showWithTag:(CGFloat)commentTag {
    if (self.isAnimationTime) {
        return;
    }
    
    if (commentTag == SUBCOMMENTTAG) {
        self.btnExit.hidden = YES;
        CGRect textViewFrame = _textView.frame;
        _textView.frame = CGRectMake(_corePad.left + 8, textViewFrame.origin.y, _corePad.frame.size.width - _btnSub.width-8, textViewFrame.size.height);
    }else {
        self.btnExit.hidden = NO;
    }
    
    UIWindow *window = ((AppDelegate*)[UIApplication sharedApplication].delegate).window;
    [window addSubview:self];
    [_textView becomeFirstResponder];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(commentPadShow:)]) {
            [self.delegate commentPadShow:self];
        }
        
    }
}

- (void)exitPad:(id)sender{
    NSLog(@"exitPad");
    if (self.isAnimationTime) {
        return;
    }
    _textView.text =  @"";
    [_textView resignFirstResponder];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(commentPadHide:)]) {
            [self.delegate commentPadHide:self];
        }
        
    }
}

- (void)submit:(id)sender{
    NSLog(@"submit");
    if (self.isAnimationTime) {
        return;
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(commentPadSubmit:)]) {
            [self.delegate commentPadSubmit:self];
        }
    }
}

#pragma mark - keyboard
/*
 userInfo = {
 UIKeyboardAnimationCurveUserInfoKey = 7;
 UIKeyboardAnimationDurationUserInfoKey = "0.25";
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 184}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 660}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 476}";
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 568}, {320, 184}}";
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 384}, {320, 184}}";
 }}
 */

- (void)keyboardWillShow:(NSNotification *)aNotification{
    
}

- (void)keyboardDidHide:(NSNotification *)aNotification {
    NSLog(@"退出");
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(commentPadHide:)]) {
            [self.delegate commentPadHide:self];
        }
        
    }
    
}

-(void)keyboardWillChangeFrame:(NSNotification *)aNotification {
    if (!self.textView.isFirstResponder) {
        return;
    }
    
    NSValue *tr = [aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect boudle = [UIScreen mainScreen].bounds;
    CGRect endRect = [tr CGRectValue];
    
    self.inputViewRect = endRect;
    
    NSLog(@"inputView%@",NSStringFromCGRect(endRect));
    
    if (endRect.origin.y == boudle.size.height) {
        if (_isChange != YES) {
            _isHide = YES;
        }
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.isAnimationTime = YES;
        if (self.isHide) {
            self.corePad.frame = CGRectMake(0, boudle.size.height, self.corePad.frame.size.width, self.corePad.frame.size.height);
            self.alpha = 0.0;
            self.isHide = NO;
            NSLog(@"corePadframe ishide%@",NSStringFromCGRect(self.corePad.frame));
            
        }else{
            if (self.isChange != YES) {
                
                self.corePad.frame = CGRectMake(0,  endRect.origin.y - self.corePad.frame.size.height, self.corePad.frame.size.width, self.corePad.frame.size.height);
                NSLog(@"corePadframe%@",NSStringFromCGRect(self.corePad.frame));
                self.alpha = 1.0;
                
            }
            self.isChange = NO;
            
        }
        
    }completion:^(BOOL finished){
        if (self.isHide) {
//            NSLog(@"is hide");
//            self.isHide = NO;
//            self.alpha = 1.0;
//            [self removeFromSuperview];
        }
        
        self.isAnimationTime = NO;
    }];
}

//选择图片
- (void)selectedImageAction:(UIButton *)selectImageButton {
    //    self.textField.inputView = self.photosView;
    self.isChange = YES;
    selectImageButton.selected = !selectImageButton.selected;
    if (selectImageButton.selected) {
        // 关闭键盘
        [_textView resignFirstResponder];
        [selectImageButton setImage:[UIImage imageNamed:@"ABC_icon"] forState:UIControlStateNormal];
        
        // 打开键盘
        [_textView becomeFirstResponder];
        
        
        
    }else {
        [selectImageButton setImage:[UIImage imageNamed:@"img_icon"] forState:UIControlStateNormal];
        
        // 关闭键盘
        [_textView resignFirstResponder];
        
        _textView.inputView = nil;
        
        // 打开键盘
        [_textView becomeFirstResponder];
        
    }
}

- (void)addButtonClicked {
    [_textView resignFirstResponder];
    
    NSLog(@"button clicked");
}



- (void)keyboardDidChangeFrame:(NSNotification *)aNotification {
    //    NSLog(@"keyboardDidChangeFrame");
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.markedTextRange == nil) {
        NSLog(@"text:%@", textView.text);
        if (![textView.text isEqualToString:@""]) {
            self.btnSub.userInteractionEnabled = YES;
            self.btnSub.alpha = 1;
            [self.btnSub setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
            
        }else {
            self.btnSub.userInteractionEnabled = NO;
            self.btnSub.alpha = 0.4;
            [self.btnSub setTitleColor:[UIColor kAssistInfoTextColor] forState:UIControlStateNormal];
        }
    }
    
    [textView flashScrollIndicators];   // 闪动滚动条
    
    static CGFloat maxHeight = 70.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight)
    {
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    }
    else
    {
        textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    
    //    frame.origin.y = -size.height+40;
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    
    CGRect coreFrame = self.corePad.frame;
    
    self.corePad.frame = CGRectMake(0, self.inputViewRect.origin.y - coreFrame.size.height, SCREEN_WIDTH,size.height+20);
    self.btnSub.bottom = self.corePad.height - 5;
    self.btnExit.bottom = self.corePad.height - 5;
}

@end
