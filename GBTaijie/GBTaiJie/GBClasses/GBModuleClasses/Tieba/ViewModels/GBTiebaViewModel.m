//
//  GBTiebaViewModel.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/8.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBTiebaViewModel.h"

@implementation GBTiebaViewModel
/** 帖子列表 */
- (void)loadRequestTiebaList:(NSInteger )pageNo pageSize:(NSInteger )pageSize orderType:(NSString *)orderType {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"orderType":orderType
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Tieba_List httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"帖子列表 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"帖子列表 error %@",error);
    }];
}

/** 帖子评论列表 */
- (void)loadRequestTiebaCommentList:(NSInteger )pageNo pageSize:(NSInteger )pageSize gossipId:(NSString *)gossipId {
    NSDictionary *param = @{
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize],
                            @"gossipId":gossipId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Tieba_Comment_List httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"帖子评论列表 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"帖子评论列表 error %@",error);
    }];
}

/** 帖子用户昵称 */
- (void)loadRequestTiebaUserNick {
    [[NetDataServer sharedInstance] requestURL:URL_Tieba_Nick httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"帖子用户昵称 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"帖子用户昵称 error %@",error);
    }];
}

/** 更新帖子用户昵称 */
- (void)loadRequestUpdateTiebaUserNick:(NSString *)gossipNickName {
    NSDictionary *param = @{
                            @"gossipNickName":gossipNickName,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Tieba_UpdateNick httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"更新帖子用户昵称 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"更新帖子用户昵称 error %@",error);
    }];
}

/** 关闭帖子 */
- (void)loadRequestCloseTieba:(NSString *)gossipId {
    NSDictionary *param = @{
                            @"gossipId":gossipId,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Tieba_Close httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"关闭帖子 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"关闭帖子 error %@",error);
    }];
}

/** 点赞帖子 */
- (void)loadRequestLikeTieba:(NSString *)gossipId {
    NSDictionary *param = @{
                            @"gossipId":gossipId,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Tieba_Like httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"点赞帖子 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"点赞帖子 error %@",error);
    }];
}

/** 取消点赞帖子 */
- (void)loadRequestCanceLikeTieba:(NSString *)gossipId {
    NSDictionary *param = @{
                            @"gossipId":gossipId,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Tieba_CancelLike httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"取消点赞帖子 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"取消点赞帖子 error %@",error);
    }];
}

/** 发帖 */
- (void)loadRequestPublishTiebaContent:(NSString *)content picture:(NSString *)picture {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"content":content}];
    if (ValidStr(picture)) {
        [param setObject:picture forKey:@"picture"];
    }
    [[NetDataServer sharedInstance] requestURL:URL_Tieba_Publish httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"发帖 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"发帖 error %@",error);
    }];
}

/** 发评论 */
- (void)loadRequestPublishTiebaComment:(NSString *)comment
                              gossipId:(NSString *)gossipId {
    NSDictionary *param = @{
                            @"content":comment,
                            @"gossipId":gossipId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Tieba_Publish_Comment httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"发评论 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"发评论 error %@",error);
    }];
}

/** 评论删除 */
- (void)loadRequestCommentClose:(NSString *)gossipId
                       gossipCommentId:(NSString *)gossipCommentId {
    NSDictionary *param = @{
                            @"gossipId":gossipId,
                            @"gossipCommentId":gossipCommentId
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Tieba_CommentClose httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"评论删除 responseData %@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"评论删除 error %@",error);
    }];
}

@end
