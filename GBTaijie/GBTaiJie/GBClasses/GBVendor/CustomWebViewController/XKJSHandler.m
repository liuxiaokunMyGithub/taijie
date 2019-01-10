//
//  XKJSHandler.m
//  HeMaiApp
//
//  Created by 刘小坤 on 2018/814.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "XKJSHandler.h"


@interface XKJSHandler ()


@end

@implementation XKJSHandler

- (instancetype)initWithViewController:(UIViewController *)webVC configuration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if (self) {
        _webVC = webVC;
        _configuration = configuration;
        //js handler
        //注册JS 事件
//        [configuration.userContentController addScriptMessageHandler:self name:@"showImages"];
        [configuration.userContentController addScriptMessageHandler:self name:@"backPage"];
        [configuration.userContentController addScriptMessageHandler:self name:@"backHome"];
        [configuration.userContentController addScriptMessageHandler:self name:@"jump"];

//        [configuration.userContentController addScriptMessageHandler:self name:@"showVideo"];
//        [configuration.userContentController addScriptMessageHandler:self name:@"issueMoment"];
//        [configuration.userContentController addScriptMessageHandler:self name:@"JSShare"];
        
    }
    return self;
}

#pragma mark -  JS 调用 Native  代理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"backPage"]) {
        //返回
        if (self.webVC.presentingViewController) {
            [self.webVC dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.webVC.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if ([message.name isEqualToString:@"backHome"]) {
        NSLog(@"js 回调个人主页");
        [GBNotificationCenter postNotificationName:BannerBackToPersonalHomeNotification object:self.titleStr];
    }
    
    if ([message.name isEqualToString:@"jump"]) {
        NSLog(@"jump - 排行榜个人主页body %@ ",message.body);
        [GBNotificationCenter postNotificationName:HomePage_H5_RankingClickNotification object:message.body];
    }
}

#pragma mark -  记得要移除
-(void)cancelHandler {
//    [_configuration.userContentController removeScriptMessageHandlerForName:@"showImages"];
    [_configuration.userContentController removeScriptMessageHandlerForName:@"backPage"];
    [_configuration.userContentController removeScriptMessageHandlerForName:@"backHome"];
//    [_configuration.userContentController removeScriptMessageHandlerForName:@"showVideo"];
//    [_configuration.userContentController removeScriptMessageHandlerForName:@"issueMoment"];
//    [_configuration.userContentController removeScriptMessageHandlerForName:@"JSShare"];
}

-(void)dealloc {
    
}

@end
