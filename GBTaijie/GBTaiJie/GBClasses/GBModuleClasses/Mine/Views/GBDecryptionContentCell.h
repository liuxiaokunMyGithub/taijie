//
//  GBDecryptionContentCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/20.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBDecryptionContentCell : UITableViewCell
/* 意向标签 */
@property (nonatomic, strong) NSMutableArray *tagsArray;
/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;
@property (nonatomic, strong) FSTextView *textView;
@property (nonatomic, strong) FSTextView *textView2;

/* 内容 */
@property (nonatomic, strong) UILabel *content;

@property (nonatomic,copy) void(^titleValueChangedBlock)(NSString *valueStr);
@property (nonatomic,copy) void(^detailsValueChangedBlock)(NSString *valueStr);

@end
