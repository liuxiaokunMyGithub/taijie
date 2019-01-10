//
//  GBDecryptionEditorViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 服务新增编辑
//  @discussion <#类的功能#>
//


#import "GBDecryptionEditorViewController.h"

// Controllers
/** 内容 */
#import "GBDecryptContentEditViewController.h"
/** 保过职位信息编辑 */
#import "GBAssuredEditPoistionInfoViewController.h"
/** 保过服务内容 */
#import "GBSubscribeMessageViewController.h"

// ViewModels


// Models
#import "GBServiceEditModel.h"

// Views
/** 解密类型 */
#import "CurrentStatusPopView.h"
#import "GBSettingCell.h"

static NSString *const kGBSettingCellID = @"GBSettingCell";

@interface GBDecryptionEditorViewController ()<UITableViewDelegate,UITableViewDataSource>

/* 标题 */
@property (nonatomic, strong) NSArray <NSArray *>*titleArr;
/* 服务类型 */
@property (nonatomic, strong) NSArray *typeStrArr;
/** 后台类型字符 */
@property (strong, nonatomic) NSArray *typeStateCodeArr;

@property (nonatomic, strong) GBServiceEditModel *tempModel;

/* 保过服务职位编辑 */
@property (nonatomic, strong)  GBAssuredEditPoistionInfoViewController *assuredEditPoistionVC;

@end

@implementation GBDecryptionEditorViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.baseTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"解密服务编辑";

    [self setBigTitle];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.rowHeight = 56;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 15;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    
    [self.view addSubview:[self setupBottomViewWithtitle:@"保存"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
        @GBStrongObj(self);
        if (self.serviceType == ServiceTypeNewDecryption || self.serviceType == ServiceTypeEditDecryption) {
            // 保存解密服务
            [self saveDecryptionService];
        }else if (self.serviceType == ServiceTypeNewAssured || self.serviceType == ServiceTypeEditAssured) {
            // 保存保过服务
            [self saveAssuredService];
        }
    };
}


#pragma mark - # Setup Methods
- (void)setBigTitle {
    NSString *titleStr = nil;
    switch (self.serviceType) {
         // 新建解密服务
        case ServiceTypeNewDecryption: {
            titleStr = @"新增私聊";
            self.tempModel.type = @"DECRYPT_GSJM";
            self.tempModel.typeName = @"公司解密";
            self.tempModel.isEnable = YES;

        }
             break;
            // 编辑解密服务
        case ServiceTypeEditDecryption: {
            titleStr = @"私聊编辑";
            [self getIncumbentDecryptInfo];
            self.baseTableView.tableFooterView = [self setupTableViewFooterViewDeleteButton];
        }
             break;
            // 新建保过服务
        case ServiceTypeNewAssured: {
            titleStr = @"新增保过";
            self.tempModel.isEnable = YES;
        }
             break;
            // 编辑保过服务
        case ServiceTypeEditAssured: {
            titleStr = @"保过编辑";
            [self getIncumbentAssuredInfo];
            
            self.baseTableView.tableFooterView = [self setupTableViewFooterViewDeleteButton];

        }
            break;
            
        default:
            break;
    }
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:titleStr];

}

- (UIView *)setupTableViewFooterViewDeleteButton {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UIButton *deleteButton = [UIButton createButtonWithFrame:CGRectMake(GBMargin, 0, 80, 30) text:@"删除该服务" font:Fit_Font(14) textColor:[UIColor kBaseColor] backGroundColor:nil];
    [deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:deleteButton];
    
    return footerView;
}

/** MARK: Data */
// 在职者解密服务详情信息
- (void)getIncumbentDecryptInfo {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineIncumbentDecrypt:self.serviceModel.incumbentDecryptId];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.tempModel = [GBServiceEditModel mj_objectWithKeyValues:returnValue];
        [self.baseTableView reloadData];
    }];
    
}

// 在职者保过服务详情信息
- (void)getIncumbentAssuredInfo {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineIncumbentAssurePass:self.serviceModel.incumbentAssurePassId];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.tempModel = [GBServiceEditModel mj_objectWithKeyValues:returnValue];
        self.assuredEditPoistionVC.tempModel = [GBServiceEditModel mj_objectWithKeyValues:returnValue];
        
        [self.baseTableView reloadData];
    }];
}

