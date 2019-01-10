//
//  GBDecryptionContentCell.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/8/20.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBDecryptionContentCell.h"

@interface GBDecryptionContentCell ()
/** 最大数提示 */
@property (nonatomic, strong) UILabel *maxNoticeLabel;
/** 最大数提示 */
@property (nonatomic, strong) UILabel *maxNoticeLabel2;

/* 提示语 */
@property (nonatomic, strong) UILabel *title1;
/* 提示语 */
@property (nonatomic, strong) UILabel *title2;


@end

@implementation GBDecryptionContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubView {
    // 达到最大限制时提示的Label
    UILabel *maxNoticeLabel = [[UILabel alloc] init];
    maxNoticeLabel.font = Fit_Font(12);
    maxNoticeLabel.textColor = [UIColor kPlaceHolderColor];
    maxNoticeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:maxNoticeLabel];
    self.maxNoticeLabel = maxNoticeLabel;
    
    // FSTextView
    FSTextView *textView = [FSTextView textView];
    textView.placeholder = @"输入标题";
    textView.editable = YES;
    textView.font = Fit_Font(14);
    textView.editable = YES;
    // 限制输入最大字符数.
    textView.maxLength = 30;
    
    // 弱化引用, 以免造成内存泄露.
    __weak __typeof (&*maxNoticeLabel) weakNoticeLabel = maxNoticeLabel;
    weakNoticeLabel.text = [NSString stringWithFormat:@"0/30"];
    
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        if (textView.text.length < textView.maxLength) {
            weakNoticeLabel.text = [NSString stringWithFormat:@"%zu/30", textView.text.length];
            weakNoticeLabel.textColor = [UIColor kPlaceHolderColor];
            
        }else {
            weakNoticeLabel.text = [NSString stringWithFormat:@"最多输入%zi个字符", textView.maxLength];
            weakNoticeLabel.textColor = [UIColor kBaseColor];
        }
        //
        !self.titleValueChangedBlock ? : self.titleValueChangedBlock(textView.text);
    }];
    
    [self.contentView addSubview:textView];
    self.textView = textView;
    GBViewBorderRadius(self.textView, 2, 1, [UIColor kSegmentateLineColor]);
    
    // 达到最大限制时提示的Label
    UILabel *title1 = [[UILabel alloc] init];
    title1.font = Fit_Font(16);
    title1.text = @"解密标题";
    title1.textColor = [UIColor kImportantTitleTextColor];
    [self.contentView addSubview:title1];
    self.title1 = title1;
    
    // 达到最大限制时提示的Label
    UILabel *title2 = [[UILabel alloc] init];
    title2.font = Fit_Font(16);
    title2.text = @"解密内容";
    title2.textColor = [UIColor kImportantTitleTextColor];
    [self.contentView addSubview:title2];
    self.title2 = title2;
    
    // 达到最大限制时提示的Label
    UILabel *maxNoticeLabel2 = [[UILabel alloc] init];
    maxNoticeLabel2.font = Fit_Font(12);
    maxNoticeLabel2.textColor = [UIColor kPlaceHolderColor];
    maxNoticeLabel2.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:maxNoticeLabel2];
    self.maxNoticeLabel2 = maxNoticeLabel2;
    
    // FSTextView
    FSTextView *textView2 = [FSTextView textView];
    textView2.placeholder = @"输入解密内容";
    textView2.font = Fit_Font(14);
    // 限制输入最大字符数.
    textView2.maxLength = 500;
    textView2.editable = YES;
    // 弱化引用, 以免造成内存泄露.
    __weak __typeof (&*maxNoticeLabel) weakNoticeLabel2 = maxNoticeLabel2;
    weakNoticeLabel2.text = [NSString stringWithFormat:@"0/500"];
    
    // 添加输入改变Block回调.
    [textView2 addTextDidChangeHandler:^(FSTextView *textView) {
        if (textView.text.length < textView.maxLength) {
            weakNoticeLabel2.text = [NSString stringWithFormat:@"%zu/500", textView.text.length];
            weakNoticeLabel2.textColor = [UIColor kPlaceHolderColor];
            
        }else {
            weakNoticeLabel2.text = [NSString stringWithFormat:@"最多输入%zi个字符", textView.maxLength];
            weakNoticeLabel2.textColor = [UIColor kBaseColor];
        }
        //
        !self.detailsValueChangedBlock ? : self.detailsValueChangedBlock(textView.text);
    }];
    
    [self.contentView addSubview:textView2];
    self.textView2 = textView2;
    GBViewBorderRadius(self.textView2, 2, 1, [UIColor kSegmentateLineColor]);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.maxNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(GBMargin/2);
        make.right.mas_equalTo(-GBMargin);
        make.height.equalTo(@16);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GBMargin);
        make.right.mas_equalTo(-GBMargin);
        make.top.equalTo(self.maxNoticeLabel.mas_bottom).offset(10);
        make.height.equalTo(@54);
    }];
    
    [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
    }];
    
    [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(GBMargin/2);
        make.left.mas_equalTo(self.contentView).offset(GBMargin);
    }];
    
    [self.textView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title2.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(GBMargin);
        make.right.equalTo(self.contentView).offset(-GBMargin);
        make.height.equalTo(@(150));
    }];
    
    [self.maxNoticeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.title2);
        make.right.equalTo(self.contentView).offset(-GBMargin);
    }];
}

