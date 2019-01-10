//
//	GBTiebaDetailsCommentModel.h
//
//	Create by 小坤 刘 on 9/7/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface GBTiebaDetailsCommentModel : NSObject
/** 评论用户id */
@property (nonatomic, copy) NSString *commentUserId;
/** 评论用户头像 */
@property (nonatomic, strong) NSString * commentUserImg;
/** 评论用户昵称 */
@property (nonatomic, strong) NSString * commentUserNickName;
/** 评论内容 */
@property (nonatomic, strong) NSString * content;
/** 时间 */
@property (nonatomic, strong) NSString * createTime;
/** 帖子评论id */
@property (nonatomic, copy) NSString *gossipCommentId;
/** 帖子id */
@property (nonatomic, copy) NSString *gossipId;
/** 点赞数 */
@property (nonatomic, assign) NSInteger  likeCommentCount;
/** 点赞id */
@property (nonatomic, assign) NSInteger likeCommentUserId;
/** 是否点赞 */
@property (nonatomic, assign) BOOL like;
/* <#describe#> */
@property (nonatomic, assign) BOOL reported;

@end
