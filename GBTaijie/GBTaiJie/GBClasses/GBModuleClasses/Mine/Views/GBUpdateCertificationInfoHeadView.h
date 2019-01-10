//
//  GBUpdateCertificationInfoHeadView.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/16.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBUpdateCertificationInfoHeadView : UIView
/* 大标题 */
@property (nonatomic, strong) UILabel *bigTitleLabel;

/* 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;

/* 职位 */
@property (nonatomic, strong) UILabel *positionLabel;

/* 提示 */
@property (nonatomic, strong) UILabel *flagLabel;

/* 编辑 */
@property (nonatomic, strong) UIButton *edictButton;

/* 头像 */
@property (nonatomic, strong) UIImageView *headImageView;

/* 编辑 */
@property (nonatomic, copy) dispatch_block_t didClickEdictBlock;

- (id)initWithFrame:(CGRect)frame
               name:(NSString *)name
           position:(NSString *)position
          headImage:(NSString *)headImage;

@end
