//
//  GBUrlConst.h
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为开发服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    0
#define TestSever       0
#define ProductSever    1

#pragma mark - ———————  服务器域名地址 ————————

/** MARK: 开发 */
#if DevelopSever
#define BASE_URL @"http://m.taijie.work/dagger-stair-app/"

/** MARK: 测试服务器 */
#elif TestSever

/** MARK: 生产上线服务器 */
#elif ProductSever

#define BASE_URL @"http://cs.taijie.work/"

#endif

/** 七牛云图片域名 */
extern NSString *const BASE_URL_IMAGE_QINIUYUN;
/** 七牛云token */
extern NSString *const URL_IMAGE_GetQiuNiuUpToken;
/** h5域名 */
extern NSString *const URL_GB_HTML;
extern NSString *const URL_GB_Test_HTML;

#pragma mark - ——————— 详细接口地址 ————————
// MARK: ---- H5 ----
/** 用户协议 */
extern NSString *const HTML_User_Agreement;
/** 服务保障计划 */
extern NSString *const HTML_Service_Garantee;

/** 个人主页分享 */
extern NSString *const HTML_HomePage_Share;

// MARK: ---- 登录 ----
extern NSString *const URL_Login;
/** 登录验证码 */
extern NSString *const URL_Login_Code;
/** 注册 */
extern NSString *const URL_Login_Register;
/** 是否注册 */
extern NSString *const URL_Login_CheckRegister;

// MARK: ---- 首页 ----
/** 首页列表 */
extern NSString *const URL_HomePage_List;
/** 老司机换一批 */
extern NSString *const URL_HomePage_RandDecrypts;
/** 更多保过大师 */
extern NSString *const URL_HomePage_MoreMasters;
/** 更多保过职位 */
extern NSString *const URL_HomePage_MorePositions;
/** 更多文章 */
extern NSString *const URL_HomePage_MoreEssays;
/** 关注保过职位 */
extern NSString *const URL_HomePage_WatchPosition;
/** 关注解密 */
extern NSString *const URL_HomePage_WatchDecrypt;
/** 职位搜索 */
extern NSString *const URL_HomePage_PositionSearch;
/** 职位搜索主页谁能邦你-更多V1 */
extern NSString *const URL_HomePage_MorePositionRelatedMasters;
/** 职位搜索主页相关解密-更多V1 */
extern NSString *const URL_HomePage_MorePositionRelatedDecrypts;
/** 职位搜索主页-热门职位V1 */
extern NSString *const URL_HomePage_hotJob;

/** 公司搜索主页-公司名称检索V1 - 实时显示 */
extern NSString *const URL_Home_CompanyNamesSearch;
/** 公司搜索主页-搜索加载V1 */
extern NSString *const URL_HomePage_CompanySearch;
/** 公司搜索主页-职位换一批V1 */
extern NSString *const URL_HomePage_CompanyPositionChanging;
/** 公司搜索主页-认证同事更多V1 */
extern NSString *const URL_HomePage_MoreCompanyIncumbents;
/** 公司搜索主页-相关解密更多V1 */
extern NSString *const URL_HomePage_MoreCompanyDecrypts;

/** 搜索轨迹更新V1 */
extern NSString *const URL_HomePage_SearchTrace;
/** 推荐保过大师数 */
extern NSString *const URL_HomePage_MastersCount;
/** 更多职位 */
extern NSString *const URL_HomePage_Cpositions;
/** 公司搜索在招职位换一批 */
extern NSString *const URL_HomePage_CompanyPositionChanging;
/** 更多公司 */
extern NSString *const URL_HomePage_MoreCompanies;
/** 公司主页 */
extern NSString *const URL_HomePage_CompanyMainPage;
/** 个人主页增加访问量 */
extern NSString *const URL_HomePage_VisitOnce;
/** 公司主页在职同事换一批 */
extern NSString *const URL_HomePage_CompanyIncumbentsChanging;
/** 更多公司在招职位 */
extern NSString *const URL_HomePage_MoreCompanyPositions;
/** 爬取职位观注V1 */
extern NSString *const URL_HomePage_WatchcPosition;

