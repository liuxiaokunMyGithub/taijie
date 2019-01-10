//
//  TimeSelectViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/825.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

typedef void(^TimeSelectBlock) (NSString *minTime, NSString *maxTime);

@interface TimeSelectViewController : GBBaseViewController

@property (nonatomic, copy) TimeSelectBlock timeSelectBlock;

@end
