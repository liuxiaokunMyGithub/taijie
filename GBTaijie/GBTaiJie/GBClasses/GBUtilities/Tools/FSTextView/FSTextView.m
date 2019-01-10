//
//  FSTextView.m
//  FSTextView
//
//  Created by 刘小坤 on 2018/827.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import "FSTextView.h"

CGFloat const kFSTextViewPlaceholderVerticalMargin = 8.0; ///< placeholder垂直方向边距
CGFloat const kFSTextViewPlaceholderHorizontalMargin = 6.0; ///< placeholder水平方向边距

@interface FSTextView ()<UITextViewDelegate>

@property (nonatomic, copy) FSTextViewHandler changeHandler; ///< 文本改变Block
@property (nonatomic, copy) FSTextViewHandler maxHandler; ///< 达到最大限制字符数Block
@property (nonatomic, strong) UILabel *placeholderLabel; ///< placeholderLabel
@property (nonatomic, assign) BOOL isExpression;
@end

@implementation FSTextView

#pragma mark - Super Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self layoutIfNeeded];
    }
    [self initialize];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    return self;
}

- (BOOL)becomeFirstResponder {
    BOOL become = [super becomeFirstResponder];
    // 成为第一响应者时注册通知监听文本变化
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    // 成为第一响应者时注册通知监听文本变化
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangeTextInRange: replacementText:) name:UITextViewTextDidChangeNotification object:nil];
    
    return become;
}

- (BOOL)resignFirstResponder {
    BOOL resign = [super resignFirstResponder];
    // 注销第一响应者时移除文本变化的通知, 以免影响其它的`UITextView`对象.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
    return resign;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [super canPerformAction:action withSender:sender];
    BOOL result = _canPerformAction;
    return result;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _changeHandler = NULL;
    _maxHandler = NULL;
}

#pragma mark - Private

- (void)initialize {
    // 基本配置 (需判断是否在Storyboard中设置了值)
    _canPerformAction = YES;
    if (_maxLength == 0 || _maxLength == NSNotFound) _maxLength = NSUIntegerMax;
    if (!_placeholderColor) _placeholderColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1.000];
    
    // 基本设定 (需判断是否在Storyboard中设置了值)
    if (!self.backgroundColor) self.backgroundColor = [UIColor whiteColor];
    if (!self.font) self.font = [UIFont systemFontOfSize:15.f];
    
    // placeholderLabel
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.text = _placeholder; // 可能在Storyboard中设置了Placeholder
    self.placeholderLabel.textColor = _placeholderColor;
    [self addSubview:self.placeholderLabel];
    self.delegate = self;
    
    // constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:kFSTextViewPlaceholderVerticalMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:kFSTextViewPlaceholderHorizontalMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:-kFSTextViewPlaceholderHorizontalMargin*2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:-kFSTextViewPlaceholderVerticalMargin*2]];
}

#pragma mark - Getter
/// 返回一个经过处理的 `self.text` 的值, 去除了首位的空格和换行.
- (NSString *)formatText {
    return [[super text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 去除首尾的空格和换行.
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _placeholderLabel;
}

#pragma mark - Setter

- (void)setText:(NSString *)text {
    [super setText:text];
    self.placeholderLabel.hidden = [@(text.length) boolValue];
    // 手动模拟触发通知
    //NSNotification *notification = [NSNotification notificationWithName:UITextViewTextDidChangeNotification object:self];
//    [self textDidChange:notification];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setMaxLength:(NSUInteger)maxLength {
    _maxLength = fmax(0, maxLength);
    self.text = self.text;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (!borderColor) return;
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (!placeholder) return;
    _placeholder = [placeholder copy];
    if (_placeholder.length > 0) {
        self.placeholderLabel.text = _placeholder;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (!placeholderColor) return;
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = _placeholderColor;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    if (!placeholderFont) return;
    _placeholderFont = placeholderFont;
    self.placeholderLabel.font = _placeholderFont;
}

#pragma mark - NSNotification
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < _maxLength) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = _maxLength - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                
                if (caninputlen == -1) {
                    self.isExpression = YES;
                }else {
                    self.isExpression = NO;
                    
                }
                s = trimString;
                NSLog(@"s%@",s);
                
            }
            
            NSLog(@"range%@",NSStringFromRange(range));
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            
            
            if (self.isExpression == YES) {
                return YES;
            }else {
                return NO;
            }
            
        }else
        
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    // 根据字符数量显示或者隐藏 `placeholderLabel`
    self.placeholderLabel.hidden = [@(self.text.length) boolValue];
    
    // 禁止第一个字符输入空格或者换行
    if (self.text.length == 1) {
        if ([self.text isEqualToString:@" "] || [self.text isEqualToString:@"\n"]) {
            self.text = @"";
        }
    }

    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > _maxLength)
    {

        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = nil;
        if (self.isExpression == YES) {
           s  = [nsTextContent substringToIndex:_maxLength+1];

        }else {
          s = [nsTextContent substringToIndex:_maxLength];
        }
        [textView setText:s];
        
        _maxHandler ? _maxHandler(self) : NULL; // 回调达到最大限制的Block.
        [self.undoManager removeAllActions]; // 达到最大字符数后清空所有 undoaction, 以免 undo 操作造成crash.

    }
    
    // 回调文本改变的Block.
    _changeHandler ? _changeHandler(self) : NULL;

    //不让显示负数 口口日
//    self.lbNums.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,_maxLength - existTextNum),_maxLength];
//    NSLog(@"self.lbNums.text%@",[NSString stringWithFormat:@"%ld/%lu",MAX(0,_maxLength - existTextNum),(unsigned long)_maxLength]);
}

- (void)textDidChange:(NSNotification *)notification {
    // 通知回调的实例的不是当前实例的话直接返回
    if (notification.object != self) return;
    
    // 根据字符数量显示或者隐藏 `placeholderLabel`
    self.placeholderLabel.hidden = [@(self.text.length) boolValue];
    
    // 禁止第一个字符输入空格或者换行
    if (self.text.length == 1) {
        if ([self.text isEqualToString:@" "] || [self.text isEqualToString:@"\n"]) {
            self.text = @"";
        }
    }
    
    UITextRange *selectedRange = [self markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [self positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    // 只有当maxLength字段的值不为无穷大整型也不为0时才计算限制字符数.
    if (_maxLength != NSUIntegerMax && _maxLength != 0 && self.text.length > 0) {
        
        if (!self.markedTextRange && self.text.length > _maxLength) {
            _maxHandler ? _maxHandler(self) : NULL; // 回调达到最大限制的Block.
            self.text = [self.text substringToIndex:_maxLength]; // 截取最大限制字符数.
            [self.undoManager removeAllActions]; // 达到最大字符数后清空所有 undoaction, 以免 undo 操作造成crash.
        }
    }
    
    // 回调文本改变的Block.
    _changeHandler ? _changeHandler(self) : NULL;
}

#pragma mark - Public

+ (instancetype)textView {
    return [[self alloc] init];
}

- (void)addTextDidChangeHandler:(FSTextViewHandler)changeHandler{
    _changeHandler = [changeHandler copy];
}

- (void)addTextLengthDidMaxHandler:(FSTextViewHandler)maxHandler {
    _maxHandler = [maxHandler copy];
}

@end
