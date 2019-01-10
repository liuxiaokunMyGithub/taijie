//
//  GBMessageViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/13.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 消息
//  @discussion 消息管理中心
//

#import "GBMessageViewController.h"

// Controllers
#import "ConversationViewController.h"
#import "GBSystemMessageViewController.h"
// ViewModels


// Models
#import "GBSystemMessageModel.h"

// Views
#import "GBMessageHeadView.h"
#import "GBMessageCell.h"
/** 小红点 */
#import "RKNotificationHub.h"


static NSString *const kGBMessageCellID = @"GBMessageCell";

@interface GBMessageViewController ()<UITableViewDelegate,UITableViewDataSource,JMSGConversationDelegate,JMessageDelegate> {
    
//    NSInteger cacheCount;
//    NSInteger _unreadCount;

//    BOOL isGetingAllConversation;

}
@property (assign, nonatomic)  NSInteger cacheCount;
@property (assign, nonatomic)  NSInteger unreadCount;
@property (assign, nonatomic)  BOOL isGetingAllConversation;

/* 表头 */
@property (nonatomic, strong) GBMessageHeadView *messageHeadView;
@property (strong, nonatomic)  NSMutableArray *conversationArr;
/* <#describe#> */
@property (nonatomic, strong)  GBSystemMessageModel *systemMessageModel;

@property (nonatomic, strong) RKNotificationHub *hubBadgeView;

@end

@implementation GBMessageViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadLastSystemMessage];

    [self.baseTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"消息";
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil; 
    self.baseTableView.rowHeight = 80;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBMessageCell class] forCellReuseIdentifier:kGBMessageCellID];
    [self.view addSubview:self.baseTableView];
    
    [self setupSubView];
    
    
    [self dBMigrateFinish];

}

#pragma mark - # Setup Methods
- (void)setupSubView {
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"消息"];
//    self.baseTableView.tableHeaderView = self.messageHeadView;
//    self.messageHeadView.messageGridView.didClickBlock = ^(NSInteger tag) {
//        // 九宫格按钮点击
//        NSLog(@"点击tag%zu",tag);
//
//    };
    
//    [self.customNavBar wr_setRightButtonWithTitle:@"全部已读" titleColor:[UIColor kBaseColor]];
//    [self.customNavBar setOnClickRightButton:^{
//        NSLog(@"全部已读");
//    }];
}

#pragma mark - # Event Response
- (void)dBMigrateFinish {
    NSLog(@"Migrate is finish  and get allconversation");
    //    JCHATMAINTHREAD(^{
    //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    });
    
    [self addDelegate];
    [self getConversationList];
}

- (void)loadLastSystemMessage {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestOuterSystemMessage];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.systemMessageModel = [GBSystemMessageModel mj_objectWithKeyValues:returnValue[@"message"]];
        self.systemMessageModel.isRead = [returnValue[@"read"] boolValue];
        [self.baseTableView reloadData];
    }];
}

#pragma mark - # Privater Methods
- (void)addDelegate {
    [JMessage addDelegate:self withConversation:nil];
}

- (void)getConversationList {
    
    if (self.isGetingAllConversation) {
        NSLog(@"is loading conversation list");
        self.cacheCount++;
        return ;
    }
    
    NSLog(@"get allConversation -- start");
    self.isGetingAllConversation = YES;
    
//    [self.addBgView setHidden:YES];
    @GBWeakObj(self);
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
    @GBStrongObj(self);
        GB_MAIN_THREAD(^{
            self.isGetingAllConversation = NO;
            if (error == nil) {
                NSLog(@"获取会话列表 resultObject %@",resultObject);

                self.conversationArr = [self sortConversation:resultObject];
                self.unreadCount = 0;
                for (NSInteger i=0; i < [self.conversationArr count]; i++) {
                    JMSGConversation *conversation = [self.conversationArr objectAtIndex:i];
                    self.unreadCount = self.unreadCount + [conversation.unreadCount integerValue];
                }
                [self saveBadge:self.unreadCount];
            } else {
                self.conversationArr = nil;
                NSLog(@"获取会话列表 error %@",error);
            }
            
//            if (self.conversationArr.count) {
//                [self removeNoDataImage];
//            }else {
//                self.noDataViewTopMargin = SCREEN_WIDTH/2;
//                [self showNoDataImage];
//            }
            
            [self.baseTableView reloadData];
            NSLog(@"get allConversation -- end");
            self.isGetingAllConversation = NO;
            [self checkCacheGetAllConversationAction];
        });
    }];
}

#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"latestMessage.timestamp" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    
    NSArray *sortedArray = [conversationArr sortedArrayUsingDescriptors:sortDescriptors];
    
    return [NSMutableArray arrayWithArray:sortedArray];
    
    //    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
    //    return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)checkCacheGetAllConversationAction {
    if (self.cacheCount > 0) {
        NSLog(@"is have cache ,once again get all conversation");
        self.cacheCount = 0;
        [self getConversationList];
    }
}

- (void)saveBadge:(NSInteger)badge {
    [[IMManager sharedIMManager] saveUpdateBadge:badge];
}

