//
//	GBTiebaModel.h
//
//	Create by 小坤 刘 on 7/7/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface GBTiebaModel : NSObject
/** 评论数 */
@property (nonatomic, assign) NSInteger commentsCount;
/** 帖子内容 */
@property (nonatomic, strong) NSString * content;
/** 时间 */
@property (nonatomic, strong) NSString * createTime;
/** 是否可用 */
@property (nonatomic, assign) BOOL enable;
/** 帖子id */
@property (nonatomic, copy) NSString *gossipId;
/** 昵称 */
@property (nonatomic, strong) NSString * gossipNickName;
/** 是否点赞 */
@property (nonatomic, assign) BOOL like;
/** 点赞数 */
@property (nonatomic, assign) NSInteger likesCount;
/** 头像 */
@property (nonatomic, strong) NSString * publisherHeadImg;
/** 发布人id */
@property (nonatomic, copy) NSString *publisherId;
/* 图片 */
@property (nonatomic, copy) NSString *picture;


@end
