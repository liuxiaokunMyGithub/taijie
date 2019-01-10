//
//  TransactionListModel.h
//  GBTaiJie
//
//  Created by 刘小坤  on 2018/7/3.
//  Copyright © 2018年 刘小坤. All rights reserved.
//


@interface TransactionListModel : GBBaseModel
/** 交易数 */
@property (nonatomic, assign) float amount;
/** 时间 */
@property (nonatomic, strong) NSString * createTime;
/** 记录状态 */
@property (nonatomic, strong) NSString * recerdStatus;
/** 记录类型 */
@property (nonatomic, strong) NSString * recerdType;
/** 记录名称 */
@property (nonatomic, strong) NSString * recerdTypeName;
/** 标题 */
@property (nonatomic, strong) NSString * title;

@end
