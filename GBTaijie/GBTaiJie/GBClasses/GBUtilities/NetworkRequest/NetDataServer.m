//
//  NetDataServer.m
//  AFNetWorking
//
//  Created by LXK on 15/4/1.
//  Copyright (c) 2015年 Tomisoft. All rights reserved.
//

#import "NetDataServer.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation NetDataServer

static NetDataServer *dataServer = nil;

/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

/** 类中如有属性，任然需要在dispatch_once的block回调中初始化 */
+ (NetDataServer *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataServer = [[self alloc] init];
    });
    
    return dataServer;
}

/**
 覆写内存分配方法，防止外界通过不同的方式（init、new）创建对象而产生不同的对象，不能保证唯一性
 
 @param zone 内存空间
 @return 返回实例对象
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataServer = [super allocWithZone:zone];
    });
    
    return dataServer;
}

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(NetworkStatus)networkStatus {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(NetworkStatusUnknown) : nil;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(NetworkStatusNotReachable) : nil;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(NetworkStatusReachableViaWWAN) : nil;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(NetworkStatusReachableViaWiFi) : nil;
                    break;
            }
        }];
    });
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

- (void)isShowLoadingView:(BOOL )show {
    
}

//网络请求POST,GET,参数，文件上传
- (void)requestURL:(NSString *)urlstring
        httpMethod:(NSString *)method
      headerParams:(NSDictionary *)headerParmas
            params:(id )parmas
              file:(NSDictionary *)files
           success:(void (^)(id responseData))success
              fail:(void(^)(NSError *error))fail;
{
    if (!self.forbidShowLoading) {
        GB_MAIN_THREAD(^{
            // 加载视图
            [GBLoadingWaitView showCircleJoinView:KEYWINDOW isClearBackgoundColor:YES margin:0];
        });
    }else {
        // 取消禁止
        self.forbidShowLoading = NO;
    }
    
    if (!kIsNetwork) {
        // 断网
        GB_MAIN_THREAD(^{
            [GBLoadingWaitView hide];
        });
        return;
    }
    
    //拼接地址
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BASE_URL,urlstring];
    NSMutableDictionary *mParmas = [NSMutableDictionary dictionaryWithDictionary:parmas];
    if (ValidNum([GBUserDefaults objectForKey:UDK_UserId])) {
        [mParmas setObject:[GBUserDefaults objectForKey:UDK_UserId] forKey:@"appUserId"];
    }
    parmas = mParmas;
    
    NSMutableDictionary *mHeaderParmas = [NSMutableDictionary dictionaryWithDictionary:headerParmas];
    if (ValidStr([GBUserDefaults objectForKey:UDK_UserToken])) {
        [mHeaderParmas setObject:[GBUserDefaults objectForKey:UDK_UserToken] forKey:@"token"];
    }else {
        [mHeaderParmas setObject:@"" forKey:@"token"];
    }
    
    [mHeaderParmas setObject:@"1" forKey:@"platform"];
    headerParmas = mHeaderParmas;
    NSLog(@"请求URL~~~:\n%@\nheaderParmas~~~:\n%@\nparmas~~~:\n%@\n --------------------------------",requestURL,headerParmas,parmas);
    //编码
    NSString *encodeURL = [requestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    //构造一个操作对象的管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSSet *nsset = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml", @"application/json",@"text/html", @"text/json",@"text/javascript",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded",nil];
    [manager.responseSerializer setAcceptableContentTypes:nsset];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    manager.securityPolicy = securityPolicy;
    
    //设置请求头
    if ([headerParmas count] > 0) {
        for (NSString *key in headerParmas) {
            [manager.requestSerializer setValue:headerParmas[key] forHTTPHeaderField:key];
        }
    }
    
    if ([[method uppercaseString] isEqualToString:@"GET"]) {
        //GET请求
        [manager GET:encodeURL
          parameters:parmas
            progress:nil
             success:^(NSURLSessionDataTask *operation, id responseObject) {
                 [GBLoadingWaitView hide];
                 
                 if (success) {
                     success(responseObject);
                 }
             }
         
             failure:^(NSURLSessionDataTask *operation, NSError *error) {
                 if (fail) {
                     [GBLoadingWaitView hide];
                     [UIView showHubWithTip:@"数据请求失败"];
                     fail(error);
                 }
             }];
    }else if ([[method uppercaseString] isEqualToString:@"POST"]){
        //POST请求
        
        if (files == nil) {
            // POST 不包括文件
            [manager POST:encodeURL parameters:parmas progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
                [GBLoadingWaitView hide];
                
                if (success) {
                    if ([responseObject[@"result"] integerValue] == 3)  {
                        NSLog(@"result = %@:%@",responseObject[@"result"],responseObject[@"msg"])
                        [userManager saveCurrentUser:nil];
                        [GBUserDefaults removeObjectForKey:UDK_CurrentUser];
                        [GBUserDefaults synchronize];
                        
                        GBPostNotification(LoginStateChangeNotification, @NO)
                        //                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //                            GBPostNotification(LoginAnimationNotification, nil);
                        //                        });
                        
                        return;
                    }
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                if (fail) {
                    [GBLoadingWaitView hide];
                    
                    [UIView showHubWithTip:error.localizedDescription];
                    fail(error);
                }
                
            }];
        }else {
            [manager POST:encodeURL parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                if (files != nil) {
                    
                    for (id key in files) {
                        
                        id value = files[key];
                        if ([key isEqualToString:@"videofile"]) {
                            [formData appendPartWithFileData:value
                                                        name:key
                                                    fileName:@"video.mp4"
                                                    mimeType:@"video/mpeg"];
                        }else {
                            if ([value isKindOfClass:[NSMutableArray class]]) {
                                NSMutableArray *imageFiles = [[NSMutableArray alloc]initWithArray:value];
                                for (int index = 0; index < imageFiles.count; index++) {
                                    NSData *data = imageFiles[index];
                                    [formData appendPartWithFileData:data
                                                                name:key
                                                            fileName:@"something.png"
                                                            mimeType:@"image/png"];
                                }
                            }else {
                                [formData appendPartWithFileData:value
                                                            name:key
                                                        fileName:@"image.png"
                                                        mimeType:@"image/png"];
                            }
                        }
                    }
                }
                
            }
                 progress:nil
                  success:^(NSURLSessionDataTask *operation, id responseObject) {
                      
                      if (success) {
                          
                          success(responseObject);
                      }
                      
                  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                      if (fail) {
                          fail(error);
                      }
                      
                  }];
        }
    }else if ([[method uppercaseString] isEqualToString:@"DELETE"]) {
        // POST 不包括文件
        [manager DELETE:encodeURL parameters:parmas success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (fail) {
                fail(error);
            }
            
        }];
    }else if ([[method uppercaseString] isEqualToString:@"PUT"]) {
        // POST 不包括文件
        [manager PUT:encodeURL parameters:parmas success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (fail) {
                fail(error);
            }
            
        }];
    }
}

// 检测网络连接
- (void)checkNetworkingState {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"不可用");
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"手机蜂窝WWAN");
                
            }
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"WiFi");
                
            }
                break;
                
            default:
                break;
        }
    }];
    
    [netManager startMonitoring];
}

////上传图片二进制流
//+(void)postImageURL:(NSString *)urlstring
//       headerParams:(NSDictionary *)headerParmas
//             params:(NSDictionary *)parmas
//               file:(NSMutableArray *)filesArray
//           fileName:(NSString *)fileName
//            success:(void (^)(id data))success
//               fail:(void(^)(NSError *error))fail
//{
//    NSURLSessionDataTaskManager *mgr=[NSURLSessionDataTaskManager manager];
//    NSString *requestURL = [NSString stringWithFormat:@"%@",urlstring];
//    //   mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [mgr POST:requestURL parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        for (int index = 0; index < filesArray.count; index++) {
//            NSData *data = filesArray[index];
//            [formData appendPartWithFileData:data name:fileName fileName:@"something.jpg" mimeType:@"image/jpg"];
//        }
//        
//    } success:^(NSURLSessionDataTask *operation, id responseObject) {
//        
//        if (success) {
//            success(responseObject);
//        }
//        
//    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        if (error) {
//            fail(error);
//        }
//    }];
//}

/*
 +(void)updateRequest:(NSString *)url params:(NSDictionary *)params fileConfig:(NSDictionary *)files successAndProgress:(progressBlock)progressHandler complete:(responseBlock)completionHandler {
 NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
 if (files != nil) {
 
 for (id key in files) {
 
 id value = files[key];
 if ([key isEqualToString:@"videofile"]) {
 [formData appendPartWithFileData:value
 name:key
 fileName:@"video.mp4"
 mimeType:@"video/mpeg"];
 }else {
 if ([value isKindOfClass:[NSMutableArray class]]) {
 NSMutableArray *imageFiles = [[NSMutableArray alloc]initWithArray:value];
 for (int index = 0; index < imageFiles.count; index++) {
 NSData *data = imageFiles[index];
 [formData appendPartWithFileData:data
 name:key
 fileName:@"something.jpg"
 mimeType:@"image/jpg"];
 }
 }else {
 [formData appendPartWithFileData:value
 name:key
 fileName:@"something.jpg"
 mimeType:@"image/jpg"];
 }
 
 }
 }
 }
 
 } error:nil];
 
 //获取上传进度
 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
 
 [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
 
 progressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
 
 }];
 
 [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
 
 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]; //解析
 
 completionHandler(json, nil);
 } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
 
 completionHandler(nil, error);
 if (error) {
 NSLog(@"------上传失败-------%@",error);
 }
 }];
 
 [operation start];
 }
 */

@end
