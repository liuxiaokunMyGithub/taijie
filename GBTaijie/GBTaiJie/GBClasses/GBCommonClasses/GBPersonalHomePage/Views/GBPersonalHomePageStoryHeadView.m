//
//  GBPersonalHomePageStoryHeadView.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/21.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBPersonalHomePageStoryHeadView.h"
#import "GBLIRLButton.h"

@interface GBPersonalHomePageStoryHeadView ()
/* 背景视图 */
@property (nonatomic, strong) UIImageView *bgView;

/* <#describe#> */
@property (nonatomic, strong) GBLIRLButton *exchangeButton;
/* <#describe#> */
@property (nonatomic, strong) UITextView *storyLabel;
/* 标签视图 */
@property (nonatomic, strong) HXTagsView *tagsView;

@end

@implementation GBPersonalHomePageStoryHeadView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.storyLabel];
        [self.bgView addSubview:self.exchangeButton];

        [self setupTagView];
        
        self.bgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeButtonAction)];
        [self.bgView addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeButtonAction)];
        [self.storyLabel addGestureRecognizer:tap2];

    }
    return self;
}

- (void)setPersonalInfoModel:(GBFindPeopleModel *)personalInfoModel {
    _personalInfoModel = personalInfoModel;
    self.storyLabel.text = personalInfoModel.story;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    if (ValidStr(personalInfoModel.times)) {
        [tempArray addObject:personalInfoModel.times];
    }
    
    if (ValidStr(personalInfoModel.constellation)) {
        [tempArray addObject:personalInfoModel.constellation];
    }
    self.tagsView.tags = tempArray;
    [self.tagsView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 背景视图
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //添加四个边阴影
    self.bgView.layer.shadowColor = [UIColor colorWithHexString:@"#949497"].CGColor;//阴影颜色
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);//偏移距离
    self.bgView.layer.shadowOpacity = 1;//不透明度
    self.bgView.layer.shadowRadius = 2.0;//半径
    self.bgView.layer.masksToBounds = NO;
    
    // 切换
    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.width.equalTo(@80);
        make.height.equalTo(@16);
        make.top.equalTo(self.bgView).offset(GBMargin/2);
    }];
    
    // 背景视图
    [self.storyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(20);
        make.right.equalTo(self.bgView).offset(-20);
        make.height.equalTo(@84);
        make.top.equalTo(self.exchangeButton.mas_bottom).offset(8);
    }];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(GBMargin);
        make.top.equalTo(self.storyLabel.mas_bottom).offset(8);
        make.height.greaterThanOrEqualTo(@20);
        make.right.equalTo(self.bgView).offset(-GBMargin);
    }];
}

- (void)setupTagView {
    self.tagsView.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
        NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
    };
    self.tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.tagsView.layout.itemSize = CGSizeMake(100, 20);

    HXTagAttribute *model = [[HXTagAttribute alloc]init];
    model.borderWidth  = 0;
    model.cornerRadius  = 2;
    model.titleSize  = 12;
    model.textColor  = [UIColor colorWithHexString:@"#C68C33"];
    model.normalBackgroundColor  = [UIColor colorWithHexString:@"#F7EEE1"];
    model.tagSpace  = 15;
    
    self.tagsView.tagAttribute = model;
    
    [self.tagsView reloadData];
    
    [self addSubview:self.tagsView];
    
}

- (void)exchangeButtonAction {
    !self.exchangeBlock ? : self.exchangeBlock();
}

#pragma mark - # Getters and Setters
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = GBImageNamed(@"img_white");
    }
    
    return _bgView;
}

- (GBLIRLButton *)exchangeButton {
    if (!_exchangeButton) {
        _exchangeButton = [[GBLIRLButton alloc] init];
        [_exchangeButton setTitle:@"TA的名片" forState:UIControlStateNormal];
        [_exchangeButton setImage:GBImageNamed(@"icon_update_Card") forState:UIControlStateNormal];
        [_exchangeButton setBackgroundColor:[UIColor kBaseColor]];
        _exchangeButton.titleLabel.font = Fit_Font(12);
        [_exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exchangeButton addTarget:self action:@selector(exchangeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exchangeButton;
}


- (UITextView *)storyLabel {
    if (!_storyLabel) {
        _storyLabel = [[UITextView alloc] init];
        _storyLabel.editable = NO;
        _storyLabel.textColor = [UIColor kImportantTitleTextColor];
        _storyLabel.font = Fit_L_Font(10);
        _storyLabel.text = @"一名喜欢写写文字的女人。虽然才疏学浅，但努力争取做好自己。让生活感恩随行，一步一个脚印，一步一个台阶。一名喜欢写写文字的女人。虽然才疏学浅，但努力争取做好自己。让生活感恩随行，一步一个脚印，一步一个台阶。一名喜欢写写文字的女人。虽然才疏学浅，但努力争取做好自己。让生活感恩随行，一步一个脚印，一步一个台阶。";
    }
    
    return _storyLabel;
}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] init];
        _tagsView.userInteractionEnabled = NO;
    }
    
    return _tagsView;
}

@end
