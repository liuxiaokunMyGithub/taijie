//
//  XHEmotionCollectionViewFlowLayout.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionCollectionViewFlowLayout.h"

@implementation XHEmotionCollectionViewFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(kXHEmotionImageViewSize, kXHEmotionImageViewSize);

        self.minimumLineSpacing = kXHEmotionMinimumLineSpacing;
        self.sectionInset = UIEdgeInsetsMake(kXHEmotionMinimumLineSpacing -5, 5, 0, 12);
        self.collectionView.alwaysBounceVertical = YES;
//        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        self.itemSize = CGSizeMake(kXHEmotionImageViewSize, kXHEmotionImageViewSize);
//        int count = SCREEN_WIDTH/(kXHEmotionImageViewSize+kXHEmotionMinimumLineSpacing);
//        CGFloat spacing = SCREEN_WIDTH/count - kXHEmotionImageViewSize;
//        self.minimumLineSpacing = spacing;
//        self.sectionInset = UIEdgeInsetsMake(10, spacing/2, 0, spacing/2);
//        self.collectionView.alwaysBounceVertical = YES;
    }
    return self;
}

@end
