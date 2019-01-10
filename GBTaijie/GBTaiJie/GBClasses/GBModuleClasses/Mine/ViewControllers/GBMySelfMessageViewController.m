//
//  GBMySelfMessageViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/2.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBMySelfMessageViewController.h"
#import "GBChangeMineInfoViewController.h"
#import "GBSkillsModel.h"
#import "GBPastExperienceViewController.h"
#import "GBAddStoryViewController.h"
#import "GBAddGoodAtTerritoryViewController.h"
#import "GBAddEducationExperienceViewController.h"
#import "SelectCityViewController.h"

/** 照片选择 */
#import "XKSelPhotos.h"

#import "GBSettingCell.h"
#import "UserModel.h"
#import "GBAddSkillsViewController.h"
#import "GBAddPastExperienceViewController.h"

@interface GBMySelfMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/* imageView */
@property (strong , nonatomic)UIImageView *headImageView;

/* 标题 */
@property (nonatomic, strong) NSArray *titles;

/* <#describe#> */
@property (nonatomic, assign) NSInteger skillsCount;


/* 个人信息模型 */
@property (nonatomic, strong) UserModel *userModel;

@end

static NSString *const kGBSettingCellID = @"GBSettingCell";

@implementation GBMySelfMessageViewController

#pragma mark - LifeCyle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userModel = userManager.currentUser;
    [self.baseTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"修改个人资料";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getPersonalInfoData];
    [self setUpTab];
}

#pragma mark - # Data
- (void)getPersonalInfoData {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestPersonalEditInfo];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.userModel = [UserModel mj_objectWithKeyValues:returnValue];
        [userManager saveCurrentUser:self.userModel];
        
        self.skillsCount = self.userModel.skills.count;
        [self.baseTableView reloadData];
    }];
}

// 保存信息
- (void)saveInfoRequestAction:(MySelfInfoChangeType )changeInfoType {
    NSDictionary *param;
    switch (changeInfoType) {
        case MySelfInfoChangeTypeSex:
        {
            // 性别
            if (!ValidStr(self.userModel.sex)) {
                return [UIView showHubWithTip:@"选择性别"];
            }
            param = @{
                      @"sex":self.userModel.sex,
                      };
        }
            break;
        case MySelfInfoChangeTypeBirthday:
        {
            // 生日
            if (!ValidStr(self.userModel.birthday)) {
                return [UIView showHubWithTip:@"选择生日"];
            }
            
            param = @{
                      @"birthday":self.userModel.birthday,
                      };
        }
            break;
        case MySelfInfoChangeTypeCity:
        {
            // 城市
            if (!ValidStr(self.userModel.city)) {
                return [UIView showHubWithTip:@"选择城市"];
            }
            
            param = @{
                      @"city":self.userModel.city,
                      };
        }
            break;
            
        default:
            break;
    }
    
    // 更新
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestPersonalEditInfoUpdate:param];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        [userManager saveCurrentUser:self.userModel];
        [UIView showHubWithTip:@"更新成功"];
        [self.baseTableView reloadData];
        
        [GBAppDelegate setupJAnalyticsUserInfoEvent];
    }];
}

#pragma mark - initizlize
- (void)setUpTab {
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 0.00001;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    self.baseTableView.backgroundColor = self.view.backgroundColor;
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"个人资料"];
}

