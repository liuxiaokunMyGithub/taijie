//
//  GBFeedbackViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/7/25.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 反馈
//  @discussion <#类的功能#>
//

#import "GBFeedbackViewController.h"

 

// Controllers

// ViewModels


// Models


// Views
#import "GBPersonalSectionHeadView.h"
#import "GBSettingCell.h"
#import "FSTextView.h"
#import "GBLIRLButton.h"
#import "HXTagsView.h"
#import "XKTextField.h"


static NSString *const kGBSettingCellID = @"GBSettingCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

static NSInteger const kTextViewTag = 1024;

@interface GBFeedbackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FSTextView *textView;
/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;//tagsView

/* 联系方式 */
@property (nonatomic, strong) XKTextField *textField;

/* 联系方式 */
@property (nonatomic, copy) NSString *contactType;

@end

@implementation GBFeedbackViewController

#pragma mark - # LifeCyle

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"反馈";
    
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 60;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) title:@"反馈"];
    
    self.baseTableView.tableFooterView = [self coustomFooterView];
    
    [self.view addSubview:[self setupBottomViewWithtitle:@"提交"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
        @GBStrongObj(self);
        
        if (ValidStr(self.textField.text)) {
            if ([self.contactType isEqualToString:@"MOBILE"] && (![GBAppHelper isMobileNumber:self.textField.text])) {
                return [UIView showHubWithTip:@"手机号码格式有误"];
            }
            
            if ([self.contactType isEqualToString:@"EMAIL"] && (![GBAppHelper validationEmail:self.textField.text])) {
                return [UIView showHubWithTip:@"邮箱格式有误"];
            }
        }
        
        
        // 提交反馈
        GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
        [mineVM loadRequestMineFeedBack:self.textView.text contactType:self.contactType contactDetail:self.textField.text];
        [mineVM setSuccessReturnBlock:^(id returnValue) {
            [UIView showHubWithTip:@"提交成功，谢谢您的宝贵意见"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    };
}

#pragma mark - # Setup Methods
- (UIView *)coustomFooterView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    [self setupButton:footView];
    
    XKTextField *textField = [[XKTextField alloc] init];
    textField.placeholder = @"请留下您的联系方式，以便我们与您沟通。";
    textField.font = Fit_Font(12);
    textField.margin = 8;
    [footView addSubview:textField];

    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagsView.mas_bottom).offset(5);
        make.left.mas_equalTo(footView).offset(GBMargin);
        make.right.mas_equalTo(footView).offset(-GBMargin);
        make.height.mas_equalTo(48);
    }];
    
    GBViewBorderRadius(textField, 2, 0.5, [UIColor kSegmentateLineColor]);
    self.textField = textField;
    
    return footView;
}

- (void)setupButton:(UIView *)footView {
    NSArray *titles = @[@"微信号",@"手机号",@"邮箱"];
    //多行不滚动多选
    HXTagCollectionViewFlowLayout *flowLayout = [[HXTagCollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-GBMargin*2)/3,30);
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, GBMargin, 10.0f, 10.0f);
    self.tagsView.layout = flowLayout;
    self.tagsView.coustomSelectedTagIcons = [NSMutableArray arrayWithArray:@[GBImageNamed(@"userAgreementSel"),GBImageNamed(@"userAgreementSel"),GBImageNamed(@"userAgreementSel")]];
    
    self.tagsView.coustomNormalTagIcons = [NSMutableArray arrayWithArray:@[GBImageNamed(@"userAgreement"),GBImageNamed(@"userAgreement"),GBImageNamed(@"userAgreement")]];
    
    self.tagsView.isMultiSelect = NO;
    self.tagsView.tagAttribute.borderWidth = 0;
    self.tagsView.tagAttribute.tagSpace = GBMargin*2;
    self.tagsView.tagAttribute.titleSize = 16;
    self.tagsView.tagAttribute.selectedBackgroundColor = [UIColor whiteColor];
    self.tagsView.tagAttribute.selectedTextColor = [UIColor kImportantTitleTextColor];
    self.tagsView.tagAttribute.textColor = [UIColor kImportantTitleTextColor];
    
    self.tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.tagsView.tags = titles;
    // 默认联系方式微信
    self.tagsView.selectedTags = [@[@"微信号"] mutableCopy];
    self.contactType = @"WX";
    [footView addSubview:self.tagsView];
    @GBWeakObj(self);
    self.tagsView.completion = ^(NSArray *selectTags, NSInteger currentIndex) {
        @GBStrongObj(self);
        NSLog(@"selectTags %@ currentIndex %zu",selectTags,currentIndex);
        self.contactType = currentIndex == 0 ? @"WX" : currentIndex == 1 ? @"MOBILE" : @"EMAIL";
    };
    
    [self.tagsView reloadData];
}

#pragma mark - # Event Response


#pragma mark - # Privater Methods


#pragma mark - # Delegate
/**  MARK: - tableview delegate / dataSource  */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 160 : 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = section == 0 ? @"反馈意见" : @"联系方式";
    headerView.moreButton.hidden = YES;
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"feedbackId";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (indexPath.section == 0) {
            // FSTextView
            FSTextView *textView = [FSTextView textView];
            textView.placeholder = @"请详细的写出您的意见或建议，我们非常重视你的宝贵意见或者建议，并将尽快处理。";
            textView.placeholderFont = Fit_Font(12);
            textView.editable = YES;
            textView.maxLength = 2000;
            // 添加输入改变Block回调.
            [textView addTextDidChangeHandler:^(FSTextView *textView) {
                NSLog(@"textView.text %@",textView.text);
            }];
            
            textView.backgroundColor = [UIColor clearColor];
            
            textView.tag = kTextViewTag;
            [cell.contentView addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView).offset(GBMargin);
                make.right.mas_equalTo(cell.contentView).offset(-GBMargin);
                make.top.mas_equalTo(cell.contentView);
                make.bottom.mas_equalTo(cell.contentView);
            }];
            
            GBViewBorderRadius(textView, 2, 0.5, [UIColor kSegmentateLineColor]);
            
            self.textView = textView;

        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - # Getters and Setters
- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - GBMargin*2, 40)];
    }
    return _tagsView;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
