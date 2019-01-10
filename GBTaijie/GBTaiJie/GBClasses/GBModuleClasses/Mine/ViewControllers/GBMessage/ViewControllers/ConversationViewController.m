//
//  ConversationViewController.m
//  JMessage-AuroraIMUI-OC-Demo
//
//  Created by oshumini on 2017/6/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import "ConversationViewController.h"
//#import <AuroraIMUI/AuroraIMUI-Swift.h>
#import "GBTaiJie-Swift.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "MessageModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XKSelPhotos.h"
#import <MobileCoreServices/UTCoreTypes.h>

/** 个人主页 */
#import "GBCommonPersonalHomePageViewController.h"

#import "YBImageBrowseCellData.h"
#import "YBImageBrowser.h"
#import "MessageLayout.h"
#import "JMImageBubbleContentView.h"

#import "JCHATToolBar.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"

#import "XHShareMenuView.h"
#import "XHEmotionManagerView.h"
#import "DSEmotionUtils.h"
#import "XHMessageInputView.h"


#import "GMenuController.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

static NSInteger const messagePageNumber = 20;

#define kVoiceRecorderTotalTime 60.0
#define interval 60*5 //static =const

@interface ConversationViewController() <IMUIInputViewDelegate, IMUIMessageMessageCollectionViewDelegate, JMessageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SendMessageDelegate,XHShareMenuViewDelegate,XHEmotionManagerViewDelegate,XHEmotionManagerViewDataSource>
/** 消息列表 */
@property (weak, nonatomic) IBOutlet IMUIMessageCollectionView *messageList;
///** 消息输入视图 */
@property (weak, nonatomic) IBOutlet JCHATToolBarContainer *imuiInputView;

//@property (strong, nonatomic) IMUIMessageCollectionView *messageList;
/** 消息输入视图 */
//@property (strong, nonatomic) IMUIInputView *imuiInputView;

/* 当前操作的消息 （点击、复制、删除） */
@property(strong, nonatomic) MessageModel *currentOperationMessageModel;

/* <#describe#> */
@property (nonatomic, assign) BOOL isNoOtherMessage;

/* 消息偏移量 */
@property (nonatomic, assign) NSInteger messageOffset;
/* 缓存所有的message model */
@property (nonatomic, strong) NSMutableDictionary *allMessageDic;
/* 按序缓存后所有的messageId，与allMessage 一起使用 */
@property (nonatomic, strong) NSMutableArray *allmessageArr;
@property (nonatomic, strong) UIImagePickerController *ipc;


