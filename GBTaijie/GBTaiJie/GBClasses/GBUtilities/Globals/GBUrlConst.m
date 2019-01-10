//
//  GBUrlConst.m
//  GBTaiJie
//
//  Created by 刘小坤 on 2018/6/1.
//  Copyright © 2018年 刘小坤. All rights reserved.
//

#import <Foundation/Foundation.h>

//*------------------
// MARK: 服务器域名
//-------------------*

/** 七牛云图片服务 */
NSString *const BASE_URL_IMAGE_QINIUYUN = @"http://res.gebihr.com/";
/** 七牛云Token */
NSString *const URL_IMAGE_GetQiuNiuUpToken = @"common/getQiuNiuUpToken";
/** h5域名 */
NSString *const URL_GB_HTML = @"http://doc.taijie.work/";
// 测试h5域名
NSString *const URL_GB_Test_HTML = @"http://m.taijie.work/";


//*------------------
// MARK: H5
//-------------------*
/** 用户协议 */
NSString *const HTML_User_Agreement = @"user_agreement.html";
/** 服务保障计划 */
NSString *const HTML_Service_Garantee = @"service_garantee.html";

/** 个人主页分享 */
NSString *const HTML_HomePage_Share = @"http://cs.taijie.work/app/sharepp/index.html?id=";

//*------------------
// MARK: 登录页
//-------------------*
/**   登录   */
NSString *const URL_Login = @"user/login";
/**   登录验证码   */
NSString *const URL_Login_Code = @"common/sendVerificationCode";
/** 注册 */
NSString *const URL_Login_Register = @"user/register";
/** 是否注册 */
NSString *const URL_Login_CheckRegister = @"entry/user/continue";

//*------------------
// MARK: 首页
//-------------------*
/** 首页列表 */
NSString *const URL_HomePage_List = @"entry/index";
/** 老司机换一批 */
NSString *const URL_HomePage_RandDecrypts = @"entry/randDecrypts";
/** 更多保过大师 */
NSString *const URL_HomePage_MoreMasters = @"entry/moreMasters";
/** 更多保过职位 */
NSString *const URL_HomePage_MorePositions = @"entry/morePositions";
/** 更多文章 */
NSString *const URL_HomePage_MoreEssays = @"entry/moreEssays";
/** 关注保过职位 */
NSString *const URL_HomePage_WatchPosition = @"entry/watchPosition";
/** 关注解密 */
NSString *const URL_HomePage_WatchDecrypt = @"entry/watchDecrypt";
/** 职位搜索 */
NSString *const URL_HomePage_PositionSearch = @"entry/positionSearch";
/** 职位搜索主页谁能邦你-更多V1 */
NSString *const URL_HomePage_MorePositionRelatedMasters = @"entry/morePositionRelatedMasters";
/** 职位搜索主页相关解密-更多V1 */
NSString *const URL_HomePage_MorePositionRelatedDecrypts = @"entry/morePositionRelatedDecrypts";
/** 职位搜索主页-热门职位V1 */
NSString *const URL_HomePage_hotJob = @"entry/hotJob";

/** 公司搜索主页-公司名称检索V1 - 实时显示 */
NSString *const URL_Home_CompanyNamesSearch = @"entry/companyNamesSearch";
/** 公司搜索主页-搜索加载V1 */
NSString *const URL_HomePage_CompanySearch = @"entry/companySearch";
/** 公司搜索主页-职位换一批V1 */
NSString *const URL_HomePage_CompanyPositionChanging = @"entry/companyPositionChanging";
/** 公司搜索主页-认证同事更多V1 */
NSString *const URL_HomePage_MoreCompanyIncumbents = @"entry/moreCompanyIncumbents";
/** 公司搜索主页-相关解密更多V1 */
NSString *const URL_HomePage_MoreCompanyDecrypts = @"entry/moreCompanyDecrypts";
/** 公司搜索-推荐公司V1 */
NSString *const URL_HomePage_HotCompanies = @"entry/hotCompanies";
/** 搜索轨迹更新V1 */
NSString *const URL_HomePage_SearchTrace = @"entry/searchTrace";

