//
//  GBVerificationCodeCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/12.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNValidationCodeView.h"

@class GBVerificationCodeCell;

@protocol GBVerificationCodeCellDelegate <NSObject>

- (void)GBVerificationCodeCellCheckBtnClick:(GBVerificationCodeCell *)cell;

//- (void)LCHomeCheckNumCellCheckBtnInvalid;

@end


@interface GBVerificationCodeCell : UITableViewCell
/* 分割线 */
@property (nonatomic, strong) UIView *line;
/* 偏移量 */
@property (nonatomic, assign) NSInteger textFieldMargin;

@property (nonatomic, strong) UIButton *sendCheckNumBtn;

+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) UIImageView *imageV;
/* <#describe#> */
@property (nonatomic, strong) NNValidationCodeView *validationCodeView;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString *);
@property (nonatomic,copy) void(^editDidBeginBlock)(NSString *);
@property (nonatomic,copy) void(^editDidEndBlock)(NSString *);
- (void)setPlaceholder:(NSString *)phStr value:(NSString *)valueStr;
- (void)clearTextField;

@property (nonatomic, weak) id<GBVerificationCodeCellDelegate> delegate;

@property (nonatomic, strong) UILabel *placeHolderL;
- (void)updateSendCodeButton;

@end
