//
//  GBFindViewModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBassViewModel.h"

@interface GBFindViewModel : GBBassViewModel
/** 发现 */
- (void)loadRequestFindSearch;

/** 发现-热心同事换一批 */
- (void)loadRequestChangingWarmIncumbents;
/** 发现页-特价免费及各TAB
 changingRound: 换一批 true
 */
- (void)loadRequestChangingDecrypts:(BOOL )changingRound
                          labelCode:(NSString *)labelCode
                        specialFree:(BOOL )specialFree;

/** 发现更多 */
- (void)loadRequestFindMoreDecrypts:(BOOL )specialFree
                          labelCode:(NSString *)labelCode
                             pageNo:(NSInteger )pageNo
                           pageSize:(NSInteger )pageSize;

/** 服务评论列表 */
- (void)loadRequestServiceCommentList:(NSString *)decryptId
                          targetUserId:(NSString *)targetUserId
                       serviceType:(NSString *)serviceType
                       assurePassId:(NSString *)assurePassId
                             pageNo:(NSInteger )pageNo
                           pageSize:(NSInteger )pageSize;

@end
