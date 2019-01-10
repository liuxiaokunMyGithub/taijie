//
//  ShareManager.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareView.h"

#ifndef ShareManagerInstance
#define ShareManagerInstance [ShareManager sharedShareManager]
#endif

/**
 分享 相关服务
 */
@interface ShareManager : NSObject

//单例
InterfaceSingleton(ShareManager);

@property (nonatomic, strong) ShareView * shareView;

/* 标题 */
@property (nonatomic, copy) NSString *shareTitle;
/** 分享文本内容 */
@property (nonatomic, copy) NSString *shareText;
/* 分享icon图片data */
@property (nonatomic, strong) NSData *imageData;

/* 分享链接 */
@property (nonatomic, copy) NSString *shareUrl;

@end
