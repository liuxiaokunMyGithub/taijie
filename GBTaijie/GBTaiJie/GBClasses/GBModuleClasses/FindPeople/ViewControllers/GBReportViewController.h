//
//  GBReportViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/11.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GBReportViewController : GBBaseViewController
/* 多选 */
@property (nonatomic, assign) BOOL isMutableSelect;
/* 举报类型 */
@property (nonatomic, copy) NSString *relatedType;
/* 举报类型id */
@property (nonatomic, copy) NSString *relatedId;
@end
