//
//  GBMoreNewsViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/15.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract <#类的描述#>
//  @discussion <#类的功能#>
//

#import "GBMoreNewsViewController.h"

// Controllers


// ViewModels


// Models
#import "GBNewsModel.h"


// Views
#import "GBNewsOnePicCell.h"

@interface GBMoreNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 职位 */
@property (nonatomic, strong) NSMutableArray <GBNewsModel *> *news;


@end

static NSString *const kGBNewsOnePicCellID = @"GBNewsOnePicCell";

@implementation GBMoreNewsViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewsList];
    [self setupSubView];
}


#pragma mark - # Setup Methods
- (void)setupSubView {
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.rowHeight = 116;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBNewsOnePicCell class] forCellReuseIdentifier:kGBNewsOnePicCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"更多推荐"];
}

- (void)headerRereshing {
    [super headerRereshing];
    [self loadNewsList];
}

- (void)footerRereshing {
    [super footerRereshing];
    [self loadNewsList];
}

- (void)loadNewsList {
    GBHomePageViewModel *homePageVM = [[GBHomePageViewModel alloc] init];
    [homePageVM loadRequestMoreEssays:page pageSize:10];
    [homePageVM setSuccessReturnBlock:^(id returnValue) {
        NSMutableArray *returnDataArray = [GBNewsModel mj_objectArrayWithKeyValuesArray:returnValue];
        if (self.loadingStyle == LoadingDataRefresh) {
            // 刷新数据
            self.news = [NSMutableArray arrayWithArray:returnDataArray];
            
            [self.baseTableView reloadData];
            [self.baseTableView.mj_header endRefreshing];
        }else if (self.loadingStyle == LoadingDataGetMore) {
            // 加载更多
            [self.news addObjectsFromArray:returnDataArray];
            
            [self.baseTableView reloadData];
            if (returnDataArray.count < 10) {
                [self.baseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.baseTableView.mj_footer endRefreshing];
            }
        }
        if (self.news.count) {
            [self removeNoDataImage];
        }else {
            [self showNoDataImage];
        }
    }];
}
#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBNewsOnePicCell *newsCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!newsCell) {
        newsCell = [[GBNewsOnePicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBNewsOnePicCellID];
    }
    newsCell.newsModel = self.news[indexPath.row];
    
    return newsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GBBaseWebViewController *webView = [[GBBaseWebViewController alloc] initWithUrl:GBNSStringFormat(@"%@",self.news[indexPath.row].link)];
    webView.titleStr = @"推荐";
    [self.navigationController pushViewController:webView animated:YES];
}

- (NSMutableArray *)news {
    if (!_news) {
        _news = [[NSMutableArray alloc] init];
    }
    
    return _news;
}

#pragma mark - # Getters and Setters


// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