// 保存解密服务
- (void)saveDecryptionService {
    if (!ValidStr(self.tempModel.typeName)) {
        return [UIView showHubWithTip:@"请选择解密类型"];
    }
    
    if (!ValidStr(self.tempModel.title) || !ValidStr(self.tempModel.details)) {
        return [UIView showHubWithTip:@"请编辑服务标题内容"];
    }
    
    if (!ValidStr(self.tempModel.price)) {
        return [UIView showHubWithTip:@"请输入价格"];
    }
    
//    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
//    [mineVM loadRequestMineDecryptRenewal:self.tempModel.type typeName:self.tempModel.typeName price:self.tempModel.price title:self.tempModel.title details:self.tempModel.details isEnable:self.tempModel.isEnable incumbentDecryptId:self.tempModel.incumbentDecryptId];
//    [mineVM setSuccessReturnBlock:^(id returnValue) {
//        [self.navigationController popViewControllerAnimated:YES];
//        [UIView showHubWithTip:@"保存成功"];
//    }];
    
}

// 保存保过服务
- (void)saveAssuredService {
    if (!self.assuredEditPoistionVC.tempModel) {
        return [UIView showHubWithTip:@"请选择职位信息"];
    }
    
    if (!ValidStr(self.tempModel.details)) {
        return [UIView showHubWithTip:@"请编辑服务内容"];
    }
    
    if (!ValidStr(self.tempModel.price)) {
        return [UIView showHubWithTip:@"请输入价格"];
    }
    
    NSDictionary *positionDic = @{
                                  @"regionName":self.assuredEditPoistionVC.tempModel.regionName,
                                  @"experienceName":self.assuredEditPoistionVC.tempModel.experienceName,
                                  @"experienceCode":self.assuredEditPoistionVC.tempModel.experienceCode,

                                 
                                  @"dilamorName":self.assuredEditPoistionVC.tempModel.dilamorName,
                                  @"dilamorCode":self.assuredEditPoistionVC.tempModel.dilamorCode,

                                  @"jobId":self.assuredEditPoistionVC.tempModel.jobId,
                                  @"jobName":self.assuredEditPoistionVC.tempModel.jobName,

                                  @"maxSalary":self.assuredEditPoistionVC.tempModel.maxSalary,
                                  @"minSalary":self.assuredEditPoistionVC.tempModel.minSalary,

                                  };
    
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineAssureRenewal:positionDic price:self.tempModel.price content:self.tempModel.details isEnable:self.tempModel.isEnable assurePassId:self.tempModel.assurePassId];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        [self.navigationController popViewControllerAnimated:YES];
        [UIView showHubWithTip:@"保存成功"];
    }];
}

#pragma mark - # Event Response
- (void)deleteButtonAction {
    // 删除服务
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    if (self.serviceType == ServiceTypeNewDecryption || self.serviceType == ServiceTypeEditDecryption ) {
        [mineVM loadRequestMineDeleteIncumbentDecrypt:self.serviceModel.incumbentDecryptId];
    }else if (self.serviceType == ServiceTypeNewAssured || self.serviceType == ServiceTypeEditAssured ) {
        [mineVM loadRequestMineDeleteIncumbentAssurePass:self.serviceModel.incumbentAssurePassId];
    }
    
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        [self.navigationController popViewControllerAnimated:YES];
        [UIView showHubWithTip:@"删除成功"];
    }];
}

