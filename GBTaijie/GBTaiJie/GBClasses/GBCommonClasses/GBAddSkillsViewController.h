//
//  GBAddSkillsViewController.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/26.
//Copyright © 2018年 刘小坤. All rights reserved.
//


typedef void(^SelectSkillsBlock) (NSArray *dataArray);

@interface GBAddSkillsViewController : GBBaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *middleTableView;

@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (nonatomic, strong) NSArray *skills;

@property (nonatomic, copy) SelectSkillsBlock skillsBlock;

@end
