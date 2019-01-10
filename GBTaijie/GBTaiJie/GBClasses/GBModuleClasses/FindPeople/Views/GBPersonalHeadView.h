//
//  GBPersonalHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBPersonalHeadView : UIView
/* 是否显示大标题 */
@property (nonatomic, assign) BOOL isShowBigTitle;
/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;

- (id)initWithFrame:(CGRect)frame
                 name:(NSString *)name
             position:(NSString *)position
              company:(NSString *)company
            headImage:(NSString *)headImage;

@end
