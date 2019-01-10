//
//  XKWebViewController.h
//  HeMaiApp
//
//  Created by 刘小坤 on 17/10/31.
//  Copyright © 2017年 apple. All rights reserved.
//  网页视图

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface XKWebViewController : GBBaseViewController
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic) UIColor *progressViewColor;
@property (nonatomic,weak) WKWebViewConfiguration * webConfiguration;
@property (nonatomic, copy) NSString * url;

- (instancetype)initWithUrl:(NSString *)url;

/* 标题 */
@property (nonatomic, copy) NSString *titleStr;

//更新进度条
- (void)updateProgress:(double)progress;

//更新导航栏按钮，子类去实现
- (void)updateNavigationItems;

@end
