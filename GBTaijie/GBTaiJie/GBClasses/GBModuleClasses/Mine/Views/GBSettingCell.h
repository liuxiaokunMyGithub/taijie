//
//  GBSettingCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GBLIRLButton.h"
#import "XKTextField.h"

typedef NS_ENUM(NSInteger , CellType) {
    CellTypeDetailsLabel       =  0,
    CellTypeDetailsTextfield,
    CellTypeDetailsSwitch,
    CellTypeContentImageView,
    CellTypeIconImageView,
    CellTypeDetailsDatePicker,

};

@interface GBSettingCell : UITableViewCell

/* 是否显示明/密文按钮 */
@property (nonatomic, assign) BOOL showSecureTextButton;
/* title */
@property (strong , nonatomic) UILabel *titleLabel;
/* UISwitch */
@property (strong , nonatomic) UISwitch *setSwitch;
/* 箭头指示按钮 */
@property (strong , nonatomic) GBLIRLButton *indicateButton;
/* 内容 */
@property (strong , nonatomic) XKTextField *contentTextField;
/* 分割线 */
@property (nonatomic, strong) UIView *line;
/* 图片 */
@property (nonatomic, strong) UIImageView *contentImageView;
/** 消息数 */
@property (nonatomic, strong) UILabel *messageNumberLabel;

/* cell类型 */
@property (assign , nonatomic) CellType cellType;

// 标题左侧偏移量
@property (nonatomic, assign) CGFloat titleLeftMargin;
// 标题右侧偏移量
@property (nonatomic, assign) CGFloat titleRightMargin;
// 标题中心Y轴偏移量
@property (nonatomic, assign) CGFloat titleCenterYMargin;
@property (nonatomic, assign) CGFloat topMargin;
/* <#describe#> */
@property (nonatomic, assign) CGFloat indicateButtonWidth;

// 内容偏移量
@property (nonatomic, assign) CGFloat contentTextFieldLeftMargin;

// 半径
@property (nonatomic, assign) CGFloat contentImageViewRadius;

@property (nonatomic, assign) CGFloat maxWithdOffset;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString *valueStr);
@property (nonatomic,copy) void(^editDidBeginBlock)(NSString *valueStr);
@property (nonatomic,copy) void(^editDidEndBlock)(NSString *valueStr);

@property (nonatomic,copy) void(^switchChangedBlock)(BOOL isOpen);

@property (nonatomic, copy) void (^datePickerClickedBlock)(NSString *dateStr);

@end
