//
//	GBBalanceModel.h
//
//	Create by 小坤 刘 on 3/7/2018
//	Copyright © 2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBBalanceModel : GBBaseModel
/** 收益 */
@property (nonatomic, assign) float currentTotalEarning;
/** 安卓余额 */
@property (nonatomic, assign) NSInteger leftBalance;
/** 台阶币余额 */
@property (nonatomic, assign) NSInteger leftToken;
/** (暂时无用) */
@property (nonatomic, assign) NSInteger totalBalance;
@property (nonatomic, assign) NSInteger totalEarning;
@property (nonatomic, assign) NSInteger totalToken;
@property (nonatomic, assign) NSInteger userId;

@end
