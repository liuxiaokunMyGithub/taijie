//
//  GBTiebaViewModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/8.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBTiebaViewModel : GBBassViewModel
/**
 帖子列表
 orderType:(HOT最热|NEW最新)
 */
- (void)loadRequestTiebaList:(NSInteger )pageNo pageSize:(NSInteger )pageSize orderType:(NSString *)orderType;
/** 帖子评论列表 */
- (void)loadRequestTiebaCommentList:(NSInteger )pageNo pageSize:(NSInteger )pageSize gossipId:(NSString *)gossipId;

/** 帖子用户昵称 */
- (void)loadRequestTiebaUserNick;
/** 更新帖子用户昵称 */
- (void)loadRequestUpdateTiebaUserNick:(NSString *)gossipNickName;
/** 关闭帖子 */
- (void)loadRequestCloseTieba:(NSString *)gossipId;
/** 点赞帖子 */
- (void)loadRequestLikeTieba:(NSString *)gossipId;
/** 取消点赞帖子 */
- (void)loadRequestCanceLikeTieba:(NSString *)gossipId;
/** 发帖 */
- (void)loadRequestPublishTiebaContent:(NSString *)content picture:(NSString *)picture;
/** 发评论 */
- (void)loadRequestPublishTiebaComment:(NSString *)content
                              gossipId:(NSString *)gossipId;
/** 评论删除 */
- (void)loadRequestCommentClose:(NSString *)gossipId
                gossipCommentId:(NSString *)gossipCommentId;

@end
