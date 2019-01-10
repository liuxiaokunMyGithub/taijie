//
//  GBPastExperienceCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/7.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPastExperienceModel.h"
#import "FSTextView.h"

@interface GBPastExperienceCell : UITableViewCell
/* 经验 */
@property (nonatomic, strong) GBPastExperienceModel *pastExperienceModel;

/* 输入公司 */
@property (nonatomic, strong) UITextField *companyTextField;

/* 输入职位 */
@property (nonatomic, strong) UITextField *positionTextField;

/* 评价 */
//@property (nonatomic, strong) FSTextView *wordTextView;

/* 输入字数 */
@property (nonatomic, strong) UILabel *nubLabel;

@property (nonatomic, copy) void (^datePickerClickedBlock)(NSString *dateStr,NSString *timeType);

/* 编辑（可输入） */
@property (nonatomic, assign) BOOL isEdit;

@end
