//
//  UITableViewCell+SectionCorner.m
//  LiChi
//
//  Created by liuxiaokun on 2017/8/2.
//  Copyright © 2017年 liuxiaokun. All rights reserved.
//

#import "UITableViewCell+SectionCorner.h"

@implementation UITableViewCell (SectionCorner)
- (void)addSectionCornerWithTableView:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath
                      cornerViewframe:(CGRect)frame
                 segmentateLineMargin:(CGFloat)margin
                         cornerRadius:(CGFloat)cornerRadius
{
        
    self.backgroundColor = UIColor.clearColor;
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGRect bounds = frame;
    
    BOOL addLine = NO;
    
    if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        
        CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        
    } else if (indexPath.row == 0) {
        
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
        addLine = YES;
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        
    } else {
        
        CGPathAddRect(pathRef, nil, bounds);
        
        addLine = YES;
        
    }
    
    layer.path = pathRef;
    
    CFRelease(pathRef);
    
    //颜色修改
    
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    if (addLine == YES) {
        
        CALayer *lineLayer = [[CALayer alloc] init];
        
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        
        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+margin, bounds.size.height-lineHeight, bounds.size.width-margin, 0.4);
        
        lineLayer.backgroundColor = [UIColor kSegmentateLineColor].CGColor;
        
        [layer addSublayer:lineLayer];
    }
    
    UIView *cornerView = [[UIView alloc] initWithFrame:bounds];
    
    [cornerView.layer insertSublayer:layer atIndex:0];
    
    cornerView.backgroundColor = [UIColor kBaseBackgroundColor];
    
    self.backgroundView = cornerView;
    
}

@end

@implementation UICollectionViewCell (SectionCorner)

- (void)addSectionCornerWithCollectionView:(UICollectionView *)collectionView
                                 indexPath:(NSIndexPath *)indexPath
                           cornerViewframe:(CGRect)frame
                      segmentateLineMargin:(CGFloat)margin
                              cornerRadius:(CGFloat)cornerRadius
{
    
    self.backgroundColor = UIColor.clearColor;
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGRect bounds = frame;
    
    BOOL addLine = NO;
    
    if (indexPath.row == 0 && indexPath.row == [collectionView numberOfItemsInSection:indexPath.section]-1) {
        
        CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        
    } else if (indexPath.row == 0) {
        
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
        addLine = YES;
        
    } else if (indexPath.row == [collectionView numberOfItemsInSection:indexPath.section]-1) {
        
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        
    } else {
        
        CGPathAddRect(pathRef, nil, bounds);
        
        addLine = YES;
        
    }
    
    layer.path = pathRef;
    
    CFRelease(pathRef);
    
    //颜色修改
    
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    if (addLine == YES) {
        
        CALayer *lineLayer = [[CALayer alloc] init];
        
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        
        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+margin, bounds.size.height-lineHeight, bounds.size.width-margin, 0.5);
        
        lineLayer.backgroundColor = [UIColor kSegmentateLineColor].CGColor;
        
        [layer addSublayer:lineLayer];
    }
    
    UIView *cornerView = [[UIView alloc] initWithFrame:bounds];
    
    [cornerView.layer insertSublayer:layer atIndex:0];
    
    cornerView.backgroundColor = [UIColor kBaseBackgroundColor];
    
    self.backgroundView = cornerView;
}

@end