#pragma mark - <UITableViewDelegate、UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return GBMargin;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 80 : 50 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserModel *userInfo = userManager.currentUser;
    GBSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GBSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGBSettingCellID];
    }
    
    if (indexPath.section == 0 ) {
        cell.cellType = CellTypeIconImageView;
        cell.line.hidden = YES;
        [cell.contentImageView sd_setImageWithURL:GBImageURL(userInfo.headImg) placeholderImage:PlaceholderHeadImage];
    }else {
        cell.titleLabel.text = self.titles[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
            {
                cell.contentTextField.text = [GBAppHelper objectSafeCheck:self.userModel.nickName];
            }
                break;
            case 1:
            {
                cell.contentTextField.text = ([[GBAppHelper objectSafeCheck:self.userModel.sex] isEqualToString:@"MALE"] ? @"男" : [[GBAppHelper objectSafeCheck:self.userModel.sex] isEqualToString:@"FEMALE"] ? @"女": @"");
            }
                break;
            case 2:
            {
                cell.cellType = CellTypeDetailsDatePicker;
                cell.contentTextField.text = [GBAppHelper objectSafeCheck:self.userModel.birthday];
                cell.contentTextField.clearButtonMode = UITextFieldViewModeNever;
                cell.datePickerClickedBlock = ^(NSString *dateStr) {
                    self.userModel.birthday = dateStr;
                    // 保存生日
                    [self saveInfoRequestAction:MySelfInfoChangeTypeBirthday];
                };
            }
                break;
            case 3:
            {
                cell.contentTextField.text = self.userModel.city;

            }
                break;
            case 4:
            {
                cell.contentTextField.text = [GBAppHelper objectSafeCheck:GBNSStringFormat(@"%zu",self.skillsCount)];
            }
                break;
            case 5:
            {
                cell.contentTextField.text = GBNSStringFormat(@"%zu",self.userModel.microExperienceCount);
            }
                break;
            case 6:
            {
                cell.contentTextField.text = ValidStr(self.userModel.story) ? @"已添加" : @"未添加";
            }
                break;
            case 7:
            {
                cell.contentTextField.text = self.userModel.schoolFilled ? @"已添加" : @"未添加";
            }
                break;
            default:
                break;
        }
        cell.contentTextField.textAlignment = NSTextAlignmentRight;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 修改头像
        return [self changeProfileImage:self.userModel];
    }
    
    if (indexPath.row == 0) {
        // 修改昵称
        GBChangeMineInfoViewController *changeInfoVC = [[GBChangeMineInfoViewController alloc] init];
        changeInfoVC.changeInfoType = ChangeInfoTypeNick;
        changeInfoVC.userModel = self.userModel;
        changeInfoVC.saveBlock = ^(NSString *inputStr) {
            self.userModel.nickName = inputStr;
        };
        
        [self.navigationController pushViewController:changeInfoVC animated:YES];
    }
    
    if (indexPath.row == 1) {
        if ([self.userModel.sex isEqualToString:@"MALE"] || [self.userModel.sex isEqualToString:@"FEMALE"]) {
            return [UIView showHubWithTip:@"性别不可更改"];
        }
        
        // 修改性别
        return [self changeSex:self.userModel];
    }
    if (indexPath.row == 3) {
        SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
        selectCityVC.isPersonal = YES;
        selectCityVC.cityBlock = ^(CityModel *city) {
            self.userModel.city = city.regionName;
            // 保存城市
            [self saveInfoRequestAction:MySelfInfoChangeTypeCity];
        };
        
        [self.navigationController pushViewController:selectCityVC animated:YES];
    }
    
    if (indexPath.row == 4) {
        // 擅长技能
        GBAddGoodAtTerritoryViewController *addSkillsVC = [[GBAddGoodAtTerritoryViewController alloc] init];
        NSMutableArray <GBSkillsModel *> *skills = [GBSkillsModel mj_objectArrayWithKeyValuesArray:self.userModel.skills];
        for (GBSkillsModel *skillsModel in skills) {
            [addSkillsVC.tags addObject:skillsModel.skillName];
        }
        addSkillsVC.addSkillsBlock = ^(NSArray *dataArray) {
            self.skillsCount = dataArray.count;
            [self.baseTableView reloadData];
        };
        
        [self.navigationController pushViewController:addSkillsVC animated:YES];
        return;
    }
    
    if (indexPath.row == 5) {
        // 过往经验
        if (self.userModel.microExperienceCount > 0) {
            GBPastExperienceViewController *pastExpericenceVC = [[GBPastExperienceViewController alloc] init];
            [self.navigationController pushViewController:pastExpericenceVC animated:YES];
        }else {
            // 新增过往经验
            GBAddPastExperienceViewController *addPastExperienceVC = [[GBAddPastExperienceViewController alloc] init];
            addPastExperienceVC.addPastExperienceType = AddPastExperienceTypeNew;
            [self.navigationController pushViewController:addPastExperienceVC animated:YES];
        }
       
    }
    
    if (indexPath.row == 6) {
        GBAddStoryViewController *addStoryVC = [[GBAddStoryViewController alloc] init];
        addStoryVC.userModel = self.userModel;
        [self.navigationController pushViewController:addStoryVC animated:YES];
    }
    
    if (indexPath.row == 7) {
        GBAddEducationExperienceViewController *addEducationExperienceVC = [[GBAddEducationExperienceViewController alloc] init];
        [self.navigationController pushViewController:addEducationExperienceVC animated:YES];
    }
    
    
}