/** 更多解密咨询 */
extern NSString *const URL_HomePage_MoreDecrypts;

/** 更多解密服务 */
extern NSString *const URL_HomePage_More_Decrypt;

// MARK: ---- 发现页 ----

/** 发现 */
extern NSString *const URL_Find_FindSearch;
/** 发现-热心同事换一批 */
extern NSString *const URL_Find_ChangingWarmIncumbents;
/** 发现页-特价免费及各TAB */
extern NSString *const URL_Find_ChangingDecrypts;
/** 发现更多 */
extern NSString *const URL_Find_MoreDecrypts;
/** 服务评论列表 */
extern NSString *const URL_Find_Service_CommentList;

// MARK: ---- 找人页 ----

extern NSString *const URL_FindPeople_Banner;
extern NSString *const URL_FindPeople_PersonList;
/** 黑名单 */
extern NSString *const URL_FindPeople_Join_blacklist;
/** 获取找人意向 */
extern NSString *const URL_FindPeople_Incumbent;
/** 新建更新找人意向 */
extern NSString *const URL_FindPeople_Renewal;
/** 获取城市列表 */
extern NSString *const URL_FindPeople_region;
/** 检索公司 */
extern NSString *const URL_FindPeople_SearchCompany;
/** 获取职位三级列表 */
extern NSString *const URL_FindPeople_jobList;
/** 个人主页 */
extern NSString *const URL_FindPeople_SkipPage;
/** 地区拼音 */
extern NSString *const URL_FindPeople_CityCode;
/** 个人主页-服务 */
extern NSString *const URL_FindPeople_PersonalService;
/** 个人主页-在职者信息及评论 */
extern NSString *const URL_FindPeople_Info_Comment;
/** 举报 */
extern NSString *const URL_FindPeople_Report;

// MARK: ---- 职位页 ----

extern NSString *const URL_Position_PostionList;
extern NSString *const URL_Position_Decrypt;
/** 职位意向列表 */
extern NSString *const URL_Position_IntentionalPositions;
/** 职位详情 */
extern NSString *const URL_Position_Deatail;
/** 获取学历 */
extern NSString *const URL_Position_DilamorCode;
/** 获取经验 */
extern NSString *const URL_Position_Experience;
/** 获取行业 */
extern NSString *const URL_Position_Industries;
/** 删除意向职位 */
extern NSString *const URL_Position_IntentionalPositionRemoval;
/** 保过详情页 */
extern NSString *const URL_Position_AssurePassDetail;
/** 获取解密详情页 */
extern NSString *const URL_Position_DecryptDetail;
/** 预约解密 */
extern NSString *const URL_Position_OrderDecrypt;
/** 预约保过 */
extern NSString *const URL_Position_OrderAssurePass;
/** 意向职位新增更新 */
extern NSString *const URL_Position_IntentionalPositionRenewal;
/** 行业类型 */
extern NSString *const URL_Position_IndustryType;
/** 支付 */
extern NSString *const URL_Position_Pay;
/** 在招职位 */
extern NSString *const URL_Position_Recruiting;
/** 在职同事 */
extern NSString *const URL_Position_Colleague;
/** 公司信息 */
extern NSString *const URL_Position_CompanyInfo;
/** 职位搜索 */
extern NSString *const URL_Postition_Search;
/** 公司搜索 */
extern NSString *const URL_Company_Search;
/** 在职者搜索 */
extern NSString *const URL_Personal_Search;

