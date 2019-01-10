//
//  GBAddSkillsViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/26.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBAddSkillsViewController.h"

// Controllers
#import "ExpectedIndustryLeftCell.h"
#import "ExpectedIndustryRightCell.h"
#import "GBSkillsModel.h"
//#import "JobModel.h"
#import "ExpectIndustryDeleteView.h"

// ViewModels


// Models


// Views


@interface GBAddSkillsViewController ()

@property (nonatomic, strong) NSMutableArray *leftDatas;
@property (nonatomic, strong) NSMutableArray *midleDatas;
@property (nonatomic, strong) NSMutableArray *rightDatas;

@property (nonatomic, strong) NSMutableArray *selectedRightDatas;

@end

@implementation GBAddSkillsViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupSubViews];
    
    // 获取行业信息
    [self loadIndustriesData];
}

- (void)setupNav {
    self.navigationItem.title = @"添加技能";
    self.customNavBar.title = @"添加技能";

    [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:[UIColor kBaseColor]];
    @GBWeakObj(self);
    self.customNavBar.onClickRightButton = ^{
        @GBStrongObj(self);
        NSMutableArray *skills = [NSMutableArray array];
        if (self.selectedRightDatas.count) {
            for (GBSkillsModel *skillsModel in self.selectedRightDatas) {
                NSDictionary *param = @{
                                        @"skillRelatedId":[NSNumber numberWithInteger:[skillsModel.skillId integerValue]],
                                        @"skillName":skillsModel.skillName
                                        };
                [skills addObject:param];
            }
            
            GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
            [mineVM loadRequestPersonalEditInfoUpdate:@{@"skills":skills}];
            [mineVM setSuccessReturnBlock:^(id returnValue) {
                [UIView showHubWithTip:@"保存成功"];
                self.skillsBlock(self.selectedRightDatas);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else {
            return [UIView showHubWithTip:@"请选择擅长技能"];
        }
    };
}

- (void)setupSubViews {
    [self.leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ExpectedIndustryLeftCell class]) bundle:nil] forCellReuseIdentifier:@"ExpectedIndustryLeftCell"];
    [self.middleTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ExpectedIndustryLeftCell class]) bundle:nil] forCellReuseIdentifier:@"ExpectedIndustryLeftCell"];
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ExpectedIndustryRightCell class]) bundle:nil] forCellReuseIdentifier:@"ExpectedIndustryRightCell"];
    
    if (self.skills && self.skills.count > 0) {
        [self.selectedRightDatas removeAllObjects];
        [self.selectedRightDatas addObjectsFromArray:self.skills];
        [self setTopView];
    }else {
        self.topViewHeight.constant = 0;
    }
}