- (void)setTagsArray:(NSMutableArray *)tagsArray {
    //多行不滚动多选
    HXTagCollectionViewFlowLayout *flowLayout = [[HXTagCollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.itemSize = CGSizeMake(64,30);
    //    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 15.0f, 10.0f, 10.0f);
    self.tagsView.layout = flowLayout;
    
    [self.tagsView.coustomNormalTagIcons removeAllObjects];
    [self.tagsView.coustomSelectedTagIcons removeAllObjects];
    
    for (int i = 0; i < tagsArray.count; i++) {
        if (i == tagsArray.count - 1) {
            [self.tagsView.coustomSelectedTagIcons addObject:GBImageNamed(@"icon_add")];
            [self.tagsView.coustomNormalTagIcons addObject:GBImageNamed(@"icon_add")];
            
        }else {
            [self.tagsView.coustomSelectedTagIcons addObject:@"占位"];
            [self.tagsView.coustomNormalTagIcons addObject:@"占位"];
        }
        
    }
    
    self.tagsView.coustomSelectedBackgroundColors = self.tagsView.coustomNormalBackgroundColors;
    
    self.tagsView.coustomSelectedTitleColors = self.tagsView.coustomNormalTitleColors;
    
    self.tagsView.isMultiSelect = YES;
    self.tagsView.tagAttribute.borderWidth = 0.5;
    self.tagsView.tagAttribute.cornerRadius = 15;
    self.tagsView.tagAttribute.tagSpace = GBMargin*2;
    self.tagsView.tagAttribute.titleSize = 14;
    self.tagsView.tagAttribute.selectedTextColor = [UIColor kBaseColor];
    self.tagsView.tagAttribute.textColor = [UIColor kNormoalInfoTextColor];
    self.tagsView.tagAttribute.selectedBackgroundColor = [UIColor colorWithHexString:@"#F7F5FD"];
    self.tagsView.tagAttribute.normalBackgroundColor = [UIColor colorWithHexString:@"#F7F5FD"];
    
    self.tagsView.tagAttribute.borderColor = [UIColor kBaseColor];
    self.tagsView.tagAttribute.selectBorderColor = [UIColor kBaseColor];
    
    self.tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.tagsView.iconMargin = 16;
    
    self.tagsView.tags = tagsArray;
    [self.tagsView reloadData];
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.font = Fit_Font(14);
        _content.textColor = [UIColor kImportantTitleTextColor];
        _content.numberOfLines = 0;
        _content.backgroundColor = [UIColor clearColor];
    }
    
    return _content;
}

- (HXTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[HXTagsView alloc] init];
    }
    return _tagsView;
}

@end
