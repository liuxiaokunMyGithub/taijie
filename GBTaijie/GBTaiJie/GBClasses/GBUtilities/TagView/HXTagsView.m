//
//  HXTagsView.m
//  黄轩 https://github.com/huangxuan518
//
//  Created by 黄轩 on 16/1/13.
//  Copyright © 2015年 IT小子. All rights reserved.
//

#import "HXTagsView.h"
#import "HXTagCollectionViewCell.h"

@interface HXTagsView () <UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation HXTagsView

static NSString * const reuseIdentifier = @"HXTagCollectionViewCellId";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    //初始化样式
    _tagAttribute = [HXTagAttribute new];
    
    _minSelectCount = 0;
    _maxSelectCount = 0;
    _layout = [[HXTagCollectionViewFlowLayout alloc] init];
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXTagCollectionViewFlowLayout *layout = (HXTagCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [_tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: Fit_Font(_tagAttribute.titleSize)} context:nil];
    
    return CGSizeMake(frame.size.width + _tagAttribute.tagSpace, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = _tagAttribute.normalBackgroundColor;
    cell.layer.borderColor = _tagAttribute.borderColor.CGColor;
    cell.layer.cornerRadius = _tagAttribute.cornerRadius;
    cell.layer.borderWidth = _tagAttribute.borderWidth;
    [cell.tagButton setTitleColor:_tagAttribute.textColor forState:UIControlStateNormal];
    cell.tagButton.titleLabel.font = Fit_Font(_tagAttribute.titleSize);
    
    if (self.coustomIconBackGroundColors.count) {
        [cell.tagButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        cell.tagButton.imageView.backgroundColor = [self.coustomIconBackGroundColors objectAtIndex:indexPath.row];
        GBViewRadius(cell.tagButton.imageView, 12);
    }
    
    
    NSString *title = self.tags[indexPath.item];
    if (_key.length > 0) {
        [cell.tagButton setAttributedTitle:[self searchTitle:title key:_key keyColor:_tagAttribute.keyColor] forState:UIControlStateNormal];
    } else {
        [cell.tagButton setTitle:title forState:UIControlStateNormal];
    }
    
    // 自定义背景色
    if (self.coustomNormalBackgroundColors.count) {
        cell.backgroundColor = [self.coustomNormalBackgroundColors objectAtIndex:indexPath.row];
        
    }
    
    // 自定义文本颜色
    if (self.coustomNormalTitleColors.count) {
        [cell.tagButton setTitleColor:[self.coustomNormalTitleColors objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    }
    
    // 自定义图标
    if (self.coustomNormalTagIcons.count) {
        if (ValidClass([self.coustomSelectedTagIcons objectAtIndex:indexPath.row],UIImage)) {
            
            if (self.iconMargin) {
//                cell.tagButton.margin = self.iconMargin;
            }
            
            [cell.tagButton setImage:[self.coustomNormalTagIcons objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
        
    }
    
    /** MARK: 选中状态 */
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
        [cell.tagButton setTitleColor:_tagAttribute.selectedTextColor forState:UIControlStateNormal];
        // 自定义选中背景色
        if (self.coustomSelectedBackgroundColors.count) {
            cell.backgroundColor = [self.coustomSelectedBackgroundColors objectAtIndex:indexPath.row];
        }
        
        // 自定义选中字体颜色
        if (self.coustomSelectedTitleColors.count) {
            [cell.tagButton setTitleColor:[self.coustomSelectedTitleColors objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
        
        // 自定义选中图标
        if (self.coustomSelectedTagIcons.count) {
            if (ValidClass([self.coustomSelectedTagIcons objectAtIndex:indexPath.row],UIImage)) {
                if (self.iconMargin) {
//                    cell.tagButton.margin = self.iconMargin;
                }
                
                [cell.tagButton setImage:[self.coustomSelectedTagIcons objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            }
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXTagCollectionViewCell *cell = (HXTagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        if (self.tags.count > 1 && self.minSelectCount && self.selectedTags.count <= self.minSelectCount) {
             return [UIView showHubWithTip:GBNSStringFormat(@"至少选择%zu项",self.minSelectCount)];
        }
        
        cell.backgroundColor = _tagAttribute.normalBackgroundColor;
        [cell.tagButton setTitleColor:_tagAttribute.textColor  forState:UIControlStateNormal];

        [self.selectedTags removeObject:self.tags[indexPath.item]];
        // 复原背景色
        if (self.coustomNormalBackgroundColors.count) {
            cell.backgroundColor = [self.coustomNormalBackgroundColors objectAtIndex:indexPath.row];
            
        }
        
        // 复原文本色
        if (self.coustomNormalTitleColors.count) {
            [cell.tagButton setTitleColor:[self.coustomNormalTitleColors objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
        
        // 复原图标
        if (self.coustomNormalTagIcons.count) {
            if (ValidClass([self.coustomSelectedTagIcons objectAtIndex:indexPath.row],UIImage)) {
                [cell.tagButton setImage:[self.coustomNormalTagIcons objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            }
        }
    }else {
        if (_isMultiSelect) {
            if (self.tags.count > 1 && self.maxSelectCount && self.selectedTags.count >= self.maxSelectCount) {
                return [UIView showHubWithTip:GBNSStringFormat(@"最多选择%zu项",self.maxSelectCount)];
            }
            
            cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
            [cell.tagButton setTitleColor:_tagAttribute.selectedTextColor forState:UIControlStateNormal];

            [self.selectedTags addObject:self.tags[indexPath.item]];
            
            // 选中背景色
            if (self.coustomSelectedBackgroundColors.count) {
                cell.backgroundColor = [self.coustomSelectedBackgroundColors objectAtIndex:indexPath.row];
            }
            
            // 选中字体颜色
            if (self.coustomSelectedTitleColors.count) {
                [cell.tagButton setTitleColor:[self.coustomSelectedTitleColors objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            }
            
            // 选中图标
            if (self.coustomSelectedTagIcons.count) {
                if (ValidClass([self.coustomSelectedTagIcons objectAtIndex:indexPath.row],UIImage)) {
                    [cell.tagButton setImage:[self.coustomSelectedTagIcons objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                }
                
            }
            
        } else {
            [self.selectedTags removeAllObjects];
            [self.selectedTags addObject:self.tags[indexPath.item]];
            
            [self reloadData];
        }
    }
    
    if (_completion) {
        _completion(self.selectedTags,indexPath.item);
    }
}

// 设置文字中关键字高亮
- (NSMutableAttributedString *)searchTitle:(NSString *)title key:(NSString *)key keyColor:(UIColor *)keyColor {
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
    NSString *copyStr = title;
    
    NSMutableString *xxstr = [NSMutableString new];
    for (int i = 0; i < key.length; i++) {
        [xxstr appendString:@"*"];
    }
    
    while ([copyStr rangeOfString:key options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        NSRange range = [copyStr rangeOfString:key options:NSCaseInsensitiveSearch];
        
        [titleStr addAttribute:NSForegroundColorAttributeName value:keyColor range:range];
        copyStr = [copyStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:xxstr];
    }
    return titleStr;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

#pragma mark - 懒加载

- (NSMutableArray *)selectedTags
{
    if (!_selectedTags) {
        _selectedTags = [NSMutableArray array];
    }
    return _selectedTags;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[HXTagCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    _collectionView.collectionViewLayout = _layout;
    
    if (_layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        //垂直
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    } else {
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    
    _collectionView.frame = self.bounds;
    
    return _collectionView;
}

+ (CGFloat)getHeightWithTags:(NSArray *)tags layout:(HXTagCollectionViewFlowLayout *)layout tagAttribute:(HXTagAttribute *)tagAttribute width:(CGFloat)width
{
    CGFloat contentHeight = 0;
    
    if (!layout) {
        layout = [[HXTagCollectionViewFlowLayout alloc] init];
    }
    
    if (tagAttribute.titleSize <= 0) {
        tagAttribute = [[HXTagAttribute alloc] init];
    }
    
    //cell的高度 = 顶部 + 高度
    contentHeight = layout.sectionInset.top + layout.itemSize.height;

    CGFloat originX = layout.sectionInset.left;
    CGFloat originY = layout.sectionInset.top;
    
    NSInteger itemCount = tags.count;
    
    for (NSInteger i = 0; i < itemCount; i++) {
        CGSize maxSize = CGSizeMake(width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        
        CGRect frame = [tags[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:tagAttribute.titleSize]} context:nil];
        
        CGSize itemSize = CGSizeMake(frame.size.width + tagAttribute.tagSpace, layout.itemSize.height);
        
        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            //垂直滚动
            //当前CollectionViewCell的起点 + 当前CollectionViewCell的宽度 + 当前CollectionView距离右侧的间隔 > collectionView的宽度
            if ((originX + itemSize.width + layout.sectionInset.right) > width) {
                originX = layout.sectionInset.left;
                originY += itemSize.height + layout.minimumLineSpacing;
                
                contentHeight += itemSize.height + layout.minimumLineSpacing;
            }
        }
        
        originX += itemSize.width + layout.minimumInteritemSpacing;
    }
    
    contentHeight += layout.sectionInset.bottom;
    return tags.count==0?0:contentHeight;
}

- (NSMutableArray *)coustomNormalBackgroundColors {
    if (!_coustomNormalBackgroundColors) {
        _coustomNormalBackgroundColors = [[NSMutableArray alloc] init];
    }
    
    return _coustomNormalBackgroundColors;
}

- (NSMutableArray *)coustomSelectedBackgroundColors {
    if (!_coustomSelectedBackgroundColors) {
        _coustomSelectedBackgroundColors = [[NSMutableArray alloc] init];
    }
    
    return _coustomSelectedBackgroundColors;
}

- (NSMutableArray *)coustomNormalTitleColors {
    if (!_coustomNormalTitleColors) {
        _coustomNormalTitleColors = [[NSMutableArray alloc] init];
    }
    
    return _coustomNormalTitleColors;
}

- (NSMutableArray *)coustomSelectedTitleColors {
    if (!_coustomSelectedTitleColors) {
        _coustomSelectedTitleColors = [[NSMutableArray alloc] init];
    }
    
    return _coustomSelectedTitleColors;
}

- (NSMutableArray *)coustomNormalTagIcons {
    if (!_coustomNormalTagIcons) {
        _coustomNormalTagIcons = [[NSMutableArray alloc] init];
    }
    
    return _coustomNormalTagIcons;
}

- (NSMutableArray *)coustomSelectedTagIcons {
    if (!_coustomSelectedTagIcons) {
        _coustomSelectedTagIcons = [[NSMutableArray alloc] init];
    }
    
    return _coustomSelectedTagIcons;
}

- (NSMutableArray *)coustomIconBackGroundColors {
    if (!_coustomIconBackGroundColors) {
        _coustomIconBackGroundColors = [[NSMutableArray alloc] init];
    }
    
    return _coustomIconBackGroundColors;
}

@end
