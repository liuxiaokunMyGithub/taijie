//
//  GBBaseNavigationController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//Copyright © 2018年 刘小坤. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GBBaseNavigationController : UINavigationController

/*!
 *  返回到指定的类视图
 *
 *  @param ClassName 类名
 *  @param animated  是否动画
 */
- (BOOL)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated;

@end
