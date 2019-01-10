//
//  GBAssureContentEditViewController.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/18.
//  Copyright © 2018年 刘小坤. All rights reserved.
//
//  @abstract 新增保过服务
//  @discussion <#类的功能#>
//

#import "GBAssureContentEditViewController.h"

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
#import "HXTagsCell.h"


static NSString *const kGBSettingCellID = @"GBSettingCell";
static NSString *const kGBPersonalSectionHeadViewID = @"GBPersonalSectionHeadView";

static NSInteger const kTextViewTag = 1024;

@interface GBAssureContentEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FSTextView *textView;
/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;//tagsView

/* 联系方式 */
@property (nonatomic, strong) XKTextField *textField;

/* 联系方式 */
@property (nonatomic, copy) NSString *contactType;

@property (nonatomic,strong) HXTagCollectionViewFlowLayout *layout;//布局layout
/* 标签 */
@property (nonatomic, strong) NSMutableArray *tags;

/* <#describe#> */
@property (nonatomic, strong) NSMutableArray <GBAssureContentTagModel *>*tagModels;

/* <#describe#> */
@property (nonatomic, assign) NSInteger tagViewHeight;
/* <#describe#> */
@property (nonatomic, strong) HXTagAttribute *tagAttribute;

@end

@implementation GBAssureContentEditViewController

#pragma mark - # LifeCyle

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"服务内容";
    [self headerRereshing];
    
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.mj_header = nil;
    self.baseTableView.mj_footer = nil;
    self.baseTableView.sectionHeaderHeight = 50;
    self.baseTableView.sectionFooterHeight = 0.00001;
    [self.baseTableView registerClass:[GBSettingCell class] forCellReuseIdentifier:kGBSettingCellID];
    [self.view addSubview:self.baseTableView];
    
    self.baseTableView.tableHeaderView = [self setupBigTitleHeadViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) title:@"服务内容"];
    
    [self.view addSubview:[self setupBottomViewWithtitle:@"完成"]];
    @GBWeakObj(self);
    self.didClickBaseBottomButton = ^{
        @GBStrongObj(self);
        if (!self.selectTags.count) {
            return [UIView showHubWithTip:@"请选择服务"];
        }
        
        // 遍历标签模型，取出选中标签
        NSMutableArray *tempModelArray = [NSMutableArray array];
        for (GBAssureContentTagModel *tagModel in self.tagModels) {
            for (int i = 0; i< self.selectTags.count; i++) {
                if ([tagModel.labelName isEqualToString:self.selectTags[i]]) {
                    [tempModelArray addObject:tagModel];
                    if (tempModelArray.count == self.selectTags.count) {
                        break;
                    }
                }
            }
        }
        
        !self.completeOperationBlock ? : self.completeOperationBlock(tempModelArray,self.selectTags,self.textView.text);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
}

#pragma mark - # Setup Methods

#pragma mark - # Event Response
- (void)headerRereshing {
    [super headerRereshing];
    [self getTagsData];
}

// 热门服务推荐
- (void)getTagsData {
    GBMineViewModel *mineVM = [[GBMineViewModel alloc] init];
    [mineVM loadRequestMineassurePassLabels];
    [mineVM setSuccessReturnBlock:^(id returnValue) {
        self.tagModels = [GBAssureContentTagModel mj_objectArrayWithKeyValuesArray:returnValue];
        // 取出职位名称作为标签源
        for (GBAssureContentTagModel *tagModel in self.tagModels) {
            [self.tags addObject:tagModel.labelName];
        }

        self.tagViewHeight = [HXTagsCell getCellHeightWithTags:self.tags layout:self.layout tagAttribute:self.tagAttribute width:SCREEN_WIDTH];

        [self.baseTableView reloadData];
        
    }];
}

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
    return indexPath.section == 0 ? self.tagViewHeight : 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GBPersonalSectionHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGBPersonalSectionHeadViewID];
    if (!headerView) {
        headerView = [[GBPersonalSectionHeadView alloc] initWithReuseIdentifier:kGBPersonalSectionHeadViewID];
    }
    headerView.titleLabel.text = section == 0 ? @"热门服务推荐" : @"服务描述（选填）";
    headerView.moreButton.hidden = YES;
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HXTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (!cell) {
            cell = [[HXTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        }
        
        cell.tags = self.tags;
        
        cell.selectedTags = [NSMutableArray arrayWithArray:_selectTags];
        cell.layout = self.layout;
        cell.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
            NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
            self.selectTags = [NSMutableArray arrayWithArray:selectTags];
        };
        
        cell.isMultiSelect = YES;
        cell.maxSelectCount = 5;
        cell.minSelectCount = 1;
        
        cell.tagAttribute = self.tagAttribute;

        [cell reloadData];
        
        return cell;
    }
    
    static NSString *identifier = @"serviceDescriptionID";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (indexPath.section == 1) {
            // FSTextView
            FSTextView *textView = [FSTextView textView];
            textView.placeholder = @"请输入您的服务描述";
            textView.placeholderFont = Fit_Font(12);
            textView.maxLength = 2000;
            textView.editable = YES;
            textView.text = self.contentStr;
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
                make.top.mas_equalTo(cell.contentView).offset(GBMargin/2);
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
- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [[NSMutableArray alloc] initWithArray:@[]];
    }
    
    return _tags;
}

- (NSMutableArray *)tagModels {
    if (!_tagModels) {
        _tagModels = [[NSMutableArray alloc] init];
    }
    
    return _tagModels;
}

- (NSMutableArray *)selectTags {
    if (!_selectTags) {
        _selectTags = [[NSMutableArray alloc] init];
    }
    
    return _selectTags;
}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - GBMargin*2, 40)];
    }
    return _tagsView;
}

- (HXTagCollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [HXTagCollectionViewFlowLayout new];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.minimumInteritemSpacing = 10;
        _layout.minimumLineSpacing = 10;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsZero;
        _layout.itemSize = CGSizeMake(64,30);
        _layout.sectionInset = UIEdgeInsetsMake(15.0f, GBMargin, 15.0f, GBMargin);
    }
    return _layout;
}

- (HXTagAttribute *)tagAttribute {
    if (!_tagAttribute) {
        _tagAttribute = [[HXTagAttribute alloc] init];
        _tagAttribute.cornerRadius = 15;
        _tagAttribute.tagSpace = GBMargin*2;
        _tagAttribute.titleSize = 14;
        _tagAttribute.borderColor = [UIColor kSegmentateLineColor];
        _tagAttribute.borderWidth = 0.5;
        _tagAttribute.selectedTextColor = [UIColor kBaseColor];
        _tagAttribute.textColor = [UIColor kNormoalInfoTextColor];
        _tagAttribute.selectedBackgroundColor = [UIColor colorWithHexString:@"#F7F5FD"];
        _tagAttribute.normalBackgroundColor = [UIColor whiteColor];
        _tagAttribute.selectBorderColor = [UIColor kBaseColor];
    }
    
    return _tagAttribute;
}

// 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // 清除图片缓存
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end