@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playLayer;
@property(nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;
/**
 *  管理录音工具对象
 */
@property(nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;
@property (nonatomic, strong) XHShareMenuView *shareMenuView;
@property (nonatomic, strong) XHEmotionManagerView *emotionManagerView;
/**
 *  第三方接入的功能，也包括系统自身的功能，比如拍照、发送地理位置
 */
@property (nonatomic, strong) NSArray *shareMenuItems;
@property (nonatomic, strong) NSArray *emotionManagers;
@property (strong, nonatomic) NSDictionary * facesDic;
@property (strong, nonatomic) NSArray *facesAry;
@property (nonatomic,strong) NSArray *faceNUmArr;
@property (nonatomic, assign) XHInputViewType textViewInputViewType;
@property (nonatomic, assign) CGFloat keyboardViewHeight;
/**
 *  记录旧的textView contentSize Heigth
 */
@property(nonatomic, assign) CGFloat previousTextViewContentHeight;
@property(assign, nonatomic) BOOL barBottomFlag;

@end

@implementation ConversationViewController

#pragma mark - LifeCyle -
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 清理当前会话未读数
    [self.conversation clearUnreadCount];
    
    // 是否启用键盘管理
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewDidLayoutSubviews {
    //    [self.messageList scrollToBottomWith:true];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToBottomAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 是否启用键盘管理
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
    self.customNavBar.title = self.conversation.title;
    self.customNavBar.titleLabelColor = [UIColor kImportantTitleTextColor];
    
    [self.imuiInputView.toolbar drawRect:self.imuiInputView.toolbar.frame];
    
}

- (void)addDelegate {
    [JMessage addDelegate:self withConversation:self.conversation];
    self.imuiInputView.toolbar.delegate = self;
    
}

- (void)addtoolbar {
    self.imuiInputView.toolbar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    [self.imuiInputView addSubview:self.imuiInputView.toolbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    page = 0;
    _previousTextViewContentHeight = 31;
    self.keyboardViewHeight = (kXHEmotionImageViewSize+15)*3+kXHEmotionPageControlHeight+BottomViewFitHeight(kXHEmotionSectionBarHeight);
    
    [self.imuiInputView.toolbar.textView addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
    self.messageListTop.constant = SafeAreaTopHeight;
    self.targetAvatar = [UIImage imageWithContentsOfFile:self.conversation.avatarLocalPath];
    [self setupSubView];
    [self getPageMessage];
    
    [self addDelegate];
    
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"icon_img", @"icon_photograph"];
    NSArray *plugTitle = @[@"图片", @"拍摄"];
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    
    NSString *emotionPath = [[NSBundle mainBundle] pathForResource:@"emotion" ofType:@"plist"];
    NSString *emotionImagePath = [[NSBundle mainBundle] pathForResource:@"emotionImage1" ofType:@"plist"];
    self.facesDic = [[NSDictionary alloc]initWithContentsOfFile:emotionImagePath];
    self.faceNUmArr = [[NSArray alloc]initWithContentsOfFile:emotionPath];
    
    NSMutableArray *lastArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSNumber  *str in self.faceNUmArr) {
        int aaa = [str intValue];
        int sym = EMOJI_CODE_TO_SYMBOL(aaa);
        NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
        [lastArr addObject:emoT];
    }
    self.facesAry = lastArr;
    
    NSMutableArray *emotionManagers = [NSMutableArray array];
    for (NSInteger i = 0; i < 1; i ++) {
        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
        emotionManager.emotionName = @"默认";
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSInteger j = 0; j < self.facesAry.count; j ++) {
            XHEmotion *emotion = [[XHEmotion alloc] init];
            NSString * tmpStr = [self.facesAry objectAtIndex:j];
            emotion.emotionStr = tmpStr;
            if (j==20) {
                emotion.emotionStr = @"";
            }
            if (j==41) {
                emotion.emotionStr = @"";
            }
            if (j==62) {
                emotion.emotionStr = @"";
            }
            if (j==83) {
                emotion.emotionStr = @"";
            }
            if (j==94) {
                emotion.emotionStr = @"";
            }
            [emotions addObject:emotion];
        }
        emotionManager.emotions = emotions;
        [emotionManagers addObject:emotionManager];
    }
    self.emotionManagers = emotionManagers;
    [self.emotionManagerView reloadData];
    
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
    
    AdjustsScrollViewInsetNever(self, self.imuiInputView.toolbar.textView);
}

- (void)setupSubView {
    //    [self.view addSubview:self.messageList];
    //    [self.view addSubview:self.imuiInputView];
    
    self.messageList.delegate = self;
    //    self.imuiInputView.inputViewDelegate = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPageMessage)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.messageList.messageCollectionView.mj_header = header;
}

#pragma mark - # Data
// 加载消息
- (void)getPageMessage {
    NSArray *messageArray = [_conversation messageArrayFromNewestWithOffset:@(page * messagePageNumber) limit:@(messagePageNumber)];
    NSMutableArray *messageModelArray = @[].mutableCopy;
    for (NSInteger i=0; i< [messageArray count]; i++) {
        JMSGMessage *message = [messageArray objectAtIndex:i];
        MessageModel *lastMessageModel = [self.allmessageArr lastObject];
        BOOL isNeedShowTime;
        if ((i == messageArray.count - 1) && messageArray.count < 20) {
            // 最后一条
            isNeedShowTime = YES;
        }else {
            isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
        }
        
        MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
        [messageModelArray addObject:messageModel];
        [self.allmessageArr addObject:messageModel];
    }
    
    [JMessage addDelegate:self withConversation:_conversation];
    [_messageList insertMessagesWith:messageModelArray];
    
    [self.messageList.messageCollectionView.mj_header endRefreshing];
    
    if ([messageArray count] < 20) {
        NSLog(@"没有更多数据了");
    }
    
    page ++;
    
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (BOOL)dataMessageShowTime:(NSNumber *)timeNumber lastTime:(NSNumber *)lastTimeNumber {
    NSTimeInterval timeNumberTimeInterVal = [timeNumber longLongValue];
    
    NSTimeInterval lastTimeNumberTimeInterVal = [lastTimeNumber longLongValue];
    
    if ([self.allmessageArr count]>0) {
        NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:lastTimeNumberTimeInterVal/1000];
        NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeNumberTimeInterVal/1000];
        NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
        if (fabs(timeBetween) > interval) {
            return YES;
        }
    } else if ([self.allmessageArr count] ==0) {//首条消息显示时间
        return YES;
    } else {
        return NO;
        NSLog(@"不用显示时间");
    }
    
    return NO;
}

