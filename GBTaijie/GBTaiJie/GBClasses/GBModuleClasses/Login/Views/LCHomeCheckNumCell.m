//
//  LCHomeCheckNumCell.m
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2017/1/18.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import "LCHomeCheckNumCell.h"

@interface LCHomeCheckNumCell ()

// 按钮状态
@property (nonatomic, assign) bool isSendCheckBtnCanClick;

@property (nonatomic, assign) NSTimer *timer;
@end

@implementation LCHomeCheckNumCell

+ (instancetype)cellForTableView:(UITableView *)tableView{
    LCHomeCheckNumCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        // 输入框
        if(!_textField){
            _textField = [XKTextField new];
            _textField.font = Fit_Font(17);
            [_textField addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
            [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
            [_textField addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [self.contentView addSubview:_textField];
            
            [[_textField rac_textSignal] subscribeNext:^(id x) {
                NSString *str = (NSString *)x;
                self.placeHolderL.hidden = (str.length)>0?YES:NO;
            }];
        }
    
        _textField.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor kSegmentateLineColor];
        [self.contentView addSubview:line];
        self.line = line;
    
        if (!_placeHolderL) {
            _placeHolderL = [UILabel new];
            _placeHolderL.font = Fit_Font(17);
            _placeHolderL.textColor = [UIColor kPlaceHolderColor];
            [self.contentView addSubview:_placeHolderL];
        }
        
        // 忘记密码
        if (!_sendCheckNumBtn) {
            _sendCheckNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            [_sendCheckNumBtn setTitle:@"    获取    " forState: UIControlStateNormal];
            [_sendCheckNumBtn setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];

            [_sendCheckNumBtn.titleLabel setFont:Fit_Font(17)];
            [_sendCheckNumBtn addTarget:self action:@selector(sendCheckNumBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_sendCheckNumBtn setBackgroundColor:[UIColor kFunctionBackgroundColor]];
            _sendCheckNumBtn.enabled = NO;
            [_sendCheckNumBtn setTitleColor:[UIColor kPlaceHolderColor] forState:UIControlStateNormal];
            [self.contentView addSubview:_sendCheckNumBtn];
            
        
            _sendCheckNumBtn.layer.cornerRadius = Fit_W_H(20);;

        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(@(SCREEN_WIDTH-self.textFieldMargin*2));
        make.left.equalTo(self.contentView).offset(self.textFieldMargin);
        make.height.equalTo(@0.5);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.textFieldMargin);
        make.right.equalTo(self.contentView).offset(-self.textFieldMargin);
        make.top.equalTo(@0);
        make.bottom.equalTo(self.contentView);
    }];
    
    CGSize size = [@"    获取    " sizeWithAttributes:@{NSFontAttributeName:Fit_Font(17)}];

    [self.sendCheckNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textField).offset(-5);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@Fit_W_H(40));
        make.width.equalTo(@(size.width));
    }];
    
    [self.placeHolderL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField).offset(self.textField.margin);
        make.right.top.bottom.equalTo(self.textField);
    }];
}

#pragma mark Button
- (void)clearBtnClicked:(id)sender {
    self.textField.text = @"";
    [self textValueChanged:nil];
}

- (void)sendCheckNumBtnClicked:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(LCHomeCheckNumCellCheckBtnClick:)]) {
        [_delegate LCHomeCheckNumCellCheckBtnClick:self];
    }
    
}