/** 推荐保过大师数 */
NSString *const URL_HomePage_MastersCount = @"entry/mastersCount";
/** 更多职位 */
NSString *const URL_HomePage_Cpositions = @"entry/cpositions";

/** 更多公司 */
NSString *const URL_HomePage_MoreCompanies = @"entry/moreCompanies";
/** 公司主页 */
NSString *const URL_HomePage_CompanyMainPage = @"entry/companyMainPage";
/** 个人主页增加访问量 */
NSString *const URL_HomePage_VisitOnce = @"incumbent/visitOnce";
/** 公司主页在职同事换一批 */
NSString *const URL_HomePage_CompanyIncumbentsChanging = @"entry/companyIncumbentsChanging";
/** 更多公司在招职位 */
NSString *const URL_HomePage_MoreCompanyPositions = @"entry/moreCompanyPositions";
/** 爬取职位观注V1 */
NSString *const URL_HomePage_WatchcPosition = @"entry/watchcPosition";

/** 更多解密咨询 */
NSString *const URL_HomePage_MoreDecrypts = @"entry/moreDecrypts";
/** 更多解密服务 */
NSString *const URL_HomePage_More_Decrypt = @"entry/service/personalDecrypt";

//*------------------
// MARK: 发现
//-------------------*
/** 发现 */
NSString *const URL_Find_FindSearch = @"entry/findSearch";
/** 发现-热心同事换一批 */
NSString *const URL_Find_ChangingWarmIncumbents = @"entry/changingWarmIncumbents";
/** 发现页-特价免费及各TAB */
NSString *const URL_Find_ChangingDecrypts = @"entry/changingDecrypts";
/** 发现更多 */
NSString *const URL_Find_MoreDecrypts = @"entry/foundMoreDecrypts";
/** 服务评论列表 */
NSString *const URL_Find_Service_CommentList = @"service/single/commentList";

//*------------------
// MARK: 找人页
//-------------------*

/** 找人banner */
NSString *const URL_FindPeople_Banner = @"basics/advertisements";
/** 推荐的人 */
NSString *const URL_FindPeople_PersonList = @"candidate/matchingIncumbents";
/** 黑名单 */
NSString *const URL_FindPeople_Join_blacklist = @"blacklist/join";
/** 获取找人意向 */
NSString *const URL_FindPeople_Incumbent = @"intentionIncumbent/intentionalIncumbent";
/** 新建更新找人意向 */
NSString *const URL_FindPeople_Renewal = @"intentionIncumbent/intentionalRenewal";
/** 获取城市列表 */
NSString *const URL_FindPeople_region = @"basics/region";
/** 检索公司 */
NSString *const URL_FindPeople_SearchCompany = @"company/simpleCompanyInfoByKey";
/** 获取职位三级列表 */
NSString *const URL_FindPeople_jobList = @"basics/jobList";
/** 进入找人页之前的信息提交 */
NSString *const URL_FindPeople_SkipPage = @"intention/skipPage";
/** 地区拼音 */
NSString *const URL_FindPeople_CityCode = @"basics/cityCode";
/** 个人主页-服务 */
NSString *const URL_FindPeople_PersonalService = @"service/personal";
/** 个人主页-在职者信息及评论 */
NSString *const URL_FindPeople_Info_Comment = @"incumbent/personalPage";
/** 举报 */
NSString *const URL_FindPeople_Report = @"common/report";