#pragma mark - # Target Methods
/** 复制 */
- (void)copyMessage {
    [[GMenuController sharedMenuController] setMenuVisible:NO];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    switch (self.currentOperationMessageModel.message.contentType) {
        case kJMSGContentTypeText:
        {
            JMSGTextContent *textContent = (JMSGTextContent *)self.currentOperationMessageModel.message.content;
            pboard.string = textContent.text;
        }
            break;
            
        case kJMSGContentTypeImage:
        {
            JMSGImageContent *imgContent = (JMSGImageContent *)self.currentOperationMessageModel.message.content;
            [imgContent thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
                if (data == nil || error) {
                    [UIView showHubWithTip:@"获取图片错误"];
                    return ;
                }
                pboard.image = [UIImage imageWithData:data];
            }];
        }
            break;
            
        case kJMSGContentTypeVoice:
            break;
        case kJMSGContentTypeUnknown:
            break;
        default:
            break;
    }
    
    if (pboard == nil) {
        [UIView showHubWithTip:@"复制失败"];
    }else {
        [UIView showHubWithTip:@"复制成功"];
    }
}

/** 删除 */
- (void)deleteMessage {
    [[GMenuController sharedMenuController] setMenuVisible:NO];
    
    JMSGMessage *message = self.currentOperationMessageModel.message;
    [_conversation deleteMessageWithMessageId:message.msgId];
    [self.messageList removeMessageWith:message.msgId];
}

#pragma mark - Delegate
/** IMUIMessageMessageCollectionViewDelegate */
// - MARK: 点击头像
- (void)messageCollectionViewWithDidTapHeaderImageInCell:(UICollectionViewCell *)didTapHeaderImageInCell model:(MessageModel<IMUIMessageProtocol>*)model {
    NSLog(@"点击头像");
    GBCommonPersonalHomePageViewController *personHomePageVC = [[GBCommonPersonalHomePageViewController alloc] init];
    personHomePageVC.targetUsrid = model.fromUser.userId;
    [self.navigationController pushViewController:personHomePageVC animated:YES];
}

// - MARK: 点击cell
- (void)messageCollectionView:(UICollectionView *)_ forItemAt:(NSIndexPath *)forItemAt model:(id<IMUIMessageProtocol>)model {
    NSLog(@"点击cell");
}

// - MARK: 点击气泡
- (void)messageCollectionViewWithDidTapMessageBubbleInCell:(UICollectionViewCell *)didTapMessageBubbleInCell model:(MessageModel<IMUIMessageProtocol>*)model {
    NSLog(@"点击气泡");
    switch (model.message.contentType) {
        case kJMSGContentTypeText:
            break;
        case kJMSGContentTypeImage:
        {
            JMSGImageContent *imgContent = (JMSGImageContent *)model.message.content;
            [imgContent largeImageDataWithProgress:^(float percent, NSString *msgId) {
            } completionHandler:^(NSData *data, NSString *objectId, NSError *error) {
                if (data == nil || error) {
                    [UIView showHubWithTip:@"获取图片错误"];
                    return ;
                }
                // 配置数据源（图片浏览器每一张图片对应一个 YBImageBrowserModel 实例）
                MessageLayout *layout = (MessageLayout *)model.layout;
                JMImageBubbleContentView *imageBubbleContentView = (JMImageBubbleContentView *)layout.bubbleContentView;
                NSMutableArray *tempArr = [NSMutableArray array];
                YBImageBrowseCellData *model = [YBImageBrowseCellData new];
                model.image = (YBImage *)[UIImage imageWithData:data];
                model.sourceObject = imageBubbleContentView.imageMessageView;
                [tempArr addObject:model];
                YBImageBrowser *browser = [YBImageBrowser new];
                browser.dataSourceArray = tempArr;
                //展示
                [browser show];
            }];
        }
            break;
        case kJMSGContentTypeVoice:
            break;
        case kJMSGContentTypeUnknown:
            break;
        default:
            break;
    }
}

