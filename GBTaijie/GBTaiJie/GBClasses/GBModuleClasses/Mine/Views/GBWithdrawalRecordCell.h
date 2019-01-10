//
//  GBWithdrawalRecordCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/6.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBWithdrawalRecordModel.h"

@interface GBWithdrawalRecordCell : UITableViewCell

/* <#describe#> */
@property (nonatomic, strong) GBWithdrawalRecordModel *withdrawalRecordModel;

- (void)setupTitleStr:(NSArray *)titles;

@end
