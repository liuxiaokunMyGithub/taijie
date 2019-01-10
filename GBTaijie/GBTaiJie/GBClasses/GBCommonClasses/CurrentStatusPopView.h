//
//  CurrentStatusPopView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/821.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectStatusBlock)(NSString *status);

@interface CurrentStatusPopView : UIView

@property (nonatomic, copy) NSString *selectedStatus;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy)SelectStatusBlock selectBlock;

- (instancetype)initWithStatusArray:(NSArray *)status andSelectedStatus:(NSString *)selectedStatus;

- (void)show;

- (void)dismiss;


@end