#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr[section].count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(GBSettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = self.titleArr[indexPath.section][indexPath.row];
    cell.contentTextField.textAlignment = NSTextAlignmentRight;

    if (indexPath.row == 2) {
        cell.cellType = CellTypeDetailsTextfield;
        cell.contentTextField.placeholder = self.serviceType == ServiceTypeNewDecryption ? @"建议50~500币" : @"建议500~2000币";
        cell.contentTextField.text = self.tempModel.price;
        cell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textValueChangedBlock = ^(NSString *valueStr) {
            self.tempModel.price = valueStr;
        };
        
        cell.indicateButton.hidden = YES;
    }else {
        cell.indicateButton.hidden = NO;
    }
    
    if (indexPath.section == 1) {
        cell.cellType = CellTypeDetailsSwitch;
        cell.setSwitch.on = self.tempModel.isEnable;
        cell.switchChangedBlock = ^(BOOL isOpen) {
            self.tempModel.isEnable = isOpen;
        };
        
        cell.indicateButton.hidden = YES;
    }
   
    if ((indexPath.section == 0)) {
        if (indexPath.row == 0) {
            if (self.serviceType == ServiceTypeNewAssured || self.serviceType == ServiceTypeEditAssured) {
                
                cell.contentTextField.text =
                self.tempModel.jobName;
            }else {
                cell.contentTextField.text = self.tempModel.typeName;
            }
        }
        
        if (indexPath.row == 1) {
            if (self.serviceType == ServiceTypeNewAssured || self.serviceType == ServiceTypeEditAssured) {
               cell.contentTextField.text = self.tempModel.details;
            }else {
                cell.contentTextField.text = self.tempModel.title;

            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.serviceType == ServiceTypeNewDecryption || self.serviceType == ServiceTypeEditDecryption) {
        // MARK: 解密服务
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    /**类型*/
                    CurrentStatusPopView *statusV = [[CurrentStatusPopView alloc] initWithStatusArray:self.typeStrArr andSelectedStatus:self.tempModel.typeName];
                    statusV.titleStr = @"选择类型";
                    [statusV setSelectBlock:^(NSString *typeStr) {
                        self.tempModel.typeName = typeStr;
                        for (NSInteger i = 0; i < self.typeStateCodeArr.count; i++) {
                            if ([self.typeStrArr[i] isEqualToString:typeStr]) {
                                self.tempModel.type = self.typeStateCodeArr[i];
                                break;
                            }
                        }
                        
                        [self.baseTableView reloadData];
                        
                    }];
                    [statusV show];
                }
                    break;
                case 1:
                {
                    GBDecryptContentEditViewController *contentEditVC = [[GBDecryptContentEditViewController alloc] init];
                    contentEditVC.contentSaveBlock = ^(NSString *titleStr, NSString *contentStr) {
                        self.tempModel.title = titleStr;
                        self.tempModel.details = contentStr;
                        
                        [self.baseTableView reloadData];
                    };
                    [self.navigationController pushViewController:contentEditVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }else if (self.serviceType == ServiceTypeNewAssured || self.serviceType == ServiceTypeEditAssured) {
        // MARK: 保过服务
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    self.assuredEditPoistionVC.tempModel = self.tempModel;
                    @GBWeakObj(self);
                    self.assuredEditPoistionVC.didClickSaveButtonBlock = ^(GBServiceEditModel *editPoistionTempModel) {
                    @GBStrongObj(self);
                        self.tempModel.jobName = editPoistionTempModel.jobName;
                    };
                    
                    [self.navigationController pushViewController:self.assuredEditPoistionVC animated:YES];
                }
                    break;
                case 1:
                {
                    // 进入留言
                    GBSubscribeMessageViewController *subscribeMessageVC = [[GBSubscribeMessageViewController alloc] init];
                    subscribeMessageVC.saveButtonClickBlock = ^(NSString *valueStr) {
                        // 保存服务内容
                        self.tempModel.details = valueStr;
                        [self.baseTableView reloadData];
                    };
                    subscribeMessageVC.inputShowType = InputShowTypeAssuredContent;
                    [self.navigationController pushViewController:subscribeMessageVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

#pragma mark - # Getters and Setters
- (NSArray <NSArray *> *)typeStrArr {
    if (!_typeStrArr) {
        _typeStrArr = @[@"公司解密", @"求职能力", @"专业技能", @"职业规划", @"职场生存", @"创业辅导", @"其他"];
    }
    
    return _typeStrArr;
}

- (NSArray <NSArray *> *)titleArr {
    if (!_titleArr) {
        if (self.serviceType == ServiceTypeNewDecryption || self.serviceType == ServiceTypeEditDecryption) {
            _titleArr = @[@[@"私聊方向", @"私聊服务内容", @"价格"], @[@"开启此项服务"]];
        }else if (self.serviceType == ServiceTypeNewAssured || self.serviceType == ServiceTypeEditAssured) {
            _titleArr = @[@[@"职位信息", @"保过服务内容", @"价格"], @[@"开启此项服务"]];
        }
    }
    
    return _titleArr;
}

- (NSArray *)typeStateCodeArr {
    if (!_typeStateCodeArr) {
        _typeStateCodeArr = @[@"DECRYPT_GSJM", @"DECRYPT_QZNL", @"DECRYPT_ZYJN", @"DECRYPT_ZYGH", @"DECRYPT_ZCSC", @"DECRYPT_CYFD", @"DECRYPT_QT"];
    }
    
    return _typeStateCodeArr;
}

- (GBServiceEditModel *)tempModel {
    if (!_tempModel) {
        _tempModel = [[GBServiceEditModel alloc] init];
    }
    
    return _tempModel;
}

- (GBAssuredEditPoistionInfoViewController *)assuredEditPoistionVC {
    if (!_assuredEditPoistionVC) {
        _assuredEditPoistionVC = [[GBAssuredEditPoistionInfoViewController alloc] init];
    }
    
    return _assuredEditPoistionVC;
}
// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end


