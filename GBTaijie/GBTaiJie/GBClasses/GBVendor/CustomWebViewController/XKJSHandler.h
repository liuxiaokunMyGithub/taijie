//
//  XLJSHandler.h
//  HeMaiApp
//
//  Created by 刘小坤 on 2018/814.
//  Copyright © 2017年 刘小坤. All rights reserved.
//  处理各种js交互

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface XKJSHandler : NSObject<WKScriptMessageHandler>
@property (nonatomic,weak,readonly) UIViewController * webVC;
@property (nonatomic,strong,readonly) WKWebViewConfiguration * configuration;

-(instancetype)initWithViewController:(UIViewController *)webVC configuration:(WKWebViewConfiguration *)configuration;

-(void)cancelHandler;

/* 标题 */
@property (nonatomic, copy) NSString *titleStr;

@end
