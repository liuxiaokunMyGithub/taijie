//
//  UIView+UIFactory.m
//  LCHeMaiMall
//
//  Created by 刘小坤 on 2017/8/4.
//  Copyright © 2017年 刘小坤. All rights reserved.
//

#import "UIView+UIFactory.h"

@implementation UIView (UIFactory)

#pragma mark - ------ Label ------

+ (instancetype)createLabelWithText:(NSString *)text
                               font:(UIFont *)font
                          textColor:(UIColor *)textColor {
    
    return [UILabel createLabelWithFrame:CGRectZero text:text font:font textColor:textColor textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)createLabelWithFrame:(CGRect)frame
                                text:(NSString *)text
                                font:(UIFont *)font
                           textAlignment:(NSTextAlignment)textAlignment {
    
    return [UILabel createLabelWithFrame:frame text:text font:font textColor:nil textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)createLabelWithFrame:(CGRect)frame
                                text:(NSString *)text
                                font:(UIFont *)font
                           textColor:(UIColor *)textColor {
    
    return [UILabel createLabelWithFrame:frame text:text font:font textColor:textColor textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)createLabelWithFrame:(CGRect)frame
                                text:(NSString *)text
                                font:(UIFont *)font
                           textColor:(UIColor *)textColor
                       textAlignment:(NSTextAlignment)textAlignment {
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    
    return label;
}

#pragma mark -  ------ TextField  ------

+ (instancetype)createTextFiled {
    return [UITextField createTextFiled:UITextBorderStyleRoundedRect];
}

+ (instancetype)createTextFiled:(UITextBorderStyle)style {
    return [UITextField createTextFiled:CGRectZero style:style];
}

+ (id)createTextFiled:(CGRect)frame style:(UITextBorderStyle)style {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = [UIColor blackColor];
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = style;
    
    return textField;
}

#pragma mark - ------ Button  ------
+ (instancetype)createButton:(CGRect)frame {
    return [UIView createButton:frame type:UIButtonTypeRoundedRect];
}

+ (instancetype)createButton:(CGRect)frame
              type:(UIButtonType)type
{
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    
    return button;
}

+ (instancetype)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action
{
    return [UIView createButton:frame
                         target:target
                         action:action
                     textColor:[UIColor kBaseColor]];
}

+ (instancetype)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action
         textColor:(UIColor *)textColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    return button;
}

+ (instancetype)createButtonWihtImage:(UIImage *)image
                               target:(id)target
                               action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (instancetype)createButtonWithFrame:(CGRect)frame
                                 text:(NSString *)text
                                 font:(UIFont *)font
                            textColor:(UIColor *)textColor
                      backGroundColor:(UIColor *)backGroundColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundColor:backGroundColor];
    
    return button;
}

#pragma mark -  ------ TableView  ------
+ (instancetype)createTableView:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
{
    return [UIView createTableView:CGRectZero
                        dataSource:dataSource
                          delegete:delegate
                             style:UITableViewStyleGrouped];
}

+ (instancetype)createTableView:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
                style:(UITableViewStyle)style
{
    return [UIView createTableView:CGRectZero
                        dataSource:dataSource
                          delegete:delegate
                             style:style];
}

+ (instancetype)createTableView:(CGRect)frame
           dataSource:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
{
    return [UIView createTableView:frame
                        dataSource:dataSource
                          delegete:delegate
                             style:UITableViewStyleGrouped];
}

+ (instancetype)createTableView:(CGRect)frame
           dataSource:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
                style:(UITableViewStyle)style
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    
    return tableView;
    
}

#pragma mark -  ------ TextView  ------
+ (instancetype)createTextView:(CGRect)frame {
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    
    return textView;
}

@end
