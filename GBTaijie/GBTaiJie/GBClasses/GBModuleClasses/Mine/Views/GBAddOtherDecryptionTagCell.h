//
//  GBAddOtherDecryptionTagCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/23.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBAddOtherDecryptionTagCell : UITableViewCell
/* <#describe#> */
@property (nonatomic, strong) UITextField *tagTextField;
@property (nonatomic, strong) UILabel *noticeLabel;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString *valueStr);
@property (nonatomic,copy) void(^editDidBeginBlock)(NSString *valueStr);
@property (nonatomic,copy) void(^editDidEndBlock)(NSString *valueStr);

@end
