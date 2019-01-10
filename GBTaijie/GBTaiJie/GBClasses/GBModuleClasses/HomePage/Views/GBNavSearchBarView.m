//
//  GBNavSearchBarView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/14.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBNavSearchBarView.h"

@interface GBNavSearchBarView ()

@end

@implementation GBNavSearchBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUpUI];
        
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
    _typeBtn = [GBLLRIButton buttonWithType:UIButtonTypeCustom];
    [_typeBtn setTitle:@"公司" forState:UIControlStateNormal];
    [_typeBtn setTitleColor:[UIColor kImportantTitleTextColor] forState:UIControlStateNormal];
    _typeBtn.titleLabel.font = Fit_Font(16);
    [_typeBtn setImage:[UIImage imageNamed:@"Triangle3"] forState:UIControlStateNormal];
    [_typeBtn addTarget:self action:@selector(filtrateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _placeholdLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _placeholdLabel.font = Fit_L_Font(14);
    _placeholdLabel.text = @"公司、职位";
    _placeholdLabel.textColor = [UIColor kAssistInfoTextColor];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor colorWithHexString:@"#979797"];
    
    _searchImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchImageBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    //    _searchImageBtn.backgroundColor = [UIColor redColor];
    _searchImageBtn.userInteractionEnabled = NO;
    
    [self addSubview:_typeBtn];
    [self addSubview:_line];
    [self addSubview:_placeholdLabel];
    [self addSubview:_searchImageBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClick)];
    [self addGestureRecognizer:tap];
    GBViewRadius(self, 2);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.searchBarViewType == SearchBarViewTypeFiltrate) {
        self.searchImageBtn.hidden = YES;

        [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.left.equalTo(self)setOffset:GBMargin/2];
            make.top.equalTo(self);
            make.height.equalTo(self);
            make.width.equalTo(@45);
            
        }];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeBtn.mas_right).offset(8);
            make.centerY.equalTo(self.typeBtn);
            make.height.equalTo(@(self.height * 0.65));
            make.width.equalTo(@1);
        }];
        
        [_placeholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.line.mas_right).offset(8);
            make.right.equalTo(self).offset(-0);
            make.top.equalTo(self);
            make.height.equalTo(self);
        }];
        
        [_searchImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.equalTo(self)setOffset:-8];
            make.top.equalTo(self);
            make.height.equalTo(self);
            make.width.equalTo(@20);
        }];
        
       
        
        
    }else {
        self.typeBtn.hidden = YES;
        self.line.hidden = YES;
        
        [_searchImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.left.equalTo(self)setOffset:0];
            make.top.equalTo(self);
            make.height.equalTo(self);
            make.width.equalTo(@35);
            
        }];
        
        [_placeholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchImageBtn.mas_right).offset(0);
            make.right.equalTo(self).offset(-GBMargin/2);
            make.top.equalTo(self);
            make.height.equalTo(self);
        }];
        
        

    }
}

#pragma mark - Intial
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma mark - 类型选择
- (void)filtrateButtonClick
{
    !_filtrateButtonClickBlock ?: _filtrateButtonClickBlock();
}

// 搜索
- (void)searchClick {
    !self.serchBarDidClickBlock ? : self.serchBarDidClickBlock();
}

@end