// - MARK: 长按
- (void)messageCollectionViewWithBeganLongTapMessageBubbleInCell:(UICollectionViewCell *)beganLongTapMessageBubbleInCell model:(MessageModel<IMUIMessageProtocol>*)model {
    NSLog(@"长按");
    self.currentOperationMessageModel = model;
    GMenuItem *item1 = [[GMenuItem alloc] initWithTitle:@"复制" target:self action:@selector(copyMessage)];
    GMenuItem *item2 = [[GMenuItem alloc] initWithTitle:@"删除" target:self action:@selector(deleteMessage)];
    NSArray *tempArray = @[item1,item2];
    [[GMenuController sharedMenuController] setMenuItems:tempArray];
    [[GMenuController sharedMenuController] setTargetRect:model.layout.bubbleFrame inView:beganLongTapMessageBubbleInCell.contentView];
    [[GMenuController sharedMenuController] setMenuVisible:YES];
}


/**  IMUIInputViewDelegate */
// - MARK: cell将绘制
- (void)messageCollectionView:(UICollectionView * _Nonnull)willBeginDragging {
    //    [_imuiInputView hideFeatureView];
}

// - MARK: 发送文本消息
- (void)sendTextMessage:(NSString * _Nonnull)messageText {
    JMSGTextContent *content = [[JMSGTextContent alloc] initWithText: messageText];
    JMSGMessage *message = [_conversation createMessageWithContent: content];
    MessageModel *lastMessageModel = [self.allmessageArr firstObject];
    BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
    MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
    [self.allmessageArr insertObject:messageModel atIndex:0];
    
    [_conversation sendMessage:message];
    [_messageList appendMessageWith: messageModel];
}

// - MARK: 选择 语音
- (void)switchToMicrophoneModeWithRecordVoiceBtn:(UIButton * _Nonnull)recordVoiceBtn {
    
}

// - MARK: 开始 语音
- (void)startRecordVoice {
    
}

// - MARK: 完成 语音
- (void)finishRecordVoice:(NSString * _Nonnull)voicePath durationTime:(double)durationTime {
    NSData *voiceData = [NSData dataWithContentsOfFile:voicePath];
    JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:voiceData voiceDuration:@(durationTime)];
    
    if (voiceContent != nil) {
        JMSGMessage *message = [_conversation createMessageWithContent:voiceContent];
        MessageModel *lastMessageModel = [self.allmessageArr firstObject];
        BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
        MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
        [self.allmessageArr insertObject:messageModel atIndex:0];
        
        [_conversation sendMessage:message];
        [_messageList appendMessageWith:messageModel];
    }
    
    [self removeFile:voicePath];
}

// - MARK: 取消 语音
- (void)cancelRecordVoice {
    
}

// - MARK: 选择 图片
- (void)switchToGalleryModeWithPhotoBtn:(UIButton * _Nonnull)photoBtn {
    XKSelPhotos *imageManager = [XKSelPhotos selPhotos];
    [imageManager pushImagePickerControllerWithImagesCount:9 WithColumnNumber:3 didFinish:^(TZImagePickerController *imagePickerVc) {
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            for (UIImage *image in photos) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:imageData];
                JMSGMessage *message = [self.conversation createMessageWithContent:imageContent];
                MessageModel *lastMessageModel = [self.allmessageArr firstObject];
                BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
                MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
                [self.allmessageArr insertObject:messageModel atIndex:0];
                [self.conversation sendMessage:message];
                [self.messageList appendMessageWith:messageModel];
            }
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }];
}

// - MARK: 完成选择 图片 - 弃用
- (void)didSeletedGalleryWithAssetArr:(NSArray<PHAsset *> * _Nonnull)AssetArr {
}


// - MARK: 选择 相机视频
- (void)switchToCameraModeWithCameraBtn:(UIButton * _Nonnull)cameraBtn {
    // 自定视频拍摄
    [self startRecordVideo];
}

// - MARK: 完成 拍照 - 弃用
- (void)didShootPictureWithPicture:(NSData * _Nonnull)picture {
    
}

