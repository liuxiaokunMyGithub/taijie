//
//  GBSettingCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//


#import "GBSettingCell.h"

@interface GBSettingCell ()
/* 日期上方工具条 */
@property(nonatomic,strong) UIToolbar* textFieldToolbar;
/* 日期DatePicker */
@property(nonatomic,strong) UIDatePicker* dataPicker;

@end

@implementation GBSettingCell

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.cellType == CellTypeContentImageView || self.cellType == CellTypeIconImageView) {
        [self.contentView addSubview:self.contentImageView];
        [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(GBMargin);
            if (self.cellType == CellTypeContentImageView) {
                make.bottom.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(self.topMargin ? self.topMargin : 0);
                make.right.equalTo(self.contentView).offset(-GBMargin);
            }else {
                if (!self.contentImageViewRadius) {
                make.size.mas_equalTo(CGSizeMake(self.contentView.height-8, self.contentView.height-8));
                }else {
               make.size.mas_equalTo(CGSizeMake(self.contentImageViewRadius*2, self.contentImageViewRadius*2));
                }
                if (self.topMargin) {
                make.top.equalTo(self.contentView).offset(self.topMargin);
                }else {
                    make.centerY.mas_equalTo(self.titleLabel);
                }
            }
        }];
                
        if (self.cellType == CellTypeIconImageView) {
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset((self.contentImageViewRadius ? self.contentImageViewRadius *2 +5 + GBMargin : self.contentView.height-8 + 5));
                make.top.mas_equalTo(self.contentView.mas_top);
                [make.right.mas_equalTo(self.contentView)setOffset:(self.titleRightMargin ? self.titleRightMargin :-GBMargin)];
            }];
            
            // 是icon则圆形化，设置indicateButton
            [self.contentView addSubview:self.indicateButton];
            [self.indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
                [make.right.mas_equalTo(self.contentView)setOffset:-GBMargin];
                make.size.mas_equalTo(CGSizeMake(self.indicateButtonWidth ? self.indicateButtonWidth : 15, self.height));
                make.centerY.mas_equalTo(self.contentView);
            }];
            if (!self.contentImageViewRadius) {
                GBViewRadius(self.contentImageView, (self.contentView.height -8)/2);
            }else {
                GBViewRadius(self.contentImageView, self.contentImageViewRadius);
            }
            
            [self.contentTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                if (!self.contentTextFieldLeftMargin) {
                    make.right.mas_equalTo(self.indicateButton.hidden == YES ?self.contentView : self.indicateButton.mas_left).offset(self.indicateButton.hidden == YES ? -GBMargin : -8);
                }
                make.left.mas_equalTo(self.contentView).offset(self.titleLabel.hidden == YES ? GBMargin : self.contentTextFieldLeftMargin != 0 ? self.contentTextFieldLeftMargin : 120);
                make.height.mas_equalTo(self.titleLabel);
                make.top.mas_equalTo(self.titleLabel);
                
            }];
            
        }else {
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        

        return;
    }
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self.contentView)setOffset:self.titleLeftMargin != 0 ? self.titleLeftMargin : GBMargin];
        make.top.mas_equalTo(self.contentView.mas_top);
        //        [make.centerY.mas_equalTo(self.contentView)setOffset:self.titleCenterYMargin != 0?self.titleCenterYMargin:0];
        [make.right.mas_equalTo(self.contentView)setOffset:(self.titleRightMargin ? self.titleRightMargin :-GBMargin)];
        //        make.height.mas_equalTo(self.contentView);
        //        make.bottom.mas_equalTo(self.contentView);
    }];
    
    if (self.cellType == CellTypeDetailsLabel || self.cellType == CellTypeDetailsTextfield || self.cellType == CellTypeDetailsDatePicker) {
        // !!!:如果详情为Label样式，设置textField为不可编辑
        self.contentTextField.userInteractionEnabled = self.cellType == CellTypeDetailsLabel ? NO : YES;
        
        [self.indicateButton mas_updateConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(self.contentView)setOffset:-GBMargin];
            make.size.mas_equalTo(CGSizeMake(self.indicateButtonWidth ? self.indicateButtonWidth : 15, self.height));
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.contentTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            if (!self.contentTextFieldLeftMargin) {
                make.right.mas_equalTo(self.indicateButton.hidden == YES ?self.contentView : self.indicateButton.mas_left).offset(self.indicateButton.hidden == YES ? -GBMargin : -8);
            }
            make.left.mas_equalTo(self.contentView).offset(self.titleLabel.hidden == YES ? GBMargin : self.contentTextFieldLeftMargin != 0 ? self.contentTextFieldLeftMargin : 120);
            make.height.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(self.titleLabel);
            
        }];
    }else if (self.cellType == CellTypeDetailsSwitch){
        [self.contentView addSubview:self.setSwitch];
        
        [self.setSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(self.contentView)setOffset:-GBMargin/2];
            make.size.mas_equalTo(CGSizeMake(60, 35));
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    if (self.cellType == CellTypeDetailsDatePicker) {
        //设置文本输入框的输入辅助视图为自定义的视图
        self.contentTextField.inputAccessoryView = self.textFieldToolbar;
        //设置文本输入框的输入视图为自定义的dataPicker;
        self.contentTextField.inputView = self.dataPicker;
    }
    
    // 显示明密文切换按钮
    if (self.showSecureTextButton) {
        self.contentTextField.secureTextEntry = YES;
        UIButton *lookBtton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [lookBtton setImage:[UIImage imageNamed:@"login_lock_not"] forState:UIControlStateNormal];
        [lookBtton addTarget:self action:@selector(lookPassWordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.contentTextField.rightView = lookBtton;
        self.contentTextField.rightViewMode = UITextFieldViewModeAlways;
    }
}

- (void)setupSubView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.cellType == CellTypeContentImageView || self.cellType == CellTypeIconImageView) {
        return;
    }
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self.contentView)setOffset:self.titleLeftMargin != 0 ? self.titleLeftMargin : GBMargin];
        make.top.mas_equalTo(self.contentView.mas_top);

        [make.right.mas_equalTo(self.contentView)setOffset:(self.titleRightMargin ? self.titleRightMargin :-GBMargin)];
    }];
    
    if (self.cellType == CellTypeDetailsLabel || self.cellType == CellTypeDetailsTextfield || self.cellType == CellTypeDetailsDatePicker) {
        [self.contentView addSubview:self.indicateButton];
        [self.contentView addSubview:self.contentTextField];
        // !!!:如果详情为Label样式，设置textField为不可编辑
        self.contentTextField.userInteractionEnabled = self.cellType == CellTypeDetailsLabel ? NO : YES;
        
        [self.indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(self.contentView)setOffset:-GBMargin];
            make.size.mas_equalTo(CGSizeMake(self.indicateButtonWidth ? self.indicateButtonWidth : 15, self.height));
            make.centerY.mas_equalTo(self.contentView);
        }];
    }else if (self.cellType == CellTypeDetailsSwitch){
        [self.contentView addSubview:self.setSwitch];
        [self.setSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(self.contentView)setOffset:-GBMargin/2];
            make.size.mas_equalTo(CGSizeMake(60, 35));
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
        
    }];
    
    if (self.cellType == CellTypeDetailsDatePicker) {
        //设置文本输入框的输入辅助视图为自定义的视图
        self.contentTextField.inputAccessoryView = self.textFieldToolbar;
        //设置文本输入框的输入视图为自定义的dataPicker;
        self.contentTextField.inputView = self.dataPicker;
    }
}

