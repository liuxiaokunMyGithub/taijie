//
//  GBHelperTools.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/6.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import "GBHelperTools.h"
#import "GBLoginViewController.h"

@implementation GBHelperTools

ImplementationSingleton(GBHelperTools);

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
- (BOOL)isUrlValidation:(NSString *)string {
    if (!string) {
        return NO;
    }
    
    NSError *error;
    // 正则1
    //    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    // 正则2
    NSString *regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0,[string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSLog(@"匹配%@",[string substringWithRange:match.range]);
        return YES;
    }
    return NO;
}

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    NSString *MOBILE = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

/** 验证邮箱 */
- (BOOL )validationEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if( [emailTest evaluateWithObject:email]){
        NSLog(@"恭喜！您输入的邮箱验证合法");
        return YES;
    }else{
        [UIView showHubWithTip:@"请输入正确的邮箱"];
        return NO;
    }
}

/** 正则匹配用户密码6-20位数字和字母组合 */
- (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    
    return isMatch;
}

/** 校验除字母及数字以外的特殊字符 */
- (BOOL)chekSpecialCharacter:(NSString *)str {
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"];
    s = [s invertedSet];
    NSRange r = [str rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound){
        NSLog(@"the string contains illegal characters");
        return YES;
    }
    return NO;
}

/**
 *  @author 刘小坤, 16-12-26 14:12:06
 *
 *   颜色转换:（以#开头）十六进制的颜色转换为UIColor(RGB)
 *
 *  @param color 传入#开头16进制颜色值
 *
 *  @return 返回UIColor
 */
- (UIColor *)colorWithHexString: (NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


//比较两个数组中是否有不同元素
- (BOOL)filterArr:(NSArray *)arr1 andArr2:(NSArray *)arr2 {
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr1];
    //得到两个数组中不同的数据
    NSArray *reslutFilteredArray = [arr2 filteredArrayUsingPredicate:filterPredicate];
    if (reslutFilteredArray.count > 0) {
        return YES;
    }
    return NO;
}

//比较两个数组中是否相等
- (BOOL)filterEquleArr:(NSArray *)arr1 andArr2:(NSArray *)arr2 {
    if (arr1.count != arr2.count) { //两次数量不同，直接显示
        return YES;
    }else { //两个数量相同,比较字符串
        int hasSame =0;
        for (int i = 0; i < arr1.count; i++) {
            NSString *picUrl1 = arr1[i];
            NSString *picUrl2 = arr2[i];
            if ([picUrl1 isEqualToString:picUrl2]) {
                hasSame++;
            }
        }
        
        if (hasSame < arr1.count) { //至少有一个不同
            return YES;
        }else { //两个元素相同，hasSame不可能等于arr1.count
            return NO;
        }
    }
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    //CGFloat oldZPosition = animationView.layer.zPosition;//0
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

// 打印系统字体
- (void)printSystemFont {
    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
    
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    NSLog(@"[familyNames count]===%lu",(unsigned long)[familyNames count]);
    for(indFamily=0;indFamily<[familyNames count];++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        
        for(indFont=0; indFont<[fontNames count]; ++indFont) {
            NSLog(@"Font name: %@",[fontNames objectAtIndex:indFont]);
        }
    }

}

/**
 * 验证纳税人识别码/统一社会信用代码
 * 号码格式：
 * ①验证纳税人识别码：6位行政区划码（纯数字）+ 9位组织机构代码（数字或大写字母）
 * ②统一社会信用代码（18位）：第1位（登记管理部门代码，数字或字母）、第2位（机构类别代码，数字或字母）
 *                             第3—8位（登记管理机关行政区划码，数字）、第9—17位（主体标识码，数字或字母）
 *                             第18位（校验码，数字或字母）
 */
- (BOOL)validateTaxpayerNumber:(NSString*)TaxpayerNumber {
    
    NSString *regex = @"^((\\d{6}[0-9A-Z]{9})|([0-9A-Za-z]{2}\\d{6}[0-9A-Za-z]{10}))$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject: TaxpayerNumber]) {
        return NO;
    }
    return YES;
}

