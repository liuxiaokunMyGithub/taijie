//
//  RootWebViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//  webview 基类

#import "XKWebViewController.h"

@interface GBBaseWebViewController : XKWebViewController

//在多级跳转后，是否在返回按钮右侧展示关闭按钮
@property(nonatomic,assign) BOOL isShowCloseBtn;

@end

