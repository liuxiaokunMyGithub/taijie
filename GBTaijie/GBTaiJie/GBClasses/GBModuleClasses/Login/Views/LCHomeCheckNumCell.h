//
//  LCHomeCheckNumCell.h
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2017/1/18.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKTextField.h"

@class LCHomeCheckNumCell;

@protocol LCHomeCheckNumCellDelegate <NSObject>

- (void)LCHomeCheckNumCellCheckBtnClick:(LCHomeCheckNumCell *)cell;
//- (void)LCHomeCheckNumCellCheckBtnInvalid;

@end


@interface LCHomeCheckNumCell : UITableViewCell
/* 分割线 */
@property (nonatomic, strong) UIView *line;
/* 偏移量 */
@property (nonatomic, assign) NSInteger textFieldMargin;

@property (nonatomic, strong) UIButton *sendCheckNumBtn;

+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) UIImageView *imageV;

@property (strong, nonatomic) XKTextField *textField;
@property (nonatomic,copy) void(^textValueChangedBlock)(NSString *);
@property (nonatomic,copy) void(^editDidBeginBlock)(NSString *);
@property (nonatomic,copy) void(^editDidEndBlock)(NSString *);
- (void)setPlaceholder:(NSString *)phStr value:(NSString *)valueStr;
- (void)clearTextField;

@property (nonatomic, weak) id<LCHomeCheckNumCellDelegate> delegate;

@property (nonatomic, strong) UILabel *placeHolderL;

- (void)updateSendCodeButton;

@end
