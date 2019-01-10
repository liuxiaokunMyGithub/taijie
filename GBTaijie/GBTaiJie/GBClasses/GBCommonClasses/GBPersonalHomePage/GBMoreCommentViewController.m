//
//  GBMoreCommentViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/25.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBMoreCommentViewController.h"

// Controllers


// ViewModels


// Models
#import "GBPersonalCommentModel.h"

// Views
#import "GBPersonalSectionHeadView.h"
#import "GBMoreCommentListCell.h"

static NSString *const kGBMoreCommentListCellID = @"GBMoreCommentListCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

@interface GBMoreCommentViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 评论 */
@property (nonatomic, strong) NSMutableArray <GBPersonalCommentModel *>*comments;
/* 星星数 */
@property (nonatomic, assign) NSInteger starNub;
/* 评价数 */
@property (nonatomic, copy) NSString *totalCount;

@end

@implementation GBMoreCommentViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"更多评论";
    
    [self getCommentsInfo];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.sectionHeaderHeight = 0.0001;
    self.baseTableView.sectionFooterHeight = 0.0000001;
    [self.baseTableView registerClass:[GBMoreCommentListCell class] forCellReuseIdentifier:kGBMoreCommentListCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"评价"];
}

#pragma mark - # Setup Methods

- (void)headerRereshing {
    [super headerRereshing];
    [self getCommentsInfo];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self getCommentsInfo];
}

- (void)getCommentsInfo {
    if (ValidStr(self.serviceDetailsType)) {
        GBFindViewModel *findVM = [[GBFindViewModel alloc] init];
        [findVM loadRequestServiceCommentList:self.decryptionId targetUserId:self.targetUsrid serviceType:self.serviceDetailsType assurePassId:self.assuredId pageNo:page pageSize:10];
        [findVM setSuccessReturnBlock:^(id returnValue) {
            NSMutableArray *returnDataArray = [GBPersonalCommentModel mj_objectArrayWithKeyValuesArray:returnValue[@"comments"][@"list"]];
            self.totalCount = GBNSStringFormat(@"%@",returnValue[@"comments"][@"totalCount"]);
            [self setupSubTitle:GBNSStringFormat(@"总共有%@条评价",self.totalCount)];
            
            if (self.loadingStyle == LoadingDataRefresh) {
                // 刷新数据
                self.comments = [NSMutableArray arrayWithArray:returnDataArray];
                
                [self.baseTableView reloadData];
                [self.baseTableView.mj_header endRefreshing];
            }else if (self.loadingStyle == LoadingDataGetMore) {
                // 加载更多
                [self.comments addObjectsFromArray:returnDataArray];
                
                [self.baseTableView reloadData];
                if (returnDataArray.count < 10) {
                    [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.baseTableView.mj_footer endRefreshing];
                }
            }
            if (self.comments.count) {
                [self removeNoDataImage];
            }else {
                [self showNoDataImage];
            }
        }];
    }else {
        GBFindPeopleViewModel *findPeopleVM = [[GBFindPeopleViewModel alloc] init];
        [findPeopleVM loadRequestPersonComment:page pageSize:10 targetUserId:self.targetUsrid];
        [findPeopleVM setSuccessReturnBlock:^(id returnValue) {
            NSMutableArray *returnDataArray = [GBPersonalCommentModel mj_objectArrayWithKeyValuesArray:returnValue[@"commentList"][@"list"]];
            self.starNub = [returnValue[@"score"] integerValue];
            self.totalCount = GBNSStringFormat(@"%@",returnValue[@"commentList"][@"totalCount"]);
            [self setupSubTitle:GBNSStringFormat(@"总共有%@条评价",self.totalCount)];
            
            if (self.loadingStyle == LoadingDataRefresh) {
                // 刷新数据
                self.comments = [NSMutableArray arrayWithArray:returnDataArray];
                
                [self.baseTableView reloadData];
                [self.baseTableView.mj_header endRefreshing];
            }else if (self.loadingStyle == LoadingDataGetMore) {
                // 加载更多
                [self.comments addObjectsFromArray:returnDataArray];
                
                [self.baseTableView reloadData];
                if (returnDataArray.count < 10) {
                    [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.baseTableView.mj_footer endRefreshing];
                }
            }
            
            if (self.comments.count) {
                [self removeNoDataImage];
            }else {
                self.noDataViewTopMargin = 120;
                [self showNoDataImage];
            }
        }];
    }
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return [tableView fd_heightForCellWithIdentifier:kGBMoreCommentListCellID cacheByIndexPath:indexPath configuration:^(GBMoreCommentListCell *cell) {
        [self configureCommentListCell:cell atIndexPath:indexPath];
   }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // MARK: 评价
    GBMoreCommentListCell *commentCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!commentCell) {
        commentCell = [[GBMoreCommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBMoreCommentListCellID];
    }
    
    [self configureCommentListCell:commentCell atIndexPath:indexPath];
    
    return commentCell;
}

- (void)configureCommentListCell:(GBMoreCommentListCell *)cell atIndexPath:(NSIndexPath *)atIndexPath {
    cell.commentModel = self.comments[atIndexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [[NSMutableArray alloc] init];
    }
    
    return _comments;
}

#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