// MARK: ---- 论坛 ----
/** 帖子列表 */
extern NSString *const URL_Tieba_List;
/** 帖子评论列表 */
extern NSString *const URL_Tieba_Comment_List ;
/** 帖子获取用户昵称 */
extern NSString *const URL_Tieba_Nick;
/** 帖子修改用户昵称 */
extern NSString *const URL_Tieba_UpdateNick;
/** 话题关闭 */
extern NSString *const URL_Tieba_Close;
/** 点赞 */
extern NSString *const URL_Tieba_Like;
/** 取消点赞 */
extern NSString *const URL_Tieba_CancelLike;
/** 发表评论 */
extern NSString *const URL_Tieba_Publish_Comment;
/** 发表帖子 */
extern NSString *const URL_Tieba_Publish;
/** 评论删除 */
extern NSString *const URL_Tieba_CommentClose;

// MARK: ---- 我的 ----
/** 个人信息 */
extern NSString *const URL_Mine_Info;
/** 编辑资料带擅长领域个人信息 */
extern NSString *const URL_Mine_EditInfo;
/** 更新个人资料 */
extern NSString *const URL_Mine_UpdateEditInfo;
/** 余额 */
extern NSString *const URL_Mine_Balance;
/** 充值 */
extern NSString *const URL_Mine_InAppPurchase;
/** 交易流水 */
extern NSString *const URL_Mine_UserMoneyRecord;
/** 已购订单 */
extern NSString *const URL_Mine_PurchasedOrder;
/** 删除订单 */
extern NSString *const URL_Mine_UserOrderRemoval;
/** 服务订单 */
extern NSString *const URL_Mine_IncumbentOrder;
/** 解密订单详情 */
extern NSString *const URL_Mine_GetDecryptOrderDetails;
/** 保过订单详情 */
extern NSString *const URL_Mine_GetAssurePassOrderDetails;
/** 更新支付密码 */
extern NSString *const URL_Mine_PayPwdRenewal;
/** 更新登录密码 */
extern NSString *const URL_Mine_PwdRenewal;
/** 更新用户手机号 */
extern NSString *const URL_Mine_UserTelRenewal;
/** 更新用户支付宝账户 */
extern NSString *const URL_Mine_UpdateUserAlipayAccount;

/** 我的收藏 */
extern NSString *const URL_Mine_CollectionList;
/** 在职者认证信息 */
extern NSString *const URL_Mine_IncumbentAuthenticationInfo;
/** 提交认证信息  */
extern NSString *const URL_Mine_IncumbentAuthenticationInfoSubmition;
/** 提交认证审核 */
extern NSString *const URL_Mine_AuditionSubmition;
/** 认证状态 */
extern NSString *const URL_Mine_IncumbentAuthenticationState;
/** 初始化芝麻认证 */
extern NSString *const URL_Mine_InitAntAuthenticate;
/** 阿里芝麻信用签名 */
extern NSString *const URL_Mine_getAlipayAccountAuthSign;
/** 提交用户认证信息 */
extern NSString *const URL_Mine_SubmitIncumbentAuthenticationInfo;
/** 新增/更新在职者解密服务 */
extern NSString *const URL_Mine_DecryptRenewal;
/** 新增/更新在职者保过服务  */
extern NSString *const URL_Mine_AssurePassRenewal;
/** 解密服务列表 */
extern NSString *const URL_Mine_DecryptServiceList;
/** 保过服务列表 */
extern NSString *const URL_Mine_AssurePasstServiceList;
/** 在职者解密服务详情 */
extern NSString *const URL_Mine_myIncumbentDecrypt;
/** 删除在职者解密服务 */
extern NSString *const URL_Mine_DeleteIncumbentDecrypt;
/** 获取单个在职者保过服务详情 */
extern NSString *const URL_Mine_IncumbentDetail;
/** 删除在职者保过服务 */
extern NSString *const URL_Mine_DeleteIncumbentAssurePass;
/** 解密服务评价 */
extern NSString *const URL_Mine_Decrypt_Evaluate;
/** 保过服务评价 */
extern NSString *const URL_Mine_AssurePass_Evaluate;

/** 接受解密 */
extern NSString *const URL_Mine_Decrypt_Accept;
/** 结束解密 */
extern NSString *const URL_Mine_Decrypt_Finish;
/** 拒绝解密 */
extern NSString *const URL_Mine_Decrypt_Reject;
/** 解密取消 */
extern NSString *const URL_Mine_Decrypt_Cancel;

