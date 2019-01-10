//
//  GBAssureServiceContentCell.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBAssureServiceContentCell : UITableViewCell
/* 意向标签 */
@property (nonatomic, strong) NSMutableArray *tagsArray;
/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;
@property (nonatomic, strong) FSTextView *textView;
/* 内容 */
@property (nonatomic, strong) UILabel *content;
/* <#describe#> */
@property (nonatomic, strong) HXTagCollectionViewFlowLayout *flowLayout;
@property (nonatomic,copy) void(^textValueChangedBlock)(NSString *valueStr);

/* <#describe#> */
@property (nonatomic, assign) NSInteger tagsViewHeight;

@end