#pragma mark - 获取path路径下文件夹大小
- (NSString *)getCacheSizeWithFilePath:(NSString *)path{
    
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    NSString *filePath = @"";
    NSInteger totleSize = 0;
    
    for (NSString *subPath in subPathArr){
        if (![subPath containsString:@"Snapshots"]) {
            // 1. 拼接每一个文件的全路径
            filePath =[path stringByAppendingPathComponent:subPath];
        }
        
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
        
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
        
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    
    return totleStr;
}


#pragma mark - 清除path文件夹下缓存大小
- (BOOL)clearCacheWithFilePath:(NSString *)path {
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in subPathArr)
    {
        if (![filePath containsString:@"/Snapshots"]) {
            //删除子
            filePath = [path stringByAppendingPathComponent:subPath];
        }
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"清理缓存error%@",error);
            return NO;
        }
    }
    
    return YES;
}

/** 视图 导航 */
- (UINavigationController *)getPushNavigationContr {
    //取出根视图控制器
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    //取出当前选中的导航控制器
    UINavigationController *Nav = [tabBarVc selectedViewController];
    
    return Nav;
}

/** 视图 导航 */
- (UIViewController *)getViewcontrollerView:(UIView *)view {
    UIViewController *vc = nil;
    for (UIView *temp = view; temp;temp = temp.superview) {
        if ([temp.nextResponder isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController*)temp.nextResponder;
            break;
        }
    }
    return vc;
}

//获取Window当前显示的ViewController
- (UIViewController*)currentViewController {
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

#pragma mark 获取当前时间
- (NSString *)getCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

// 绘制虚线边框
- (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0); [[UIColor clearColor] set]; CGContextRef context = UIGraphicsGetCurrentContext(); CGContextBeginPath(context); CGContextSetLineWidth(context, borderWidth); CGContextSetStrokeColorWithColor(context, color.CGColor); CGFloat lengths[] = { 3, 1 }; CGContextSetLineDash(context, 0, lengths, 1); CGContextMoveToPoint(context, 0.0, 0.0); CGContextAddLineToPoint(context, size.width, 0.0); CGContextAddLineToPoint(context, size.width, size.height); CGContextAddLineToPoint(context, 0, size.height); CGContextAddLineToPoint(context, 0.0, 0.0); CGContextStrokePath(context); UIImage* image = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
    return image;
}

// 屏幕截图
- (UIImage *)captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (NSString *)stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

// 对象安全检查
- (id)objectSafeCheck:(id)object {
    if (object == nil) {
        if ([object isKindOfClass:[NSArray class]]) {
            object =  @[];
        }else if([object isKindOfClass:[NSDictionary class]]){
            object = @{};
        }else{
            object = @"";
        }
        NSLog(@"\n/*--- 为nil时，赋空 ---*/")
    }else if ((NSNull *)object == [NSNull null]) {
        if ([object isKindOfClass:[NSArray class]]) {
            object =  @[];
        }else if([object isKindOfClass:[NSDictionary class]]){
            object = @{};
        }else{
            object = @"";
        }
        NSLog(@"\n/*--- 为Null时，赋空 ---*/")
    }else if ([object isKindOfClass:[NSString class]] && [object isEqualToString:@"null"]) {
        if ([object isKindOfClass:[NSArray class]]) {
            object =  @[];
        }else if([object isKindOfClass:[NSDictionary class]]){
            object = @{};
        }else{
            object = @"";
        }
    }
    
    return object;
}

// 设置未登录模态视图
- (void)setNoLoginModalView:(BOOL )isPresent {
    if (isPresent) {
        UINavigationController *rootNavigation = [[UINavigationController alloc] initWithRootViewController: [GBLoginViewController new]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            while (topRootViewController.presentedViewController)
            {
                topRootViewController = topRootViewController.presentedViewController;
            }
            
            [topRootViewController presentViewController:rootNavigation animated:YES completion:^{
//                [NSUDF setObject:[NSNumber numberWithBool:isPresent] forKey:@"isPresent"];
//                [NSUDF synchronize];
            }];
        });
        
    }else {
        
    }
}

- (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

- (UIEdgeInsets)safeAreaInset {
    if (@available(iOS 11.0, *)) {
        if (self.keyWindow) {
            return self.keyWindow.safeAreaInsets;
        }
    }
    return UIEdgeInsetsZero;
}

- (BOOL)isHairHead {
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return self.safeAreaInset.left > 0.0f;
    }else {
        // ios12 非刘海屏状态栏 20.0f
        return self.safeAreaInset.top > 20.0f;
    }
}

@end