//*------------------
// MARK: 职位页
//-------------------*
/** 根据意向匹配职位 */
NSString *const URL_Position_PostionList = @"position/getPostionListByIntentionalIds";
/** 根据意向id获取解密服务 */
NSString *const URL_Position_Decrypt = @"decrypt/incumbentDecryptOfUserIntentionRelevance";
/** 获取意向列表 */
NSString *const URL_Position_IntentionalPositions = @"intention/intentionalPositions";
/** 职位详情 */
NSString *const URL_Position_Deatail = @"position/postionInfoByPositionId";
/** 获取学历 */
NSString *const URL_Position_DilamorCode = @"basics/dilamorCode";
/** 获取经验 */
NSString *const URL_Position_Experience = @"basics/experienceCode";
/** 获取行业 */
NSString *const URL_Position_Industries = @"basics/industries";
/** 删除意向职位 */
NSString *const URL_Position_IntentionalPositionRemoval = @"intention/intentionalPositionRemoval";
/** 保过详情页 */
NSString *const URL_Position_AssurePassDetail = @"service/assurePassDetail";
/** 获取解密详情页 */
NSString *const URL_Position_DecryptDetail = @"service/decryptDetail";
/** 预约解密 */
NSString *const URL_Position_OrderDecrypt = @"decrypt/orderDecrypt";
/** 预约保过 */
NSString *const URL_Position_OrderAssurePass = @"assurePass/orderAssurePass";
/** 行业类型 */
NSString *const URL_Position_IndustryType = @"basics/industryType";
/** 意向职位新增更新 */
NSString *const URL_Position_IntentionalPositionRenewal = @"intention/intentionalPositionRenewal";
/** 支付 */
NSString *const URL_Position_Pay = @"pay/pay";
/** 公司在招职位 */
NSString *const URL_Position_Recruiting = @"position/postionListByCompanyId";
/** 在职同事 */
NSString *const URL_Position_Colleague = @"incumbent/companyIncumbentList";
/** 公司信息 */
NSString *const URL_Position_CompanyInfo = @"company/companyInfo";
/** 职位搜索 */
NSString *const URL_Postition_Search = @"position/searchPositionInfoByKey";
/** 公司搜索 */
NSString *const URL_Company_Search = @"company/searchCompanyInfoByKey";
/** 在职者搜索 */
NSString *const URL_Personal_Search = @"incumbent/searchIncumbentInfoByKey";


//*------------------
// MARK: 论坛
//-------------------*
/** 帖子列表 */
NSString *const URL_Tieba_List = @"gossip/list";
/** 帖子评论列表 */
NSString *const URL_Tieba_Comment_List = @"gossip/commentList";
/** 帖子获取用户昵称 */
NSString *const URL_Tieba_Nick = @"gossip/isAnnoymous";
/** 帖子修改用户昵称 */
NSString *const URL_Tieba_UpdateNick = @"gossip/nickNameModification";
/** 话题关闭 */
NSString *const URL_Tieba_Close = @"gossip/close";
/** 点赞 */
NSString *const URL_Tieba_Like = @"gossip/like";
/** 取消点赞 */
NSString *const URL_Tieba_CancelLike = @"gossip/cancelLike";
/** 发表评论 */
NSString *const URL_Tieba_Publish_Comment = @"gossip/comment";
/** 发表帖子 */
NSString *const URL_Tieba_Publish = @"gossip/publishment";
/** 评论删除 */
NSString *const URL_Tieba_CommentClose = @"gossip/comment/close";

//*------------------
// MARK: 我的
//-------------------*

/** 用户个人信息 */
NSString *const URL_Mine_Info = @"user/getIncumbentInfo";
/** 编辑资料带擅长领域个人信息 */
NSString *const URL_Mine_EditInfo = @"user/getUserInfoWithSkills";
/** 更新用户信息带有技能信息 */
NSString *const URL_Mine_UpdateEditInfo = @"user/updateUserInfoWithSkills";
/** 我的余额 */
NSString *const URL_Mine_Balance = @"user/balance";
/** 充值 */
NSString *const URL_Mine_InAppPurchase = @"pay/iosInAppPurchase";
/** 余额中交易流水 */
NSString *const URL_Mine_UserMoneyRecord = @"user/userMoneyRecord";
/** 已购订单 */
NSString *const URL_Mine_PurchasedOrder = @"order/purchasedOrder";
/** 删除订单 */
NSString *const URL_Mine_UserOrderRemoval = @"order/userOrderRemoval";
/** 在职者服务订单 */
NSString *const URL_Mine_IncumbentOrder = @"order/incumbentOrder";
/** 解密订单详情 */
NSString *const URL_Mine_GetDecryptOrderDetails = @"decrypt/getDecryptOrder";
/** 保过订单详情 */
NSString *const URL_Mine_GetAssurePassOrderDetails = @"assurePass/getAssurePassOrder";
/** 更新支付密码 */
NSString *const URL_Mine_PayPwdRenewal = @"user/payPwdRenewal";
/** 更新登录密码 */
NSString *const URL_Mine_PwdRenewal = @"user/pwdRenewal";
/** 更新用户手机号 */
NSString *const URL_Mine_UserTelRenewal = @"user/userTelRenewal";
/** 更新用户支付宝账户 */
NSString *const URL_Mine_UpdateUserAlipayAccount = @"user/updateUserAlipayAccount";

