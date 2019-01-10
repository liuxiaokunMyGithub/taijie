//
//  UIView+UIFactory.h
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2017/8/4.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIFactory)

#pragma mark - ------ Label ------

/* Label 文字 字体 文本颜色 */
+ (instancetype)createLabelWithText:(NSString *)text
                               font:(UIFont *)font
                          textColor:(UIColor *)textColor;

/* Label Frame 文字 字体 文本颜色 */
+ (instancetype)createLabelWithFrame:(CGRect)frame
                                text:(NSString *)text
                                font:(UIFont *)font
                           textColor:(UIColor *)textColor;

/* Label Frame 文字 字体 对齐方式 */
+ (instancetype)createLabelWithFrame:(CGRect)frame
                                text:(NSString *)text
                                font:(UIFont *)font
                       textAlignment:(NSTextAlignment)textAlignment;

/* Label Frame 文字 字体 文本颜色 对齐方式 */
+ (instancetype)createLabelWithFrame:(CGRect)frame
                                text:(NSString *)text
                                font:(UIFont *)font
                           textColor:(UIColor *)textColor
                       textAlignment:(NSTextAlignment)textAlignment;
/**
 快速创建TextFiled的类别扩展方法

 @return TextFiled对象
 */
+ (id)createTextFiled;
+ (id)createTextFiled:(UITextBorderStyle)style;
+ (id)createTextFiled:(CGRect)frame style:(UITextBorderStyle)style;

/**
 快速创建Button的类别扩展方法
 
 @return Button对象
 */
+ (instancetype)createButton:(CGRect)frame;

+ (instancetype)createButton:(CGRect)frame
              type:(UIButtonType)type;

+ (instancetype)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action;

+ (instancetype)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action
         textColor:(UIColor *)textColor;

+ (instancetype)createButtonWihtImage:(UIImage *)image
                      target:(id)target
                      action:(SEL)action;

+ (instancetype)createButtonWithFrame:(CGRect)frame
                                text:(NSString *)text
                                font:(UIFont *)font
                           textColor:(UIColor *)textColor
                       backGroundColor:(UIColor *)backGroundColor;
/**
 快速创建TableView的类别扩展方法
 
 @return TableView对象
 */
+ (instancetype)createTableView:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate;

+ (instancetype)createTableView:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
                style:(UITableViewStyle)style;

+ (instancetype)createTableView:(CGRect)frame
           dataSource:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate;

+ (instancetype)createTableView:(CGRect)frame
           dataSource:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
                style:(UITableViewStyle)style;

@end

