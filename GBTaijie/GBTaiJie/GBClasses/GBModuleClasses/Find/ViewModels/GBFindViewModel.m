//
//  GBFindViewModel.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/19.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBFindViewModel.h"

@implementation GBFindViewModel
/** 发现 */
- (void)loadRequestFindSearch {
    [[NetDataServer sharedInstance] requestURL:URL_Find_FindSearch httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"发现 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"发现 error:%@",error);
        
    }];
}

/** 发现-热心同事换一批 */
- (void)loadRequestChangingWarmIncumbents {
    [[NetDataServer sharedInstance] requestURL:URL_Find_ChangingWarmIncumbents httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        NSLog(@"热心同事换一批 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"热心同事换一批 error:%@",error);
        
    }];
}
/** 发现页-特价免费及各TAB */
- (void)loadRequestChangingDecrypts:(BOOL )changingRound
                          labelCode:(NSString *)labelCode
                        specialFree:(BOOL )specialFree {
    NSDictionary *param = @{@"changingRound":[NSNumber numberWithBool:changingRound],
                            @"labelCode":labelCode,
                            @"specialFree":[NSNumber numberWithBool:specialFree]
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Find_ChangingDecrypts httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"特价免费及各TAB :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"特价免费及各TAB error:%@",error);
        
    }];
}

/** 发现更多 */
- (void)loadRequestFindMoreDecrypts:(BOOL )specialFree
                          labelCode:(NSString *)labelCode
                             pageNo:(NSInteger )pageNo
                           pageSize:(NSInteger )pageSize
{
    NSDictionary *param = @{@"specialFree":[NSNumber numberWithBool:specialFree],
                            @"labelCode":labelCode,
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize]
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Find_MoreDecrypts httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"发现更多 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"发现更多 error:%@",error);
        
    }];
}

/** 服务评论列表 */
- (void)loadRequestServiceCommentList:(NSString *)decryptId
                         targetUserId:(NSString *)targetUserId
                          serviceType:(NSString *)serviceType
                         assurePassId:(NSString *)assurePassId
                               pageNo:(NSInteger )pageNo
                             pageSize:(NSInteger )pageSize
{
    NSMutableDictionary *mutParam = [NSMutableDictionary dictionaryWithDictionary:@{@"targetUserId":targetUserId,
                            @"serviceType":serviceType,
                            @"pageNo":[NSNumber numberWithInteger:pageNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize]
                            }];
    if (ValidStr(assurePassId)) {
        [mutParam setObject:assurePassId forKey:@"assurePassId"];
    }
    
    if (ValidStr(decryptId)) {
        [mutParam setObject:decryptId forKey:@"decryptId"];
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_Find_Service_CommentList httpMethod:@"POST" headerParams:nil params:mutParam file:nil success:^(id responseData) {
        NSLog(@" 服务评论列表 :%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@" 服务评论列表 error:%@",error);
        
    }];
}

@end
