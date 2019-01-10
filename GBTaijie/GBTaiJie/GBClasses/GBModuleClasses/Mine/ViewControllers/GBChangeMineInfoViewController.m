//
//  GBChangeMineInfoViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/5.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBChangeMineInfoViewController.h"

// Controllers


// ViewModels


// Models


// Views


@interface GBChangeMineInfoViewController ()<UITextFieldDelegate>

/* 改名 */
@property (strong , nonatomic) UITextField *changeTextField;

@end

@implementation GBChangeMineInfoViewController

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpInit];
    
    [self setUpField];
    
    [self setUpNav];
}

#pragma mark - initialize
- (void)setUpInit
{
    self.title = @"昵称";
    self.view.backgroundColor = [UIColor kBaseBackgroundColor];
}

#pragma mark - 更改昵称
- (void)setUpField {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame  = CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, 44);
    [self.view addSubview:bgView];
    
    _changeTextField = [[UITextField alloc] init];
    
    switch (self.changeInfoType) {
        case ChangeInfoTypeCommon:
        case ChangeInfoTypeEmail:
        {
            // 通用邮箱
            _changeTextField.placeholder = ValidStr(self.placeholderStr)?self.placeholderStr : @"请输入";
            
            if (self.changeInfoType == ChangeInfoTypeEmail) {
                _changeTextField.keyboardType = UIKeyboardTypeEmailAddress;
            }
        }
            break;
        case ChangeInfoTypeNick:
        {
            // 昵称
            _changeTextField.placeholder = ValidStr(self.userModel.nickName)?self.userModel.nickName : @"请输入1-7个字的昵称";
//            _changeTextField.delegate = self;
            //监听输入
            [self.changeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        }
            break;
        default:
            break;
    }
    
    _changeTextField.backgroundColor = [UIColor clearColor];
    _changeTextField.font = Fit_Font(14);
    _changeTextField.clearButtonMode = UITextFieldViewModeAlways;
    [_changeTextField becomeFirstResponder];
    
    _changeTextField.frame  = CGRectMake(GBMargin, 0, SCREEN_WIDTH - 2 * GBMargin, 40);
    [bgView addSubview:_changeTextField];
}

#pragma mark - 导航栏
- (void)setUpNav {
    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:[UIColor kBaseColor]];
    @GBWeakObj(self);
    [self.customNavBar setOnClickRightButton:^{
        @GBStrongObj(self);
        [self surebackItemClick];
    }];
}

#pragma mark - # Privater Methods
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.changeTextField) {
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


#pragma mark - 确定点击
- (void)surebackItemClick {
    NSDictionary *param;
    if (self.changeTextField.text.length <= 0) {
        return [UIView showHubWithTip:@"请输入更新信息"];
    }
    
    switch (self.changeInfoType) {
        case ChangeInfoTypeCommon:
        {
            // 通用类型
            self.saveBlock(self.changeTextField.text);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
            break;
        case ChangeInfoTypeEmail:
        {
            // 邮箱
            if ([GBAppHelper validationEmail:self.changeTextField.text]) {
                self.saveBlock(self.changeTextField.text);
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                return [UIView showHubWithTip:@"请输入正确的邮箱格式"];
            }
            return;
        }
            break;
        case ChangeInfoTypeNick:
        {
            // 昵称
            param = @{
                      @"nickName":self.changeTextField.text
                      };
            self.userModel.nickName = self.changeTextField.text;
            // 更新
            GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
            [mineVM loadRequestPersonalEditInfoUpdate:param];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [userManager saveCurrentUser:self.userModel];
                [UIView showHubWithTip:@"更新成功"];
                
                self.saveBlock(self.changeTextField.text);
                
                // 更新用户IM昵称信息
                [[IMManager sharedIMManager] updateIMUserInfo:self.changeTextField.text userFieldType:kJMSGUserFieldsNickname];
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
            break;
        default:
            break;
    }
    
    [self.changeTextField resignFirstResponder];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == self.changeTextField) {
//        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
//        if (range.length >= 1 && string.length == 0) {
//            return YES;
//        }
//        //so easy
//        else if (self.changeTextField.text.length > 7) {
//            if (self.changeInfoType == ChangeInfoTypeNick) {
//                self.changeTextField.text = [textField.text substringToIndex:7];
//                return NO;
//            }
//        }
//    }
//    return YES;
//}

@end
