//
//  UITableViewCell+SectionCorner.h
//  LiChi
//
//  Created by liuxiaokun on 2017/8/2.
//  Copyright © 2017年 liuxiaokun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (SectionCorner)

- (void)addSectionCornerWithTableView:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath
                      cornerViewframe:(CGRect)frame
                 segmentateLineMargin:(CGFloat)margin
                         cornerRadius:(CGFloat)cornerRadius;

@end

@interface UICollectionViewCell (SectionCorner)

- (void)addSectionCornerWithCollectionView:(UICollectionView *)collectionView
                                 indexPath:(NSIndexPath *)indexPath
                           cornerViewframe:(CGRect)frame
                      segmentateLineMargin:(CGFloat)margin
                              cornerRadius:(CGFloat)cornerRadius;

@end