/** 我的收藏 */
NSString *const URL_Mine_CollectionList = @"user/collectionList";
/** 在职者认证信息 */
NSString *const URL_Mine_IncumbentAuthenticationInfo = @"incumbent/incumbentAuthenticationInfo";
/** 提交认证信息 */
NSString *const URL_Mine_IncumbentAuthenticationInfoSubmition = @"incumbent/incumbentAuthenticationInfoSubmition";
/** 提交认证信息成功之后提交审核 */
NSString *const URL_Mine_AuditionSubmition = @"incumbent/auditionSubmition";
/** 认证状态 */
NSString *const URL_Mine_IncumbentAuthenticationState = @"incumbent/incumbentAuthenticationState";
/** 新增/更新在职者解密服务 */
NSString *const URL_Mine_DecryptRenewal = @"decrypt/incumbentDecryptRenewal";
/** 新增/更新在职者保过服务 */
NSString *const URL_Mine_AssurePassRenewal = @"assurePass/incumbentAssurePassRenewal";
/** 解密服务列表 */
NSString *const URL_Mine_DecryptServiceList = @"service/incumbentDecryptService";
/** 保过服务列表 */
NSString *const URL_Mine_AssurePasstServiceList = @"service/incumbentAssurePassService";
/** 在职者解密服务详情 */
NSString *const URL_Mine_myIncumbentDecrypt = @"decrypt/myIncumbentDecrypt";
/** 删除在职者解密服务 */
NSString *const URL_Mine_DeleteIncumbentDecrypt = @"decrypt/deleteIncumbentDecrypt";
/** 获取单个在职者保过服务详情 */
NSString *const URL_Mine_IncumbentDetail = @"assurePass/incumbentDetail";
/** 删除在职者保过服务 */
NSString *const URL_Mine_DeleteIncumbentAssurePass = @"assurePass/deleteIncumbentAssurePass";
/** 解密服务评价 */
NSString *const URL_Mine_Decrypt_Evaluate = @"decrypt/evaluate";
/** 保过服务评价 */
NSString *const URL_Mine_AssurePass_Evaluate = @"assurePass/evaluate";

/** 接受解密 */
NSString *const URL_Mine_Decrypt_Accept = @"decrypt/accept";
/** 结束解密 */
NSString *const URL_Mine_Decrypt_Finish = @"decrypt/finish";
/** 拒绝解密 */
NSString *const URL_Mine_Decrypt_Reject = @"decrypt/reject";
/** 取消解密 */
NSString *const URL_Mine_Decrypt_Cancel = @"decrypt/cancel";

