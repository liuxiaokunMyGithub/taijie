//
//  ExpectedIndustryRightCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/829.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpectedIndustryRightCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV;

@property (nonatomic, assign) NSInteger isSelect;

@end