#pragma mark - 点击事件
#pragma mark Button
- (void)lookPassWordBtnClicked:(UIButton *)lookButton {
    lookButton.selected = !lookButton.selected;
    if (lookButton.selected) {
        self.contentTextField.secureTextEntry = NO;
        [lookButton setImage:[UIImage imageNamed:@"login_lock"] forState:UIControlStateNormal];
        
    }else {
        self.contentTextField.secureTextEntry = YES;
        [lookButton setImage:[UIImage imageNamed:@"login_lock_not"] forState:UIControlStateNormal];
    }
}

- (void)switchAction:(UISwitch *)sender {
    NSLog(@"%@", sender.isOn ? @"ON" : @"OFF");
    !_switchChangedBlock ? : _switchChangedBlock(sender.isOn);
}

- (void)cancelAction {
    [_contentTextField resignFirstResponder];
}

- (void)finishBirthChange {
    NSDate* choosedDate = self.dataPicker.date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init]; //设置日期格式
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [formatter stringFromDate:choosedDate];
    
    if (self.datePickerClickedBlock) {
        self.datePickerClickedBlock(dateStr);
    }
}

#pragma mark - # textFieldMethod
- (void)editDidBegin:(id)sender {
    if (self.editDidBeginBlock) {
        self.editDidBeginBlock(self.contentTextField.text);
    }
}