// - MARK: 开始 录制视频
- (void)startRecordVideo {
    _ipc = [[UIImagePickerController alloc] init];
    _ipc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    _ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    //    _ipc.videoMaximumDuration = 600.0f;//600秒
    _ipc.delegate = self;//设置委托
    _ipc.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;   //设置视频质量
    
    _ipc.modalPresentationStyle=UIModalPresentationOverFullScreen;
    [self presentViewController:_ipc animated:YES completion:nil];
}

//获取视频文件的时长。
- (CGFloat)getVideoLength:(NSURL *)URL {
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}

#pragma mark - image picker delegte
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    });
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    });
    
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:sourceURL]]);
    NSURL *newVideoUrl ; //一般.mp4
    // 用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    // 这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。
    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;
    
    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl withFileName:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]] completeHandler:nil];
}

//转码MP4
- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                              outputURL:(NSURL*)outputURL
                           withFileName:(NSString *)filePath
                        completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    if (@available(iOS 11.0, *)) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset1280x720];
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse= YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     break;
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     break;
                 case AVAssetExportSessionStatusCompleted:{
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     NSData *videoData = [NSData dataWithContentsOfURL:outputURL];
                     AVURLAsset *asset = [AVURLAsset URLAssetWithURL:outputURL options:nil];
                     AVAssetImageGenerator *imgGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
                     NSError *error = nil;
                     imgGenerator.appliesPreferredTrackTransform = YES;
                     CGImageRef cgImg = [imgGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error: &error];
                     UIImage *img = [UIImage imageWithCGImage:cgImg];
                     
                     JMSGVideoContent *content = [[JMSGVideoContent alloc] initWithVideoData:videoData thumbData:UIImagePNGRepresentation(img) duration:[NSNumber numberWithFloat:[self getVideoLength:outputURL]]];
                     content.format = @"mp4";//可选设置
                     content.fileName = @"myvideofile";//可选设置
                     
                     JMSGMessage *message = [self.conversation createMessageWithContent: content];
                     JMSGFileContent *fileContent = (JMSGFileContent *)message.content;
                     NSString *path = fileContent.originMediaLocalPath;
                     NSLog(@"视频上传mediaFilePath%@",path);
                     MessageModel *lastMessageModel = [self.allmessageArr firstObject];
                     BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
                     MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
                     messageModel.mediaFilePath = path;
                     [self.conversation sendMessage:message];
                     
                     [self.messageList appendMessageWith:messageModel];
                     [self.allmessageArr insertObject:messageModel atIndex:0];

                     [self removeFile:filePath];
                     
                 }
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
             }
         }];
    } else {
        // Fallback on earlier versions
    }
}

// - MARK: 完成 录制视频
- (void)finishRecordVideoWithVideoPath:(NSString * _Nonnull)videoPath durationTime:(double)durationTime {
    
}

- (void)keyBoardWillShowWithHeight:(CGFloat)height durationTime:(double)durationTime {
    
}

- (void)removeFile:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"本地文件移除成功")
    } else {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

#pragma mark - # 消息接收发送代理 JMSGMessageDelegate

/*!
 * @abstract 发送消息结果返回回调
 *
 * @param message 原发出的消息对象
 * @param error 不为nil表示发送消息出错
 *
 * @discussion 应检查 error 是否为空来判断是否出错. 如果未出错, 则成功.
 */
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error {
    if (error == nil) {
        MessageModel *lastMessageModel = [self.allmessageArr firstObject];
        BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
        MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
        [self.allmessageArr insertObject:messageModel atIndex:0];
        [_messageList updateMessageWith:messageModel];
    }
}

/*!
 * @abstract 接收消息(服务器端下发的)回调
 *
 * @param message 接收到下发的消息
 * @param error 不为 nil 表示接收消息出错
 *
 * @discussion 应检查 error 是否为空来判断有没有出错. 如果未出错, 则成功.
 * 留意的是, 这里的 error 不包含媒体消息下载文件错误. 这类错误有单独的回调 onReceiveMessageDownloadFailed:
 *
 * 收到的消息里, 也包含服务器端下发的各类事件, 比如有人被加入了群聊. 这类事件处理为特殊的 JMSGMessage 类型.
 *
 * 事件类的消息, 基于 JMSGMessage 类里的 contentType 属性来做判断,
 * contentType = kJMSGContentTypeEventNotification.
 */
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    if (error == nil) {
        MessageModel *lastMessageModel = [self.allmessageArr firstObject];
        BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
        MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
        [self.allmessageArr insertObject:messageModel atIndex:0];
        [_messageList appendMessageWith:messageModel];
    }
}

