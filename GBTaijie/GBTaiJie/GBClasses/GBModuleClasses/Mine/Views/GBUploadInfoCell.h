//
//  GBUploadInfoCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/3.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBUploadInfoCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                      section:(NSInteger )section
                    imageUrls:(NSArray *)imageUrls;
// image 数组
@property(nonatomic,strong) NSMutableArray *imageArray;

/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* 图标icon */
@property (nonatomic, strong) UIImageView *iconImageView;
/* 重置 */
@property (nonatomic, strong) UIButton *resetUpdateImageButton;
/* 删除 */
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, copy) void (^updateInfoImages)(NSArray *imagesUrls,NSInteger section);

@end
