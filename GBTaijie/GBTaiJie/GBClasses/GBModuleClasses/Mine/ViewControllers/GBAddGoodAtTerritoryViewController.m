//
//  GBAddGoodAtTerritoryViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/23.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBAddGoodAtTerritoryViewController.h"

// Controllers


// ViewModels


// Models

// Views
#import "GBAddSkillTagView.h"

#define kMaxLableLength 14  //限制7个字符

@interface GBAddGoodAtTerritoryViewController ()<UITextFieldDelegate>
/*  */
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIView *topView;
/* <#describe#> */
/* <#describe#> */
@property (nonatomic, strong) UITextField *tagTextField;
/* <#describe#> */
@property (nonatomic, strong) UILabel *skillTitleLabel;
/* <#describe#> */
@property (nonatomic, strong) UIView *lineView;
/* <#describe#> */
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *noticeLabel;
/* <#describe#> */
@property (nonatomic, copy) NSString *currentTagStr;

@end

@implementation GBAddGoodAtTerritoryViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopView];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.subTitleLabel];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.skillTitleLabel];
    [self.view addSubview:self.tagTextField];
    [self.view addSubview:self.lineView];
    
    
    [self addMasonry];
    
    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:[UIColor kBaseColor]];
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
        //
        NSMutableArray *skills = [NSMutableArray array];
        
        if (self.tags.count) {
            for (NSString *skill in self.tags) {
                NSDictionary *param = @{
                                        @"skillName":skill
                                        };
                [skills addObject:param];
            }
            
            GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
            [mineVM loadRequestPersonalEditInfoUpdate:@{@"skills":skills}];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [UIView showHubWithTip:@"保存成功"];
                self.addSkillsBlock(self.tags);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else {
            return [UIView showHubWithTip:@"请选择擅长领域"];
        }
    }];
    
    //监听输入
    [self.tagTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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

#pragma mark - # Setup Methods
- (void)addMasonry {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(GBMargin);
        make.width.equalTo(@([DCSpeedy dc_calculateTextSizeWithText:@"擅长领域" WithTextFont:Fit_Font(28) WithMaxW:SCREEN_WIDTH]));
        make.top.equalTo(@(SafeAreaTopHeight +GBMargin));
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(3);
        make.bottom.equalTo(self.titleLabel).offset(-3);
        make.right.equalTo(self.view).offset(-GBMargin);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(GBMargin);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.height.equalTo(@180);
        make.right.equalTo(self.view).offset(-GBMargin);
    }];
    
    [self.skillTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(GBMargin);
        make.top.equalTo(self.topView.mas_bottom).offset(8);
        make.width.equalTo(@80);
    }];
    
    [self.tagTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skillTitleLabel.mas_right).offset(3);
        make.top.equalTo(self.topView.mas_bottom).offset(8);
        make.right.equalTo(self.addButton.mas_left).offset(-3);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-GBMargin);
        make.centerY.equalTo(self.skillTitleLabel);
        make.width.height.equalTo(@44);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skillTitleLabel.mas_right).offset(3);
        make.top.equalTo(self.tagTextField.mas_bottom).offset(8);
        make.right.equalTo(self.view).offset(-GBMargin);
        make.height.equalTo(@0.5);
    }];
}
- (void)setTopView {
    
    CGFloat MaxWidth = SCREEN_WIDTH - GBMargin*2;
    
    // 清除以前的子控件
    for (UIView *con in self.topView.subviews) {
        [con removeFromSuperview];
    }
    
    CGFloat itemX = 0;
    CGFloat itemY = 10;
    for (NSInteger i = 0; i < self.tags.count; i++) {
        NSString *skill = [self.tags objectAtIndex:i];
        CGFloat itemW = [DCSpeedy dc_calculateTextSizeWithText:skill WithTextFont:Fit_Font(14) WithMaxW:SCREEN_WIDTH].width+38;
        
        
        if (itemX + itemW + 10 >= MaxWidth) {
            itemX = 0;
            itemY += 32 + GBMargin/2;
        }
        
        GBAddSkillTagView *tagSkillView = [[GBAddSkillTagView alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, 32) title:skill];
        tagSkillView.deleteBtn.tag = i;
        [tagSkillView.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:tagSkillView];
        
        itemX += itemW + 10;
    }
    
    UILabel *countL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 10, 60, 12)];
    countL.font = Fit_Font(14);
    countL.textAlignment = NSTextAlignmentRight;
    countL.textColor = [UIColor kAssistInfoTextColor];
    self.noticeLabel = countL;
    
    countL.text = [NSString stringWithFormat:@"(%zd/5)", self.tags.count];
    [self.topView addSubview:countL];
    
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView);
        make.width.equalTo(@180);
        make.bottom.equalTo(self.topView);
    }];
    
}

#pragma mark - # Event Response
- (void)deleteBtnClick:(UIButton *)btn {
    [self.tags removeObjectAtIndex:btn.tag];
    [self setTopView];
}

- (void)addSkillAction {
    if (self.tags.count >= 5) {
        return [UIView showHubWithTip:@"最多添加5项"];
    }
    
    [self.tags addObject:self.tagTextField.text];
    self.tagTextField.text = @"";
    
    [self setTopView];
}



#pragma mark - # Delegate


#pragma mark - # Getters and Setters
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    }
    
    return _topView;
}

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (UITextField *)tagTextField {
    if (!_tagTextField) {
        _tagTextField = [[UITextField alloc] init];
        _tagTextField.placeholder = @"请输入";
        _tagTextField.delegate = self;
        _tagTextField.textColor = [UIColor kAssistInfoTextColor];
        _tagTextField.font = Fit_Font(14);
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

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton createButtonWithFrame:CGRectZero text:@"添加" font:Fit_M_Font((16)) textColor:[UIColor kBaseColor] backGroundColor:[UIColor whiteColor]];
        [_addButton addTarget:self action:@selector(addSkillAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _addButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"擅长领域";
        _titleLabel.textColor = [UIColor kImportantTitleTextColor];
        _titleLabel.font = Fit_Font(28);
    }
    
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"每个领域限7个字，最多创建5个";
        _subTitleLabel.textColor = [UIColor kAssistInfoTextColor];
        _subTitleLabel.font = Fit_L_Font(12);
    }
    
    return _subTitleLabel;
}

- (UILabel *)skillTitleLabel {
    if (!_skillTitleLabel) {
        _skillTitleLabel = [[UILabel alloc] init];
        _skillTitleLabel.text = @"技能名称";
        _skillTitleLabel.textColor = [UIColor kImportantTitleTextColor];
        _skillTitleLabel.font = Fit_Font(16);
    }
    
    return _skillTitleLabel;
}


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