/*!
 * @abstract 接收消息媒体文件下载失败的回调
 *
 * @param message 下载出错的消息
 *
 * @discussion 因为对于接收消息, 最主要需要特别做处理的就是媒体文件下载, 所以单列出来. 一定要处理.
 *
 * 通过的作法是: 如果是图片, 则 App 展示一张特别的表明未下载成功的图, 用户点击再次发起下载. 如果是语音,
 * 则不必特别处理, 还是原来的图标展示. 用户点击时, SDK 发现语音文件在本地没有, 会再次发起下载.
 */
- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
    MessageModel *lastMessageModel = [self.allmessageArr firstObject];
    BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
    MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
    [self.allmessageArr insertObject:messageModel atIndex:0];
    [_messageList updateMessageWith:messageModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIImagePickerController Delegate
#pragma mark SendMessageDelegate

- (void)didStartRecordingVoiceAction {
    [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
    [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
    [self finishRecorded];
}

- (void)didDragOutsideAction {
    [self resumeRecord];
}

- (void)didDragInsideAction {
    [self pauseRecord];
}

- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
    @GBWeakObj(self);
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        @GBStrongObj(self);
        self.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
    NSLog(@"Action - startRecord");
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
    }];
}

- (void)finishRecorded {
    NSLog(@"Action - finishRecorded");
    @GBWeakObj(self);
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        @GBStrongObj(self);
        self.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        @GBStrongObj(self);
        [self SendMessageWithVoice:self.voiceRecordHelper.recordPath
                     voiceDuration:self.voiceRecordHelper.recordDuration];
    }];
}

#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
    
    if ([voiceDuration integerValue]<0.5 || [voiceDuration integerValue]>60) {
        if ([voiceDuration integerValue]<0.5) {
            NSLog(@"录音时长小于 0.5s");
        } else {
            NSLog(@"录音时长大于 60s");
        }
        return;
    }
    
    NSData *voiceData = [NSData dataWithContentsOfFile:voicePath];
    JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:voiceData voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
    
    if (voiceContent != nil) {
        JMSGMessage *message = [_conversation createMessageWithContent:voiceContent];
        MessageModel *lastMessageModel = [self.allmessageArr firstObject];
        BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
        MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
        [self.allmessageArr insertObject:messageModel atIndex:0];
        [_conversation sendMessage:message];
        [_messageList appendMessageWith:messageModel];
    }
    
    [self removeFile:voicePath];
}

#pragma mark --按下功能响应
- (void)pressMoreBtnClick:(UIButton *)btn {
    [self.imuiInputView.toolbar.textView resignFirstResponder];
    self.imuiInputView.toolbar.textView.inputView = self.shareMenuView;
    [self.imuiInputView.toolbar.textView becomeFirstResponder];
    [self layoutAndAnimateMessageInputTextView:self.imuiInputView.toolbar.textView];
}

- (void)noPressmoreBtnClick:(UIButton *)btn {
    // 关闭键盘
    [self.imuiInputView.toolbar.textView resignFirstResponder];
    
    self.imuiInputView.toolbar.textView.inputView = nil;
    // 打开键盘
    [self.imuiInputView.toolbar.textView becomeFirstResponder];
    [self layoutAndAnimateMessageInputTextView:self.imuiInputView.toolbar.textView];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//
//    //    self.isUserScrolling = YES;
//    UIMenuController *menu = [UIMenuController sharedMenuController];
//    if (menu.isMenuVisible) {
//        [menu setMenuVisible:NO animated:YES];
//    }
//    self.textViewInputViewType = XHInputViewTypeEmotion;
//    [self layoutOtherMenuViewHiden:YES];
//
//
//    //    if (self.textViewInputViewType != XHInputViewTypeNormal && self.textViewInputViewType != XHInputViewTypeText) {
//    //        [self layoutOtherMenuViewHiden:YES];
//    //    }
//}

- (void)pressFaceButtonClick:(UIButton *)faceButton {
    
    //        self.textViewInputViewType = XHInputViewTypeEmotion;
    //        [self layoutOtherMenuViewHiden:NO];
    
    [self.imuiInputView.toolbar.textView resignFirstResponder];
    self.imuiInputView.toolbar.textView.inputView = self.emotionManagerView;
    [self.imuiInputView.toolbar.textView becomeFirstResponder];
    [self layoutAndAnimateMessageInputTextView:self.imuiInputView.toolbar.textView];
}

- (void)noPressFaceButtonClick:(UIButton *)faceButton {
    
    // 关闭键盘
    [self.imuiInputView.toolbar.textView resignFirstResponder];
    
    self.imuiInputView.toolbar.textView.inputView = nil;
    // 打开键盘
    [self.imuiInputView.toolbar.textView becomeFirstResponder];
    [self layoutAndAnimateMessageInputTextView:self.imuiInputView.toolbar.textView];
    
    //    self.textViewInputViewType = XHInputViewTypeEmotion;
    //    [self layoutOtherMenuViewHiden:YES];
}

- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        @GBWeakObj(self);
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            @GBStrongObj(self);
            NSLog(@"已经达到最大限制时间了，进入下一步的提示");
            [self finishRecorded];
        };
        
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            @GBStrongObj(self);
            self.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
    }
    return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}

