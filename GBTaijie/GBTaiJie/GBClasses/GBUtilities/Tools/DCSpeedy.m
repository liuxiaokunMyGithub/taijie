//
//  DCSpeedy.m
//  LiChi
//
//  Created by apple on 2017/3/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DCSpeedy.h"

@implementation DCSpeedy

+ (id)dc_setCornerWith:(UIView *)view hasTop:(BOOL)hasTop hasBottom:(BOOL )hasBottom hasRound:(BOOL)hasRound size:(CGSize)size {
    UIBezierPath *maskPath;
    
    if (hasRound == YES || (hasTop == YES && hasBottom == YES)) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:size];
    }else if (hasTop == YES) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight  cornerRadii:size];
    }else if (hasBottom == YES) {
        
        maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:size];
    }
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    
    view.layer.mask = maskLayer;
    
    return view;
    
}

+(id)dc_chageControlCircularWith:(id)anyControl AndSetCornerRadius:(NSInteger)radius SetBorderWidth:(NSInteger)width SetBorderColor:(UIColor *)borderColor canMasksToBounds:(BOOL)can
{
    CALayer *icon_layer=[anyControl layer];
    [icon_layer setCornerRadius:radius];
    [icon_layer setBorderWidth:width];
    [icon_layer setBorderColor:[borderColor CGColor]];
    [icon_layer setMasksToBounds:can];
    
    return anyControl;
}

+(id)dc_setSomeOneChangeColor:(UILabel *)label SetSelectArray:(NSArray *)arrray SetChangeColor:(UIColor *)color
{
    if (label.text.length == 0) {
        return 0;
    }
    int i;
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:label.text];
    for (i = 0; i < label.text.length; i ++) {
        NSString *a = [label.text substringWithRange:NSMakeRange(i, 1)];
        NSArray *number = arrray;
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(i, 1)];
        }
    }
    label.attributedText = attributeString;
    return label;
}

+ (NSMutableAttributedString*)dc_setSomeOneChangeColor:(UIColor *)changeColor changeFont:(UIFont *)changeFont totalString:(NSString *)totalString changeString:(NSString *)changeString {
    
    NSRange usableRange = [totalString rangeOfString:changeString];
    
    NSMutableAttributedString *usableAttributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    if (changeColor) {
        [usableAttributedStr addAttribute:NSForegroundColorAttributeName value:changeColor range:usableRange];
    }
    
    if (changeFont) {
        [usableAttributedStr addAttribute:NSFontAttributeName value:changeFont range:usableRange];
    }

    return usableAttributedStr;
}

#pragma mark -  根据传入字体大小计算字体宽高
+ (CGSize)dc_calculateTextSizeWithText : (NSString *)text WithTextFont: (UIFont *)textFont WithMaxW : (CGFloat)maxW {
    
    CGFloat textMaxW = maxW;
    CGSize textMaxSize = CGSizeMake(textMaxW, MAXFLOAT);
    
    CGSize textSize = [text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil].size;
    
    return textSize;
}

#pragma mark - 上划线
+ (void)dc_setTopAcrossPartingLineWith:(UIView *)view WithColor:(UIColor *)color
{
    UIView *cellAcrossPartingLine = [[UIView alloc] init];
    cellAcrossPartingLine.backgroundColor = color;
    [view addSubview:cellAcrossPartingLine];
    
    [cellAcrossPartingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.top.mas_equalTo(view);
        make.height.mas_equalTo(1);
    }];
    
}
/**
 中划线
 
 @param 字符串 中划线
 */
+ (NSMutableAttributedString *)dc_setMiddleAcrossPartingLineWith:(NSString *)totalString WithColor:(UIColor *)color {
    //中划线
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:totalString];
    [attribtStr addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0),NSStrikethroughColorAttributeName:color} range:NSMakeRange(0, attribtStr.length)];
    
    return attribtStr;
}

#pragma mark - 下划线
+ (void)dc_setUpAcrossPartingLineWith:(UIView *)view WithColor:(UIColor *)color margin:(NSInteger )margin
{
    UIView *cellAcrossPartingLine = [[UIView alloc] init];
    cellAcrossPartingLine.backgroundColor = color;
    [view addSubview:cellAcrossPartingLine];
    
    [cellAcrossPartingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view).offset(margin);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - 竖线
+ (void)dc_setUpLongLineWith:(UIView *)view WithColor:(UIColor *)color WithHightRatio:(CGFloat)ratio offset:(CGFloat )offset;
{
    if (ratio == 0) { // 默认1
        ratio = 1;
    }
    
    UIView *cellLongLine = [[UIView alloc] init];
    cellLongLine.backgroundColor = color;
    [view addSubview:cellLongLine];
    
    [cellLongLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(view).offset(offset);
        make.centerY.mas_equalTo(view);
        make.size.mas_equalTo(CGSizeMake(0.5, view.height * ratio));
        
    }];
}

#pragma mark - 首行缩进
+ (void)dc_setUpLabel:(UILabel *)label Content:(NSString *)content IndentationFortheFirstLineWith:(CGFloat)emptylen headIndent:(CGFloat)headIndent
{
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    // 头部缩进
    paraStyle01.headIndent = headIndent;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:content attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    
    label.attributedText = attrText;
}

#pragma mark - 设置圆角
+ (void)dc_setUpBezierPathCircularLayerWith:(UIButton *)control :(CGSize)size
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:control.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft |UIRectCornerTopRight cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = control.bounds;
    maskLayer.path = maskPath.CGPath;
    control.layer.mask = maskLayer;
}

#pragma mark - 字符串加星处理
+ (NSString *)dc_EncryptionDisplayMessageWith:(NSString *)content WithFirstIndex:(NSInteger)findex surplus:(NSInteger)surplus
{
    if (!content || [content isEqualToString:@""]) {
        return @"";
    }
    
    if (findex <= 0) {
        findex = 2;
    }else if (findex + 1 > content.length) {
        findex --;
    }
    return [NSString stringWithFormat:@"%@****%@",[content substringToIndex:findex],[content substringFromIndex:content.length - surplus]];
}

+(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

#pragma mark - base64图片转编码
+(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData = [[NSData alloc] initWithBase64EncodedString:_encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *_decodedImage = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}

@end