#pragma mark - 改变用户性别
- (void)changeSex:(UserModel *)userInfo {
    [self ActionSheetWithTitle:nil message:nil destructive:nil destructiveAction:nil andOthers:@[@"取消",@"男",@"女"] animated:YES action:^(NSInteger index) {
        if (index == 0) {
            return ;
        }
        if (index == 1) {
            if (![userInfo.sex isEqualToString:@"MALE"]) {
                userInfo.sex = @"MALE";
            }
        }else if (index == 2) {
            if (![userInfo.sex isEqualToString:@"FEMALE"]) {
                userInfo.sex = @"FEMALE";
            }
        }
        
        [self AlertWithTitle:@"提示" message:@"性别一旦选择不可更改，请谨慎选择" andOthers:@[@"取消",@"确定"] animated:YES action:^(NSInteger index) {
            if (index == 0) {
                return ;
            }
            if (index == 1) {
                // 保存性别
                [self saveInfoRequestAction:MySelfInfoChangeTypeSex];
            }
        }];
        
        
    }];
}

#pragma mark - 更换头像
- (void)changeProfileImage:(UserModel *)userInfo {
    [self ActionSheetWithTitle:nil message:nil destructive:nil destructiveAction:nil andOthers:@[@"取消",@"更换头像"] animated:YES action:^(NSInteger index) {
        if (index == 1) {
            XKSelPhotos *imageManager = [XKSelPhotos selPhotos];
            [imageManager pushImagePickerControllerWithImagesCount:1 WithColumnNumber:3 didFinish:^(TZImagePickerController *imagePickerVc) {
                [self presentViewController:imagePickerVc animated:YES completion:nil];
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    [self updateUserImage:[photos lastObject]];
                }];
            }];
        }
    }];
}

/** 更新用户头像 */
- (void)updateUserImage:(UIImage *)image {
    // 判断图片是不是png格式的文件
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    if (UIImagePNGRepresentation(image)) {
        // 返回为png图像。
    }else if (imageData){
        // 返回为JPEG图像
    }else {
        [UIView showHubWithTip:@"请上传 jpeg或是png格式"];
        return;
    }
    
    [[NetDataServer sharedInstance] requestURL:URL_IMAGE_GetQiuNiuUpToken httpMethod:@"POST" headerParams:nil params:nil file:nil success:^(id responseData) {
        if([responseData[@"result"] integerValue] == 1)
        {
            NSString *token = responseData[@"data"][@"upToken"];
            //华北
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.zone = [QNFixedZone zone1];
            }];
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
            [upManager putData:imageData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                self.headImageView.image = image;
                GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
                [mineVM loadRequestPersonalEditInfoUpdate:@{@"headImg":resp[@"key"]}];
                [mineVM setSuccessReturnBlock:^(id returnValue) {
                    UserModel *user = userManager.currentUser;
                    user.headImg = resp[@"key"];
                    [userManager saveCurrentUser:user];
                    
                    [self.baseTableView reloadData];
                    
                    // 更新用户IM头像信息
                    [[IMManager sharedIMManager] updateIMUserInfo:imageData userFieldType:kJMSGUserFieldsAvatar];
                }];
            } option:nil];
        }
        
    }fail:^(NSError *error) {
        NSLog(@"更新七牛云token error:%@",error);
    }];
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"昵称",@"性别",@"生日",@"所在城市",@"擅长领域",@"过往经验",@"我的故事",@"教育经历"];
    }
    
    return _titles;
}

@end
