//
//  GBUniversitiesOverseasItemCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//  海外院校

#import "GBUniversitiesOverseasItemCell.h"

@implementation GBUniversitiesOverseasItemCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel1];
        [self.contentView addSubview:self.titleLabel2];
        [self.contentView addSubview:self.titleLabel3];
        
        [self.contentView addSubview:self.lineView1];
        [self.contentView addSubview:self.lineView2];
        [self.contentView addSubview:self.lineView3];

        [self.contentView addSubview:self.valueTextField1];
        [self.contentView addSubview:self.valueTextField2];
        [self.contentView addSubview:self.valueTextField3];
    }
    
    return self;
}

#pragma mark - # textFieldMethod
- (void)editDidBegin:(id)sender {
    if (self.editDidBeginBlock) {
        if ([self.valueTextField1 isFirstResponder]) {
            self.editDidBeginBlock(self.valueTextField1.text);
        }
        if ([self.valueTextField2 isFirstResponder]) {
            self.editDidBeginBlock(self.valueTextField2.text);
        }
        if ([self.valueTextField3 isFirstResponder]) {
            self.editDidBeginBlock(self.valueTextField3.text);
        }
    }
}

- (void)editDidEnd:(id)sender {
    if ([self.valueTextField1 isFirstResponder]) {
        self.editDidEndBlock(self.valueTextField1.text);
    }
    if ([self.valueTextField2 isFirstResponder]) {
        self.editDidEndBlock(self.valueTextField2.text);
    }
    if ([self.valueTextField3 isFirstResponder]) {
        self.editDidEndBlock(self.valueTextField3.text);
    }
}

- (void)textValueChanged:(id)sender {
    if ([self.valueTextField1 isFirstResponder]) {
        self.textValueChangedBlock(self.valueTextField1.text);
    }
    if ([self.valueTextField2 isFirstResponder]) {
        self.textValueChangedBlock(self.valueTextField2.text);
    }
    if ([self.valueTextField3 isFirstResponder]) {
        self.textValueChangedBlock(self.valueTextField3.text);
    }
}

-  (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.height.equalTo(@56);
        make.top.equalTo(self.contentView);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.titleLabel1.mas_bottom);
    }];
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.height.equalTo(@56);
        make.top.equalTo(self.lineView1.mas_bottom);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.titleLabel2.mas_bottom);
    }];
    
    [self.titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.height.equalTo(@56);
        make.top.equalTo(self.titleLabel2.mas_bottom);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.titleLabel3.mas_bottom);
    }];
    
    [self.valueTextField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@56);
        make.top.equalTo(self.contentView);
    }];
    
    [self.valueTextField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@56);
        make.top.equalTo(self.lineView1.mas_bottom);
    }];
    
    [self.valueTextField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@56);
        make.top.equalTo(self.lineView2.mas_bottom);
    }];
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _lineView1;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _lineView2;
}

- (UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = [UIColor kSegmentateLineColor];
    }
    
    return _lineView3;
}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [UILabel createLabelWithText:@"国家" font:Fit_Font(14) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _titleLabel1;
}

- (UILabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [UILabel createLabelWithText:@"院校" font:Fit_Font(14) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _titleLabel2;
}

- (UILabel *)titleLabel3 {
    if (!_titleLabel3) {
        _titleLabel3 = [UILabel createLabelWithText:@"专业" font:Fit_Font(14) textColor:[UIColor kImportantTitleTextColor]];
    }
    
    return _titleLabel3;
}

- (XKTextField *)valueTextField1 {
    if (!_valueTextField1) {
        _valueTextField1 = [[XKTextField alloc] init];
        _valueTextField1.placeholder = @"请输入国家名称";
        _valueTextField1.textColor = [UIColor kImportantTitleTextColor];
        _valueTextField1.font = Fit_Font(16);
        _valueTextField1.textAlignment = NSTextAlignmentRight;

//        [_valueTextField1 addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
//        [_valueTextField1 addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
//        [_valueTextField1 addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    return _valueTextField1;
}

- (XKTextField *)valueTextField2 {
    if (!_valueTextField2) {
        _valueTextField2 = [[XKTextField alloc] init];
        _valueTextField2.placeholder = @"请输入院校名称";
        _valueTextField2.textColor = [UIColor kImportantTitleTextColor];
        _valueTextField2.font = Fit_Font(16);
        _valueTextField2.textAlignment = NSTextAlignmentRight;

//        [_valueTextField2 addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
//        [_valueTextField2 addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
//        [_valueTextField2 addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    return _valueTextField2;
}

- (XKTextField *)valueTextField3 {
    if (!_valueTextField3) {
        _valueTextField3 = [[XKTextField alloc] init];
        _valueTextField3.placeholder = @"请输入院校专业";
        _valueTextField3.textColor = [UIColor kImportantTitleTextColor];
        _valueTextField3.font = Fit_Font(16);
        _valueTextField3.textAlignment = NSTextAlignmentRight;
//        [_valueTextField3 addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
//        [_valueTextField3 addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
//        [_valueTextField3 addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];

    }
    return _valueTextField3;
}

@end
