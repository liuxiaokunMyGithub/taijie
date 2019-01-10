//
//  ShareManager.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager

ImplementationSingleton(ShareManager);

- (ShareView *)shareView {
    if (!_shareView) {
        _shareView = [ShareView getFactoryShareViewWithCallBack:^(JSHAREPlatform platform, JSHAREMediaType type) {
            switch (type) {
                case JSHAREText:
                [self shareTextWithPlatform:platform];
                break;
                case JSHAREImage:
                [self shareImageWithPlatform:platform];
                break;
                case JSHARELink:
                [self shareLinkWithPlatform:platform];
                break;
                case JSHAREApp:
                [self shareAppWithPlatform:platform];
                break;
                case JSHAREFile:
                [self shareFileWithPlatform:platform];
                break;
                default:
                break;
            }
        }];
        
    }

    return _shareView;
}

/** 分享文本 */
- (void)shareTextWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    message.text = self.shareText;
    message.platform = platform;
    message.mediaType = JSHAREText;
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
    }];
}

/** 分享图片 */
- (void)shareImageWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREImage;
    message.text = ValidStr(self.shareText) ? self.shareText : @"";
    message.platform = platform;
    message.image = self.imageData;

        [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
            [self showAlertWithState:state error:error];
        }];
}

/** 分享链接 */
- (void)shareLinkWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHARELink;
    message.url = self.shareUrl;
    message.text = ValidStr(self.shareText) ? self.shareText : @"";
    message.title = ValidStr(self.shareTitle) ? self.shareTitle : @"";;
    message.platform = platform;
    NSData *imageData = self.imageData;

    message.image = imageData;
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
    }];
}

/** 分享app */
- (void)shareAppWithPlatform:(JSHAREPlatform)platform {
    Byte* pBuffer = (Byte *)malloc(10*1024*1024);
    memset(pBuffer, 0, 10*1024);
    NSData* data = [NSData dataWithBytes:pBuffer length:10*1024*1024];
    free(pBuffer);
    
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREApp;
    message.url = @"http://www.taijie.work";
    message.text = [NSString stringWithFormat:@"时间:%@ 上台阶找到职场领路人",[NSString localizedStringTime]];
    message.title = @"台阶App";
    message.extInfo = @"<xml>extend info</xml>";
    message.fileData = data;
    message.platform = platform;
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
        
    }];
}

/** 分享文件 */
- (void)shareFileWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREFile;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jiguang" ofType:@"mp4"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    message.fileData = fileData;
    message.fileExt = @"mp4";
    message.platform = platform;
    message.title = @"jiguang.mp4";
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
    }];
}

- (void)checkPlatform:(JSHAREPlatform)platform {
    switch (platform) {
        case JSHAREPlatformWechatSession:
        case JSHAREPlatformWechatTimeLine:
        case JSHAREPlatformWechatFavourite:
        {
           if (![JSHAREService isWeChatInstalled])
            return [UIView showHubWithTip:@"没有安装微信"];
        }
        break;
        case JSHAREPlatformQQ:
        case JSHAREPlatformQzone:
        {
            if (![JSHAREService isQQInstalled])
            return [UIView showHubWithTip:@"没有安装QQ"];
        }
        break;
        case JSHAREPlatformSinaWeibo:
        case JSHAREPlatformSinaWeiboContact:
        {
            if (![JSHAREService isSinaWeiBoInstalled])
            return [UIView showHubWithTip:@"没有安装新浪微博"];
        }
        break;
        default:
        break;
    }
}

- (void)showAlertWithState:(JSHAREState)state error:(NSError *)error{
    
    NSString *string = nil;
    if (error) {
        NSLog(@"分享失败,error:%@",error.description);
        string = [NSString stringWithFormat:@"分享失败,error:%@", error.description];
    }else{
        switch (state) {
            case JSHAREStateSuccess:
            string = @"分享成功";
            break;
            case JSHAREStateFail:
            string = @"分享失败";
            break;
            case JSHAREStateCancel:
            string = @"分享取消";
            break;
            case JSHAREStateUnknown:
                return;
            break;
            default:
            break;
        }
    }
    
    [UIView showHubWithTip:string];
}

@end