#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

/**
 *  点击第三方功能回调方法
 *
 *  @param shareMenuItem 被点击的第三方Model对象，可以在这里做一些特殊的定制
 *  @param index         被点击的位置
 */
- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            XKSelPhotos *imageManager = [XKSelPhotos selPhotos];
            [imageManager pushImagePickerControllerWithImagesCount:9 WithColumnNumber:3 didFinish:^(TZImagePickerController *imagePickerVc) {
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    for (UIImage *image in photos) {
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                        JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:imageData];
                        JMSGMessage *message = [self.conversation createMessageWithContent:imageContent];
                        MessageModel *lastMessageModel = [self.allmessageArr firstObject];
                        BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
                        MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
                        [self.allmessageArr insertObject:messageModel atIndex:0];
                        [self.conversation sendMessage:message];
                        [self.messageList appendMessageWith:messageModel];
                    }
                }];
                
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }];
        }
            break;
        case 1:
        {
            // 自定视频拍摄
            [self startRecordVideo];
        }
            break;
        default:
            break;
    }
}

- (XHShareMenuView *)shareMenuView {
    if (!_shareMenuView) {
        XHShareMenuView *shareMenuView = [[XHShareMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 216, CGRectGetWidth(self.view.bounds), 216)];
        shareMenuView.delegate = self;
        shareMenuView.backgroundColor = [UIColor kFunctionBackgroundColor];
        shareMenuView.alpha = 1;
        shareMenuView.shareMenuItems = self.shareMenuItems;
        _shareMenuView = shareMenuView;
    }
    return _shareMenuView;
}

- (XHEmotionManagerView *)emotionManagerView {
    if (!_emotionManagerView) {
        XHEmotionManagerView *emotionManagerView = [[XHEmotionManagerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-self.keyboardViewHeight, SCREEN_WIDTH, self.keyboardViewHeight)];
        emotionManagerView.delegate = self;
        emotionManagerView.dataSource = self;
        emotionManagerView.alpha = 1.0;
        _emotionManagerView = emotionManagerView;
    }
    return _emotionManagerView;
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}
/**
 *  第三方gif表情被点击的回调事件
 *
 *  @param emotion   被点击的gif表情Model
 *  @param indexPath 被点击的位置
 */