#pragma mark JMSGMessageDelegate
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    NSLog(@"Action -- onReceivemessage %@",message.serverMessageId);
    [self getConversationList];
}

- (void)onConversationChanged:(JMSGConversation *)conversation {
    NSLog(@"Action -- onConversationChanged");
    //    [self getConversationList];
    [self onSyncReloadConversationListWithConversation:conversation];
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
    NSLog(@"Action -- onGroupInfoChanged");
    [self getConversationList];
}

- (void)onSyncOfflineMessageConversation:(JMSGConversation *)conversation
                         offlineMessages:(NSArray<__kindof JMSGMessage *> *)offlineMessages {
    NSLog(@"Action -- onSyncOfflineMessageConversation:offlineMessages:");
    
    //    [self getConversationList];
    [self onSyncReloadConversationListWithConversation:conversation];
}

- (void)onSyncRoamingMessageConversation:(JMSGConversation *)conversation {
    NSLog(@"Action -- onSyncRoamingMessageConversation:");
    
    //    [self getConversationList];
    [self onSyncReloadConversationListWithConversation:conversation];
}

- (void)onSyncReloadConversationListWithConversation:(JMSGConversation *)conversation {
    if (!conversation) {
        return ;
    }
    BOOL isHave = NO;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *newUser = (JMSGUser *)conversation.target;
        for (int i = 0; i < _conversationArr.count; i++) {
            JMSGConversation *oldConversation = _conversationArr[i];
            if (oldConversation.conversationType == kJMSGConversationTypeSingle) {
                JMSGUser *oldUser = (JMSGUser *)oldConversation.target;
                if ([newUser.username isEqualToString:oldUser.username] && [newUser.appKey isEqualToString:oldUser.appKey]) {
                    [_conversationArr replaceObjectAtIndex:i withObject:conversation];
                    isHave = YES;
                    break ;
                }
            }
        }
    }else{
        JMSGGroup *newGroup = (JMSGGroup *)conversation.target;
        for (int i = 0; i < _conversationArr.count; i++) {
            JMSGConversation *oldConversation = _conversationArr[i];
            if (oldConversation.conversationType == kJMSGConversationTypeGroup) {
                JMSGGroup *oldGroup = (JMSGGroup *)oldConversation.target;
                if ([newGroup.gid isEqualToString:oldGroup.gid]) {
                    [_conversationArr replaceObjectAtIndex:i withObject:conversation];
                    isHave = YES;
                    break ;
                }
            }
        }
    }
    if (!isHave) {
        [_conversationArr insertObject:conversation atIndex:0];
    }
    _conversationArr = [self sortConversation:_conversationArr];
    _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
    [self saveBadge:_unreadCount];
    [self.baseTableView reloadData];
}

#pragma mark - # Delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row == 0 ? NO : YES;
}

//添加两个按钮（编辑按钮和删除按钮）
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewRowAction *deleteRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            [self AlertWithTitle:@"提示" message:@"删除此会话?" andOthers:@[@"取消",@"删除"] animated:YES action:^(NSInteger index) {
                if (index == 1) {
                    JMSGConversation *conversation = [self.conversationArr objectAtIndex:indexPath.row-1];

                    JMSGUser *targetUser = (JMSGUser *)conversation.target;
                  BOOL delete = [JMSGConversation deleteSingleConversationWithUsername:targetUser.username];
                    if (delete) {
                        [UIView showHubWithTip:@"删除成功"];
                        
                        [self.conversationArr removeObjectAtIndex:indexPath.row-1];
                        [self.baseTableView reloadData];
                    }else {
                        [UIView showHubWithTip:@"删除失败"];
                    }
                }
            }];
        }];
        return  @[deleteRow];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBMessageCellID];
    }

    if (indexPath.row == 0) {
        cell.systemMessageModel = self.systemMessageModel;
    }else {
        JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row-1];
        [cell setCellDataWithConversation:conversation];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        GBSystemMessageViewController *systemMessageVC = [[GBSystemMessageViewController alloc] init];
        [self.navigationController pushViewController:systemMessageVC animated:YES];
        
        return;
    }
    
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row-1];
    ConversationViewController *conversationVC = [[ConversationViewController alloc] init];
    conversationVC.conversation = conversation;
    [self.navigationController pushViewController:conversationVC animated:YES];
    NSInteger badge = _unreadCount - [conversation.unreadCount integerValue];
    [self saveBadge:badge];
}

#pragma mark - # Getters and Setters

- (NSMutableArray *)conversationArr {
    if (!_conversationArr) {
        _conversationArr = [[NSMutableArray alloc] init];
    }
    
    return _conversationArr;
}

- (GBMessageHeadView *)messageHeadView {
    if (!_messageHeadView) {
        _messageHeadView = [[GBMessageHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    }
    
    return _messageHeadView;
}

- (GBSystemMessageModel *)systemMessageModel {
    if (!_systemMessageModel) {
        _systemMessageModel = [[GBSystemMessageModel alloc] init];
    }
    
    return _systemMessageModel;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
