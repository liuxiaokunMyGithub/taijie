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
@property (nonatomic, assign) NSInteger commentUserId;
/** 评论用户头像 */
@property (nonatomic, strong) NSObject * commentUserImg;
/** 评论用户昵称 */
@property (nonatomic, strong) NSObject * commentUserNickName;
/** 评论内容 */
@property (nonatomic, strong) NSString * content;
/** 时间 */
@property (nonatomic, strong) NSString * createTime;
/** 帖子评论id */
@property (nonatomic, assign) NSInteger gossipCommentId;
/** 帖子id */
@property (nonatomic, assign) NSInteger gossipId;
/** 点赞数 */
@property (nonatomic, assign) NSInteger  likeCommentCount;
/** 点赞id */
@property (nonatomic, assign) NSInteger likeCommentUserId;

@end