/** 接受保过 */
NSString *const URL_Mine_AssurePass_Accept = @"assurePass/accept";
/** 结束保过 */
NSString *const URL_Mine_AssurePass_Finish = @"assurePass/finish";
/** 拒绝保过 */
NSString *const URL_Mine_AssurePass_Reject = @"assurePass/reject";
/** 保过取消 */
NSString *const URL_Mine_AssurePass_Cancel = @"assurePass/cancel";
/** 解密可用性 */
NSString *const URL_Mine_Decrypt_Availability = @"decrypt/orderAvailability";
/** 保过可用性 */
NSString *const URL_Mine_AssurePass_Availability = @"assurePass/orderAvailability";
/** 提现 */
NSString *const URL_Mine_WithdrawDeposit = @"user/withdrawDeposit";
/** 获取支付宝账号 */
NSString *const URL_Mine_GetUserAlipayAccount = @"user/getUserAlipayAccount";
/** 删除求职者技能 */
NSString *const URL_Mine_candidateSkillsRemoval = @"resume/candidateSkillsRemoval";
/** 获取求职者技能 */
NSString *const URL_Mine_candidateSkills = @"resume/candidateSkills";
/** 新增更新技能 */
NSString *const URL_Mine_skillRenewal = @"resume/skillRenewal";
/** 意见反馈 */
NSString *const URL_Mine_FeedBack = @"common/feedBack";
/** 提现记录 */
NSString *const URL_Mine_WithdrawDepositList = @"user/withdrawDepositList";
/** 过往微经验 */
NSString *const URL_Mine_MicroExperience = @"resume/microExperience";
/** 经验更新 */
NSString *const URL_Mine_SingleMicroExperienceRenewal = @"resume/singleMicroExperienceRenewal";
/** 微经验删除 */
NSString *const URL_Mine_MicroExperienceRemoval = @"resume/microExperienceRemoval";
/** 订单状态红色提醒(点入消除) */
NSString *const URL_Mine_NoticeStatusRenewal = @"order/noticeStatusRenewal";
/** 检查订单总状态及分TAB状态 */
NSString *const URL_Mine_OrderNewStatus = @"order/orderNewStatus";

/** 保过标签 */
NSString *const URL_Mine_assurePassLabels = @"assurePass/labels";
/** 认证重置校验 */
NSString *const URL_Mine_ReviewTimeVerification = @"incumbent/reviewTimeVerification";

/** 外层系统消息 */
NSString *const URL_Mine_OuterSystemMessage = @"user/outerMessage";
/** 系统消息 */
NSString *const URL_Mine_SystemsMessages = @"user/messages";
/** 系统消息操作 */
NSString *const URL_Mine_SystemsMessageAction = @"user/message/opt";

/** 省份 */
NSString *const URL_Mine_ListProvinces = @"education/listProvinces";
/** 大学 */
NSString *const URL_Mine_ListUniversities = @"education/listUniversities";
/** 专业 */
NSString *const URL_Mine_ListMajors = @"education/listMajors";
/** 新增或更新教育经历 */
NSString *const URL_Mine_EducationExperienceRenewal = @"education/educationExperienceRenewal";
/** 删除教育经历 */
NSString *const URL_Mine_EducatiopnExerienceRemoval = @"education/educatiopnExerienceRemoval";
/** 获取教育经历 */
NSString *const URL_Mine_EducationExperienceList = @"education/educationExperienceList";

//*------------------
// MARK: Common 通用
//-------------------*
/** 初始化芝麻认证 */
NSString *const URL_Mine_InitAntAuthenticate = @"common/initAntAuthenticate";
/** 阿里芝麻信用分签名 */
NSString *const URL_Mine_getAlipayAccountAuthSign = @"common/getAlipayAccountAuthSign";
/** 阿里芝麻信用分 */
NSString *const URL_Common_GetZmScore = @"user/getZmScore";
/** 收藏 */
NSString *const URL_Collection = @"user/collection";
/** 取消收藏 */
NSString *const URL_Cancel_Collection = @"user/collectCancellation";
/** 综合搜索数据 */
NSString *const URL_Common_Search = @"common/search";
/** 获取技能列表 */
NSString *const URL_Common_Skills = @"basics/getSkills";
/** 校验支付密码 */
NSString *const URL_Common_PayPwdVerification = @"user/payPwdVerification";
/** 检查是否有支付密码 */
NSString *const URL_Common_CheckUserHasPayPwd = @"user/checkUserHasPayPwd";
/** 关注保过职位V1 */
NSString *const URL_Common_WatchPosition = @"entry/watchPosition";
/** 关注解密V1 */
NSString *const URL_Common_WatchDecrypt = @"entry/watchDecrypt";
/** 极光推送id更新 */
NSString *const URL_Common_RegIdRenewal = @"user/regIdRenewal";
/** 红包弹出校验 */
NSString *const URL_Common_CheckRedPacketOpened = @"user/isRedPacketOpened";
/** 红包领取 */
NSString *const URL_Common_OpenRedPacket = @"user/openRedPacket";