/** 接受保过 */
extern NSString *const URL_Mine_AssurePass_Accept;
/** 结束保过 */
extern NSString *const URL_Mine_AssurePass_Finish;
/** 拒绝保过 */
extern NSString *const URL_Mine_AssurePass_Reject;
/** 保过取消 */
extern NSString *const URL_Mine_AssurePass_Cancel;

/** 解密可用性 */
extern NSString *const URL_Mine_Decrypt_Availability;
/** 保过可用性 */
extern NSString *const URL_Mine_AssurePass_Availability;
/** 提现 */
extern NSString *const URL_Mine_WithdrawDeposit;
/** 获取支付宝账号 */
extern NSString *const URL_Mine_GetUserAlipayAccount;

/** 删除求职者技能 */
extern NSString *const URL_Mine_candidateSkillsRemoval;
/** 获取求职者技能 */
extern NSString *const URL_Mine_candidateSkills;
/** 新增更新技能 */
extern NSString *const URL_Mine_skillRenewal;
/** 意见反馈 */
extern NSString *const URL_Mine_FeedBack;
/** 提现记录 */
extern NSString *const URL_Mine_WithdrawDepositList;
/** 过往微经验 */
extern NSString *const URL_Mine_MicroExperience;
/** 经验更新 */
extern NSString *const URL_Mine_SingleMicroExperienceRenewal;
/** 微经验删除 */
extern NSString *const URL_Mine_MicroExperienceRemoval;
/** 订单状态红色提醒(点入消除) */
extern NSString *const URL_Mine_NoticeStatusRenewal;
/** 检查订单总状态及分TAB状态 */
extern NSString *const URL_Mine_OrderNewStatus;
/** 保过标签 */
extern NSString *const URL_Mine_assurePassLabels;
/** 公司搜索-推荐公司V1 */
extern NSString *const URL_HomePage_HotCompanies;
/** 认证重置校验 */
extern NSString *const URL_Mine_ReviewTimeVerification;
/** 系统消息 */
extern NSString *const URL_Mine_SystemsMessages;
/** 外层系统消息 */
extern NSString *const URL_Mine_OuterSystemMessage;
/** 系统消息操作 */
extern NSString *const URL_Mine_SystemsMessageAction;

/** 省份 */
extern NSString *const URL_Mine_ListProvinces;
/** 大学 */
extern NSString *const URL_Mine_ListUniversities;
/** 专业 */
extern NSString *const URL_Mine_ListMajors;
/** 新增或更新教育经历 */
extern NSString *const URL_Mine_EducationExperienceRenewal;
/** 删除教育经历 */
extern NSString *const URL_Mine_EducatiopnExerienceRemoval;
/** 获取教育经历 */
extern NSString *const URL_Mine_EducationExperienceList;

// MARK: ---- 通用 ----
/** 阿里芝麻信用分 */
extern NSString *const URL_Common_GetZmScore;
/** 收藏 */
extern NSString *const URL_Collection;
/** 取消收藏 */
extern NSString *const URL_Cancel_Collection;
/** 综合搜索数据 */
extern NSString *const URL_Common_Search;
/** 获取技能列表 */
extern NSString *const URL_Common_Skills;
/** 校验支付密码 */
extern NSString *const URL_Common_PayPwdVerification;
/** 检查是否有支付密码 */
extern NSString *const URL_Common_CheckUserHasPayPwd;
/** 关注保过职位V1 */
extern NSString *const URL_Common_WatchPosition;
/** 关注解密V1 */
extern NSString *const URL_Common_WatchDecrypt;
/** 极光推送id更新 */
extern NSString *const URL_Common_RegIdRenewal;
/** 红包弹出校验 */
extern NSString *const URL_Common_CheckRedPacketOpened;
/** 红包领取 */
extern NSString *const URL_Common_OpenRedPacket;






