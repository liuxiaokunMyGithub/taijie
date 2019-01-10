//
//  LCHomeForgetPsdPhoneCell.h
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2017/1/17.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKTextField.h"

@interface LCHomeForgetPsdPhoneCell : UITableViewCell

+ (instancetype)cellForTableView:(UITableView *)tableView;
/* 是否显示明/密文按钮 */
@property (nonatomic, assign) BOOL showSecureTextButton;

@property (strong, nonatomic) XKTextField *textField;
@property (nonatomic, strong) UILabel *placeHolderL;
/* 分割线 */
@property (nonatomic, strong) UIView *line;
/* 偏移量 */
@property (nonatomic, assign) NSInteger textFieldMargin;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString *);
@property (nonatomic,copy) void(^editDidBeginBlock)(NSString *);
@property (nonatomic,copy) void(^editDidEndBlock)(NSString *);
@property (nonatomic, strong) UIImageView *imageV;

- (void)setPlaceholder:(NSString *)phStr value:(NSString *)valueStr;
- (void)setTitleStr:(NSString *)titleStr;

@end
