//
//  PositionSelectView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/820.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "PositionSelectView.h"
#import "PositionSelectCell.h"

@implementation PositionSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.backV = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self addSubview:self.backV];
    UIButton *leftB = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 94, SCREEN_HEIGHT)];
    [leftB setBackgroundColor:[UIColor clearColor]];
    [leftB addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backV addSubview:leftB];
    
    CGFloat tableW = (SCREEN_WIDTH - 94) * 0.5;
    self.cateOneTableView = [[UITableView alloc] initWithFrame:CGRectMake(94, 0, tableW, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.cateOneTableView.contentInset = UIEdgeInsetsMake(StatusBarHeight, 0, 0, 0);
    self.cateOneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backV addSubview:self.cateOneTableView];
    [self.cateOneTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PositionSelectCell class]) bundle:nil] forCellReuseIdentifier:@"selectCateOne"];
    
    self.cateTwoTableView = [[UITableView alloc] initWithFrame:CGRectMake(94 + tableW, 0, tableW, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.cateTwoTableView.contentInset = UIEdgeInsetsMake(StatusBarHeight, 0, 0, 0);
    self.cateTwoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backV addSubview:self.cateTwoTableView];
    [self.cateTwoTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PositionSelectCell class]) bundle:nil] forCellReuseIdentifier:@"selectCateTwo"];
}

- (void)leftBtnClick {
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.backV.x = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        self.x = SCREEN_WIDTH;
    }];
}


@end
