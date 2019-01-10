//
//  LCHomeForgetPsdPhoneCell.m
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2017/1/17.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import "LCHomeForgetPsdPhoneCell.h"
#import "XKTextField.h"

@interface LCHomeForgetPsdPhoneCell ()

@property (strong, nonatomic) UIButton *clearBtn;

@property (nonatomic, weak) UILabel *title;


@end

@implementation LCHomeForgetPsdPhoneCell

+ (instancetype)cellForTableView:(UITableView *)tableView{
    LCHomeForgetPsdPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}

- (void)setTitleStr:(NSString *)titleStr{
    self.title.text = titleStr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *title = [UILabel new];
        self.title = title;
        title.text = @"手机号";
        [title setFont:[UIFont systemFontOfSize:15]];
        title.frame = CGRectMake(50*0.5, 0, SCREEN_WIDTH-100*0.5, 15);
        title.textColor = [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        self.backgroundColor = [UIColor clearColor];
        
        // 输入框
        if(!_textField){
            _textField = [XKTextField new];
            _textField.font = Fit_Font(17);
            [_textField addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
            [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
            [_textField addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [self.contentView addSubview:_textField];
            _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
    
    [self.placeHolderL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField).offset(self.textField.margin);
        make.right.top.bottom.equalTo(self.textField);
    }];
    
    // 显示明密文切换按钮
    if (self.showSecureTextButton) {
        self.textField.secureTextEntry = YES;
        UIButton *lookBtton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [lookBtton setImage:[UIImage imageNamed:@"login_lock_not"] forState:UIControlStateNormal];
        [lookBtton addTarget:self action:@selector(lookPassWordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.textField.rightView = lookBtton;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
    }
}

#pragma mark Button
- (void)clearBtnClicked:(id)sender {
    self.textField.text = @"";
    [self textValueChanged:nil];
}

#pragma mark - 点击事件
#pragma mark Button
- (void)lookPassWordBtnClicked:(UIButton *)lookButton {
    lookButton.selected = !lookButton.selected;
    if (lookButton.selected) {
        self.textField.secureTextEntry = NO;
        [lookButton setImage:[UIImage imageNamed:@"login_lock"] forState:UIControlStateNormal];
        
    }else {
        self.textField.secureTextEntry = YES;
        [lookButton setImage:[UIImage imageNamed:@"login_lock_not"] forState:UIControlStateNormal];
    }
}

#pragma mark - textFieldMethod
- (void)editDidBegin:(id)sender {
    //    self.lineView.backgroundColor = [UIColor whiteColor];
    //    self.clearBtn.hidden = YES;
    UITextField *field = (UITextField *)sender;
    self.clearBtn.hidden = field.text.length <= 0 ? YES : NO;
    if (self.editDidBeginBlock) {
        self.editDidBeginBlock(self.textField.text);
    }
}

- (void)editDidEnd:(id)sender {
    self.clearBtn.hidden = YES;
    
    if (self.editDidEndBlock) {
        self.editDidEndBlock(self.textField.text);
    }
}

- (void)textValueChanged:(id)sender {
    //    self.clearBtn.hidden = YES;
    UITextField *field = (UITextField *)sender;
    self.clearBtn.hidden = field.text.length <= 0 ? YES : NO;
    
    //    if (_textField.text.length > 11) {
    //        _textField.text = [_textField.text substringWithRange:NSMakeRange(0, 11)];
    //        return;
    //    }
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
//    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:phStr? phStr: @"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x999999"], NSFontAttributeName:PFR14Font}];
    self.textField.text = valueStr;
    
}

@end
