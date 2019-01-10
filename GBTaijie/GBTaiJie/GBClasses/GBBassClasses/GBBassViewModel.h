//
//  GBBassViewModel.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/8.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBBassViewModel : NSObject
/** 初始化一个实例 */
+ (instancetype)viewModel;

/** 成功返回数据 */
@property (nonatomic, copy) SuccessReturnValueBlock returnBlock;
/** 返回错误 */
@property (nonatomic, copy) ErrorCodeBlock errorBlock;
/** 只传成功回调 */
- (void)setSuccessReturnBlock:(SuccessReturnValueBlock)returnBlock;
/** 设置交互的Block回调 */
- (void)setBlockWithReturnBlock:(SuccessReturnValueBlock)returnBlock
                 WithErrorBlock:(ErrorCodeBlock)errorBlock;

//*------------------
// MARK: 通用接口
//-------------------*

/** MARK: 收藏
 targetUserId :
      收藏什么就对应什么id
     （职位id/公司id/用户id）
 type:
     公司 ：@"COLLECTION_TYPE_COMPANY"
     职位 ：@"COLLECTION_TYPE_POSITION"
     用户 ：@"COLLECTION_TYPE_USER"
 */
- (void)loadRequestCollect:(NSString *)targetUserId type:(NSString *)type;

// MARK: 取消收藏
- (void)loadRequestCollectCancel:(NSString *)targetId;

@end
