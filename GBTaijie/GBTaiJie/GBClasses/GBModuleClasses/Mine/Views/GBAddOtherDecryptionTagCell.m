//
//  GBAddOtherDecryptionTagCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/23.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBAddOtherDecryptionTagCell.h"
@interface GBAddOtherDecryptionTagCell ()
/* <#describe#> */
@property (nonatomic, strong) UILabel *titleLabel;


/* <#describe#> */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation GBAddOtherDecryptionTagCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tagTextField];
    [self.contentView addSubview:self.noticeLabel];
    [self.contentView addSubview:self.lineView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //监听输入
    [self.tagTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(GBMargin));
        make.top.equalTo(self.contentView);
        make.width.equalTo(@120);
    }];
    
    [self.tagTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(3);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.noticeLabel.mas_left).offset(3);
    }];
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.top.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(3);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - # Privater Methods
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.tagTextField) {
        if (textField.text.length > 7) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:7];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == self.tagTextField) {
//        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
//        if (range.length >= 1 && string.length == 0) {
//            return YES;
//        }
//        //so easy
//        else if (self.tagTextField.text.length >= 14) {
//                self.tagTextField.text = [textField.text substringToIndex:14];
//                return NO;
//        }
//    }
//    return YES;
//}

#pragma mark - # textFieldMethod
- (void)editDidBegin:(id)sender {
    if (self.editDidBeginBlock) {
        self.editDidBeginBlock(self.tagTextField.text);
    }
}

- (void)editDidEnd:(id)sender {
    if (self.editDidEndBlock) {
        self.editDidEndBlock(self.tagTextField.text);
    }
}

- (void)textValueChanged:(id)sender {
    self.noticeLabel.text = GBNSStringFormat(@"(%zu/7)",self.tagTextField.text.length);
    
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(self.tagTextField.text);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel.font = Fit_Font(16);
        _titleLabel.text = @"其他解密方向";
    }
    
    return _titleLabel;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] init];
        _noticeLabel.textColor = [UIColor kAssistInfoTextColor];
        _noticeLabel.font = Fit_Font(16);
        _noticeLabel.text = @"(0/7)";
    }
    
    return _noticeLabel;
}

- (UITextField *)tagTextField {
    if (!_tagTextField) {
        _tagTextField = [[UITextField alloc] init];
        _tagTextField.placeholder = @"请输入";
        _tagTextField.textColor = [UIColor kAssistInfoTextColor];
        _tagTextField.font = Fit_Font(14);
        [_tagTextField addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [_tagTextField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [_tagTextField addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        _tagTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return _tagTextField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _lineView;
}

@end
