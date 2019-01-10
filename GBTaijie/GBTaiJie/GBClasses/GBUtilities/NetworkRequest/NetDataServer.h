//
//  NetDataServer.h
//  AFNetWorking
//
//  Created by LXK on 15/4/1.
//  Copyright (c) 2015年 Tomisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NetDataServerInstance
#define NetDataServerInstance [NetDataServer sharedInstance]
#endif

// 一次性判断是否有网的宏
#ifndef kIsNetwork
#define kIsNetwork     [NetDataServer isNetwork]
#endif

// 一次性判断是否为手机网络的宏
#ifndef kIsWWANNetwork
#define kIsWWANNetwork [NetDataServer isWWANNetwork]
#endif

// 一次性判断是否为WiFi网络的宏
#ifndef kIsWiFiNetwork
#define kIsWiFiNetwork [NetDataServer isWiFiNetwork]
#endif

typedef NS_ENUM(NSUInteger, NetworkStatusType) {
    /** 未知网络*/
    NetworkStatusUnknown,
    /** 无网络*/
    NetworkStatusNotReachable,
    /** 手机网络*/
    NetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    NetworkStatusReachableViaWiFi
};

/** 网络状态的Block*/
typedef void(^NetworkStatus)(NetworkStatusType status);


@interface NetDataServer : NSObject

/* 禁止显示加载视图 */
@property (nonatomic, assign) BOOL forbidShowLoading;

/** 创建单例对象 */
+ (NetDataServer *)sharedInstance;

#pragma mark - ------ AFN网络请求封装方法 ------
- (void)requestURL:(NSString *)urlstring
       httpMethod:(NSString *)method
     headerParams:(NSDictionary *)headerParmas
           params:(id )parmas
             file:(NSDictionary *)files
          success:(void (^)(id responseData))success
             fail:(void(^)(NSError *error))fail;

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(NetworkStatus)networkStatus;

/**
 有网YES, 无网:NO
 */
+ (BOOL)isNetwork;

/**
 手机网络:YES, 反之:NO
 */
+ (BOOL)isWWANNetwork;

/**
 WiFi网络:YES, 反之:NO
 */
+ (BOOL)isWiFiNetwork;

//#pragma Mark - 利用系统自带框架接收服务器返回的非json格式
//+ (void)systemRequestURL:(NSString *)urlstring
//             httpMethod:(NSString *)method
//                 params:(NSDictionary *)parmas
//                   file:(NSDictionary *)files
//                success:(void (^)(id data))success
//                   fail:(void (^)(NSError *error))fail;
//
//#pragma Mark - 上传图片二进制流
//+ (void)postImageURL:(NSString *)urlstring
//       headerParams:(NSDictionary *)headerParmas
//             params:(NSDictionary *)parmas
//               file:(NSMutableArray *)filesArray
//           fileName:(NSString *)fileName
//            success:(void (^)(id data))success
//               fail:(void(^)(NSError *error))fail;
/*
#pragma GET请求
+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock;


#pragma POST请求
+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (id ) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock;


 文件上传，监听上传进度
 */

//+ (void)updateRequest:(NSString *)url params:(NSDictionary *)params fileConfig:(NSDictionary *)files successAndProgress:(progressBlock)progressHandler complete:(responseBlock)completionHandler;

@end