- (void)editDidEnd:(id)sender {
    if (self.editDidEndBlock) {
        self.editDidEndBlock(self.contentTextField.text);
    }
}

- (void)textValueChanged:(id)sender {
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(self.contentTextField.text);
    }
}

#pragma mark - # Getters and Setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel.font = Fit_Font(16);
        _titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - GBMargin*2;
    }
    
    return _titleLabel;
}

- (XKTextField *)contentTextField {
    if (!_contentTextField) {
        _contentTextField = [[XKTextField alloc] init];
        _contentTextField.margin = 1;
        _contentTextField.textColor = [UIColor kAssistInfoTextColor];
        _contentTextField.font = Fit_Font(14);
        [_contentTextField addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [_contentTextField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [_contentTextField addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        _contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return _contentTextField;
}

- (UISwitch *)setSwitch {
    if (!_setSwitch) {
        _setSwitch = [[UISwitch alloc]init];
        [_setSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        // 在oneSwitch开启的状态显示的颜色 默认是blueColor
        _setSwitch.onTintColor = [UIColor kBaseColor];
        // 设置关闭状态的颜色
        //    _setSwitch.tintColor = [UIColor lightGrayColor];
        // 设置开关上左右滑动的小圆点的颜色
        //    _setSwitch.thumbTintColor = [UIColor whiteColor];
    }
    
    return _setSwitch;
}

- (GBLIRLButton *)indicateButton {
    if (!_indicateButton) {
        _indicateButton = [GBLIRLButton buttonWithType:UIButtonTypeCustom];
        [_indicateButton setImage:[UIImage imageNamed:@"icon_right_more_light"] forState:UIControlStateNormal];
        _indicateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_indicateButton setTitleColor:[UIColor kBaseColor] forState:UIControlStateNormal];
        _indicateButton.titleLabel.font = Fit_Font(14);
        _indicateButton.userInteractionEnabled = NO;
    }
    
    return _indicateButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor kSegmentateLineColor];
    }
    return _line;
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.userInteractionEnabled = NO;
    }
    
    return _contentImageView;
}

- (UIDatePicker *)dataPicker{
    if (!_dataPicker) {
        
        _dataPicker = [[UIDatePicker alloc]init];
        _dataPicker.backgroundColor = [UIColor whiteColor];
        //设置显示模式，只显示日期
        _dataPicker.datePickerMode = UIDatePickerModeDate;
        //本地化
        _dataPicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        NSDate *  timeDate=[NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        
        NSDate *minDate = [fmt dateFromString:@"1965-1-1"];
        //设置日期最大及最小值
        _dataPicker.maximumDate = timeDate;
        _dataPicker.minimumDate = minDate;
    }
    return _dataPicker;
}

- (UIView *)textFieldToolbar {
    
    if (!_textFieldToolbar) {
        
        _textFieldToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _textFieldToolbar.barTintColor = [UIColor whiteColor];
        //设置按钮
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)] ;
        [cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor kAssistInfoTextColor]} forState:UIControlStateNormal];
        
        UIBarButtonItem *fixSpaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishBirthChange)];
        [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor kBaseColor]} forState:UIControlStateNormal];
        _textFieldToolbar.items = @[cancelBtn,fixSpaceBtn,doneBtn];
    }
    return _textFieldToolbar;
}



@end
