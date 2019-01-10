//
//  PositionSelectViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/820.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "JobModel.h"

typedef void(^SelectJobBlock)(JobModel *job);

@interface PositionSelectViewController : GBBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) SelectJobBlock selectBlock;
//@property (weak, nonatomic) IBOutlet UITableView *oneTableView;

@end