- (void)didSelecteEmotion:(XHEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath {
    UITextView *textView = self.imuiInputView.toolbar.textView;
    NSString *newStr;
    if (indexPath.row == 20||indexPath.row==41||indexPath.row==62||indexPath.row==83) {
        if (textView.text.length>1) {
            if ([self.facesAry containsObject:[textView.text substringFromIndex:textView.text.length-2]]) {
                newStr=[textView.text substringToIndex:textView.text.length-2];
            }else{
                newStr=[textView.text substringToIndex:textView.text.length-1];
            }
            textView.text=newStr;
        }else{
            newStr = @"";
            textView.text = newStr;
        }
        
    }else{
        
        NSRange range=[textView selectedRange];
        NSMutableString* str=[[NSMutableString alloc] initWithString:textView.text];
        [str deleteCharactersInRange:range];
        [str insertString:emotion.emotionStr atIndex:range.location];
        textView.text=[DSEmotionUtils emojiStringFromString:str];
        textView.selectedRange=NSMakeRange(range.location+emotion.emotionStr.length, 0);
    }
    
}

- (void)didClickEmotionSectionBarSend {
    if (!ValidStr(self.imuiInputView.toolbar.textView.text)) {
        return;
    }
    
    JMSGTextContent *content = [[JMSGTextContent alloc] initWithText:self.imuiInputView.toolbar.textView.text];
    JMSGMessage *message = [_conversation createMessageWithContent:content];
    MessageModel *lastMessageModel = [self.allmessageArr firstObject];
    BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
    MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
    [self.allmessageArr insertObject:messageModel atIndex:0];
    [_conversation sendMessage:message];
    [_messageList appendMessageWith: messageModel];
    
    self.imuiInputView.toolbar.textView.text = @"";
}

// 键盘发送按钮 - 发送消息
- (void)sendText:(NSString *)text {
    JMSGTextContent *content = [[JMSGTextContent alloc] initWithText:text];
    JMSGMessage *message = [_conversation createMessageWithContent:content];
    MessageModel *lastMessageModel = [self.allmessageArr firstObject];
    BOOL isNeedShowTime = [self dataMessageShowTime:message.timestamp lastTime:[NSNumber numberWithFloat:lastMessageModel.duration]];
    MessageModel *messageModel = [[MessageModel alloc] initWithMessage:message targetAvatar:self.targetAvatar isNeedShowTime:isNeedShowTime];
    [_conversation sendMessage:message];
    [_messageList appendMessageWith: messageModel];
    [self.allmessageArr insertObject:messageModel atIndex:0];
}

#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

//计算input textfield 的高度
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    CGFloat maxHeight = [JCHATToolBar maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < _previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (_previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - _previousTextViewContentHeight);
    }
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             
                             [self scrollToBottomAnimated:NO];
                             
                             [self.imuiInputView.toolbar adjustTextViewHeightBy:changeInHeight];
                             
                         }
                         completion:^(BOOL finished) {
                         }];
        JCHATMessageTextView *textview =_imuiInputView.toolbar.textView;
        CGSize textSize = [DCSpeedy dc_calculateTextSizeWithText:textview.text WithTextFont:Fit_Font(17) WithMaxW:textview.frame.size.width];
        CGFloat textHeight = textSize.height > maxHeight?maxHeight:textSize.height;
        _toolBarHeightConstrait.constant = (textHeight + 16) < 56 ? 56 : (textHeight + 16);
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (self.barBottomFlag) {
        return;
    }
    if (object == self.imuiInputView.toolbar.textView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

#pragma mark --返回下面的位置
- (void)dropToolBar {
    _barBottomFlag =YES;
    _previousTextViewContentHeight = 31;
    _imuiInputView.toolbar.addButton.selected = NO;
    [_messageList.messageCollectionView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        self.toolBarToBottomConstrait.constant = 0;
    }];
}

- (void)dropToolBarNoAnimate {
    _barBottomFlag =YES;
    _previousTextViewContentHeight = 31;
    _imuiInputView.toolbar.addButton.selected = NO;
    [_messageList.messageCollectionView reloadData];
    _toolBarToBottomConstrait.constant = 0;
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger rows = [self.messageList.messageCollectionView numberOfItemsInSection:0];
    if (rows > 0) {
        [self.messageList.messageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
    }
}

#pragma mark - XHMessageInputView Delegate
- (void)pressVoiceBtnToHideKeyBoard {
    [self scrollToBottomAnimated:NO];
}

- (void)inputTextViewWillBeginEditing:(JCHATMessageTextView *)messageInputTextView {
    _textViewInputViewType = XHInputViewTypeText;
    [self scrollToBottomAnimated:NO];
}

- (void)inputTextViewDidBeginEditing:(JCHATMessageTextView *)messageInputTextView {
    if (!_previousTextViewContentHeight)
        _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)inputTextViewDidEndEditing:(JCHATMessageTextView *)messageInputTextView;
{
    if (!_previousTextViewContentHeight)
        _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}


- (NSMutableArray *)allmessageArr {
    if (!_allmessageArr) {
        _allmessageArr = [[NSMutableArray alloc] init];
    }
    
    return _allmessageArr;
}

@end
