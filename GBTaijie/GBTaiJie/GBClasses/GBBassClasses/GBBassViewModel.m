//
//  GBBassViewModel.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/8.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBBassViewModel.h"

@implementation GBBassViewModel

+ (instancetype)viewModel {
    return [[self alloc] init];
}

- (void)setSuccessReturnBlock:(SuccessReturnValueBlock)returnBlock {
    _returnBlock = returnBlock;
}

- (void)setBlockWithReturnBlock:(SuccessReturnValueBlock)returnBlock
                 WithErrorBlock:(ErrorCodeBlock) errorBlock {
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
}


//*------------------
// MARK: 通用接口
//-------------------*

// MARK: 收藏
- (void)loadRequestCollect:(NSString *)targetId type:(NSString *)type {
    NSDictionary *param = @{
                            @"targetId":targetId,
                            @"type":type,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Collection httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"收藏:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"收藏 error:%@",error);
        
    }];
}

// MARK: 取消收藏
- (void)loadRequestCollectCancel:(NSString *)targetId {
    NSDictionary *param = @{
                            @"targetId":targetId,
                            };
    [[NetDataServer sharedInstance] requestURL:URL_Cancel_Collection httpMethod:@"POST" headerParams:nil params:param file:nil success:^(id responseData) {
        NSLog(@"取消收藏:%@",responseData);
        if ([responseData[@"result"] integerValue] == 1) {
            self.returnBlock(responseData[@"data"]);
        }else {
            [UIView showHubWithTip:responseData[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"取消收藏 error:%@",error);
        
    }];
}



@end