/** 获取一级技能 */
- (void)loadIndustriesData {
    GBCommonViewModel *commonVN = [[GBCommonViewModel alloc] init];
    [commonVN loadRequestSkills:@""];
    [commonVN setSuccessReturnBlock:^(id returnValue) {
        [self.leftDatas removeAllObjects];
        
        NSArray *datas = [GBSkillsModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.leftDatas addObjectsFromArray:datas];
        
        if (datas.count > 0) {
            GBSkillsModel *first = [datas objectAtIndex:0];
            [self loadMidleSkillId:first.skillId];
        }
        
        [self.leftTableView reloadData];
        
        if (datas.count > 0) {
            NSIndexPath *leftIP = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.leftTableView selectRowAtIndexPath:leftIP animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }];
    
}

/** 获取二级技能 */
- (void)loadMidleSkillId:(NSString *)skillId{
    GBCommonViewModel *commonVN = [[GBCommonViewModel alloc] init];
    [commonVN loadRequestSkills:skillId];
    [commonVN setSuccessReturnBlock:^(id returnValue) {
        NSArray *datas = [GBSkillsModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.midleDatas removeAllObjects];
        [self.midleDatas addObjectsFromArray:datas];
        
        [self.middleTableView reloadData];
        
        if (datas.count > 0) {
            GBSkillsModel *midleModel = [datas objectAtIndex:0];
            [self loadRightSkillId:midleModel.skillId];
        }
        
        if (self.midleDatas.count > 0) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.middleTableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }];
}

/** 获取三级技能 */
- (void)loadRightSkillId:(NSString *)skillId {
    GBCommonViewModel *commonVN = [[GBCommonViewModel alloc] init];
    [commonVN loadRequestSkills:skillId];
    [commonVN setSuccessReturnBlock:^(id returnValue) {
        NSArray *datas = [GBSkillsModel mj_objectArrayWithKeyValuesArray:returnValue];
        [self.rightDatas removeAllObjects];
        [self.rightDatas addObjectsFromArray:datas];
        
        [self.rightTableView reloadData];
        
        if (self.rightDatas.count > 0) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.rightTableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.leftDatas.count;
    }else if (tableView == self.middleTableView){
        return self.midleDatas.count;
    }else {
        return self.rightDatas.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.rightTableView) {
        ExpectedIndustryRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpectedIndustryRightCell"];
        GBSkillsModel *job =  [self.rightDatas objectAtIndex:indexPath.row];
        cell.nameL.text = job.skillName;
        cell.isSelect = [self checkInSelectDatas:job] ? 1 : 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ExpectedIndustryLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpectedIndustryLeftCell"];
        GBSkillsModel *industry = tableView == self.middleTableView ? [self.midleDatas objectAtIndex:indexPath.row] : [self.leftDatas objectAtIndex:indexPath.row];
        cell.nameL.text = industry.skillName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.rightTableView) {
        GBSkillsModel *industry = [self.rightDatas objectAtIndex:indexPath.row];
        
        NSInteger count = self.selectedRightDatas.count;
        
        if (count >= 5) {
            if (industry.isSelect == 0) {
                [UIView showHubWithTip:@"最多选择5个技能"];
            } else {
                industry.isSelect = 0;
                if ([self checkInSelectDatas:industry]) {  // 删除此jobModel
                    self.selectedRightDatas = [self deleteJobModel:industry];
                }
                [tableView reloadData];
                [self setTopView];
            }
        } else {
            industry.isSelect = industry.isSelect == 0 ? 1 : 0;
            if (industry.isSelect == 1) {
                if ([self checkInSelectDatas:industry]) {
                    //
                } else {
                    [self.selectedRightDatas addObject:industry];
                }
            } else {
                if ([self checkInSelectDatas:industry]) {  // 删除此Model
                    self.selectedRightDatas = [self deleteJobModel:industry];
                }
            }
            [tableView reloadData];
            [self setTopView];
        }
    } else if (tableView == self.leftTableView) {
        GBSkillsModel *industry = [self.leftDatas objectAtIndex:indexPath.row];
        [self loadMidleSkillId:industry.skillId];
        [self.midleDatas removeAllObjects];
        [tableView reloadData];
        [self.leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else {
        GBSkillsModel *industry = [self.midleDatas objectAtIndex:indexPath.row];
        [self loadRightSkillId:industry.skillId];
        [self.rightDatas removeAllObjects];
        [tableView reloadData];
        [self.middleTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (BOOL)checkInSelectDatas:(GBSkillsModel *)job {
    for (NSInteger i = 0; i < self.selectedRightDatas.count; i++) {
        GBSkillsModel *jobM = [self.selectedRightDatas objectAtIndex:i];
        if ([job.skillId isEqualToString:jobM.skillId]) {
            return YES;
            break;
        }
    }
    return NO;
}

- (void)setTopView {
    
    if (!self.selectedRightDatas.count) {
        self.topViewHeight.constant = 0;
        return;
    }
    
    CGFloat MaxWidth = SCREEN_WIDTH - 90;
    
    // 清除以前的子控件
    for (UIView *con in self.topView.subviews) {
        [con removeFromSuperview];
    }
    
    CGFloat topViewHeight = 40;
    CGFloat itemX = 15;
    CGFloat itemY = 10;
    for (NSInteger i = 0; i < self.selectedRightDatas.count; i++) {
        GBSkillsModel *skillsModel = [self.selectedRightDatas objectAtIndex:i];
        CGFloat itemW = [DCSpeedy dc_calculateTextSizeWithText:skillsModel.skillName WithTextFont:Fit_Font(12) WithMaxW:SCREEN_WIDTH].width+38;
        
        
        if (itemX + itemW + 7 >= MaxWidth) {
            itemX = 15;
            itemY += 30;
            topViewHeight += 30;
        }
        
        ExpectIndustryDeleteView *deleteV = [[ExpectIndustryDeleteView alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, 20) title:skillsModel.skillName];
        deleteV.deleteBtn.tag = i;
        [deleteV.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:deleteV];
        itemX += itemW + 7;
    }
    
    UILabel *countL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 10, 60, 12)];
    countL.font = Fit_Font(12);
    countL.textAlignment = NSTextAlignmentRight;
    countL.textColor = UIColorFromRGB(0x96ABB5);
    
    NSString *countStr = [NSString stringWithFormat:@"已选(%lu/5)", (unsigned long)self.selectedRightDatas.count];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:countStr];
    //获取要调整颜色的文字位置,调整颜色
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor kBaseColor] range:NSMakeRange(3, 1)];
    countL.attributedText = hintString;
    [self.topView addSubview:countL];
    
    self.topViewHeight.constant = topViewHeight;
    self.topViewHeight.constant = 70;
    self.topViewHeight.constant = topViewHeight;
}

- (void)deleteBtnClick:(UIButton *)btn {
    GBSkillsModel *job = [self.selectedRightDatas objectAtIndex:btn.tag];
    
    self.selectedRightDatas = [self deleteJobModel:job];
    [self setTopView];
    [self.rightTableView reloadData];
}

- (NSMutableArray *)deleteJobModel:(GBSkillsModel *)job {
    NSMutableArray *results = [NSMutableArray array];
    for (NSInteger i = 0; i < self.selectedRightDatas.count; i++) {
        GBSkillsModel *jobM = [self.selectedRightDatas objectAtIndex:i];
        if ([job.skillId isEqualToString:jobM.skillId]) {
        } else {
            [results addObject:jobM];
        }
    }
    return results;
}

- (NSMutableArray *)leftDatas {
    if (!_leftDatas) {
        _leftDatas = [NSMutableArray array];
    }
    return _leftDatas;
}

- (NSMutableArray *)rightDatas {
    if (!_rightDatas) {
        _rightDatas = [NSMutableArray array];
    }
    return _rightDatas;
}
- (NSMutableArray *)midleDatas {
    if (!_midleDatas) {
        _midleDatas = [[NSMutableArray alloc] init];
    }
    
    return _midleDatas;
}

- (NSMutableArray *)selectedRightDatas {
    if (!_selectedRightDatas) {
        _selectedRightDatas = [NSMutableArray array];
    }
    return _selectedRightDatas;
}

@end