- (void)updateSendCodeButton {
    __weak typeof(self) weakSelf = self;
    _isSendCheckBtnCanClick = NO;
    self.sendCheckNumBtn.userInteractionEnabled = NO;
    if (kiOS10Later) {
        __block int count = 60;
        CGSize size = [[NSString stringWithFormat:@"    %@s    ", @"60"] sizeWithAttributes:@{NSFontAttributeName:Fit_Font(17)}];
        [weakSelf.sendCheckNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
        }];
        
        NSString *timeStr = [NSString stringWithFormat:@"    %ds    ", count];
        [weakSelf.sendCheckNumBtn setTitle:timeStr forState:UIControlStateNormal];
        count--;
        
        if (@available(iOS 10.0, *)) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (count!=0) {
                    NSString *timeStr = [NSString stringWithFormat:@"    %ds    ", count];
                    [weakSelf.sendCheckNumBtn setTitle:timeStr forState:UIControlStateNormal];
                }else {
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
//                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(LCHomeCheckNumCellCheckBtnInvalid)]) {
//                        [weakSelf.delegate LCHomeCheckNumCellCheckBtnInvalid];
//                    }
                    
                    // 按钮复原
                    weakSelf.sendCheckNumBtn.userInteractionEnabled = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        NSString *timeStr = [NSString stringWithFormat:@"    获取    "];
                        [weakSelf.sendCheckNumBtn setTitle:timeStr  forState:UIControlStateNormal];
                        CGSize size = [timeStr sizeWithAttributes:@{NSFontAttributeName:Fit_Font(17)}];
                        
                        [UIView animateWithDuration:2.0 animations:^{
                            [weakSelf.sendCheckNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
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
        CGSize size = [[NSString stringWithFormat:@"    %@s    ", @"60"] sizeWithAttributes:@{NSFontAttributeName:Fit_Font(17)}];
        [weakSelf.sendCheckNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
        }];
        
        NSString *timeStr = [NSString stringWithFormat:@"    %ds    ", timeout];
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
                    NSString *timeStr = [NSString stringWithFormat:@"    获取    "];
                    [weakSelf.sendCheckNumBtn setTitle:timeStr  forState:UIControlStateNormal];
                    [weakSelf.sendCheckNumBtn.layer setBorderColor:[UIColor kBaseColor].CGColor];
                    CGSize size = [timeStr sizeWithAttributes:@{NSFontAttributeName:Fit_Font(17)}];
                    [UIView animateWithDuration:2.0 animations:^{
                        [weakSelf.sendCheckNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
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
                    NSString *timeStr = [NSString stringWithFormat:@"    %@s    ", strTime];
                    [weakSelf.sendCheckNumBtn setTitle:timeStr forState:UIControlStateNormal];
                    [UIView commitAnimations];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }
}

#pragma mark - textFieldMethod
- (void)editDidBegin:(id)sender {
    if (self.editDidBeginBlock) {
        self.editDidBeginBlock(self.textField.text);
    }
}

- (void)editDidEnd:(id)sender {
    if (self.editDidEndBlock) {
        self.editDidEndBlock(self.textField.text);
    }
}

- (void)textValueChanged:(id)sender {
//    if (_textField.text.length > 6) {
//        _textField.text = [_textField.text substringWithRange:NSMakeRange(0, 6)];
//        return;
//    }
    // self.clearBtn.hidden = YES;
//    UITextField *field = (UITextField *)sender;
    
//    self.clearBtn.hidden = field.text.length <= 0 ? YES : NO;
    
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(self.textField.text);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setPlaceholder:(NSString *)phStr value:(NSString *)valueStr{
     self.placeHolderL.text = phStr;
    self.textField.text = valueStr;
}

- (void)clearTextField{
    _textField.text = @"";
}

- (void)btnRecover{
    __weak typeof(self) weakSelf = self;
    [_timer invalidate];
    weakSelf.timer = nil;
    // 按钮复原
    weakSelf.sendCheckNumBtn.userInteractionEnabled = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *timeStr = [NSString stringWithFormat:@"    获取    "];
        NSMutableAttributedString *timeAttrStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
        [timeAttrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor kBaseColor]} range:NSMakeRange(0, timeStr.length)];
        [weakSelf.sendCheckNumBtn setAttributedTitle:timeAttrStr forState:UIControlStateNormal];
        [weakSelf.sendCheckNumBtn.layer setBorderColor:[UIColor kBaseColor].CGColor];
        CGSize size = [@"    获取    " sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        [UIView animateWithDuration:2.0 animations:^{
            [weakSelf.sendCheckNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(size.width));
            }];
        }];
        
    });
}

@end
