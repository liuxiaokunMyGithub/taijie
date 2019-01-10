//
//  SearchCompanyBottomView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/825.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClearBtnBlock) (void);

@interface SearchCompanyBottomView : UIView

@property (nonatomic, copy) ClearBtnBlock clearBlock;

@end
