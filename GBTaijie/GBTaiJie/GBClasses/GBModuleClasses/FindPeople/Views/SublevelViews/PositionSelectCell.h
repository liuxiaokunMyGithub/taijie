//
//  PositionSelectCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/820.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *centerNameL;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@property (nonatomic, assign) BOOL centerNameLHidden;

@end
