//
//  LCBassLaunchAdManager.h
//  LCBassLaunchAdManager
//
//  Created by liuxiaokun on 2017/5/3.
//  Copyright © 2017年 it7090.com. All rights reserved.

#import <Foundation/Foundation.h>

@interface LCBassLaunchAdManager : NSObject

+(LCBassLaunchAdManager *)shareManager;

- (void)setupXHLaunchAd;

/* 广告显示完成 */
@property (nonatomic, copy) dispatch_block_t launchAdShowFinishBlock;

@end
