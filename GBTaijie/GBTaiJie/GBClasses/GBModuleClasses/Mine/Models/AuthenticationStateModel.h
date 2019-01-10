//
//  AuthenticationStateModel.h
//  GBTaiJie
//
//  Created by jiaming yan on 2018/828.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

@interface AuthenticationStateModel : GBBaseModel
@property (nonatomic, strong) NSString * companyId;
@property (nonatomic, strong) NSString * reason;
@property (nonatomic, strong) NSString * authenticationState;
/* <#describe#> */
@property (nonatomic, copy) NSString *lastReviewTime;
/* <#describe#> */
@property (nonatomic, copy) NSString *message;
/* 认证状态
 status : yes 可以修改
 */
@property (nonatomic, assign) BOOL status;


@end
