//
//  GBUniversitiesOverseasItemCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/9/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKTextField.h"

@interface GBUniversitiesOverseasItemCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel1;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UILabel *titleLabel3;

@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, strong) UIView *lineView3;


@property (nonatomic, strong) XKTextField *valueTextField1;
@property (nonatomic, strong) XKTextField *valueTextField2;
@property (nonatomic, strong) XKTextField *valueTextField3;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString *valueStr);
@property (nonatomic,copy) void(^editDidBeginBlock)(NSString *valueStr);
@property (nonatomic,copy) void(^editDidEndBlock)(NSString *valueStr);

@end
