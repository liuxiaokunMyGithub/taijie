//
//  JMVideoBubbleContentView.m
//  JMessageOCDemo
//
//  Created by oshumini on 2017/11/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import "JMVideoBubbleContentView.h"
#import "MessageModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface JMVideoBubbleContentView ()
@property(strong, nonatomic)UIImageView *videoView;
@property(strong, nonatomic)UIButton *playBtn;
@property(strong, nonatomic)UILabel *videoDuration;
@property(weak, nonatomic)MessageModel *messageModel;

@property(assign, nonatomic)BOOL isMediaActivity;
@end

@implementation JMVideoBubbleContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _videoView = [UIImageView new];
        _videoView.contentMode = UIViewContentModeScaleAspectFill;
        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        
        NSString *imgPath = [NSBundle.mainBundle pathForResource:@"IMUIAssets.bundle/image/video_play_btn" ofType:@"png"];
        [_playBtn setImage:[UIImage imageWithContentsOfFile:imgPath] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        _videoDuration = [UILabel new];
        [self addSubview: _videoView];
        [self addSubview: _playBtn];
        [self addSubview: _videoDuration];
        
        _isMediaActivity = NO;
    }
    return self;
}

- (void)layoutContentViewWithMessage:(id <IMUIMessageModelProtocol> _Nonnull)message {
    MessageModel *messageModel = (MessageModel *)message;
    _messageModel = (MessageModel *)message;
    
    _videoView.frame = CGRectMake(0, 0, messageModel.layout.bubbleContentSize.width, messageModel.layout.bubbleContentSize.height);
    _playBtn.center = CGPointMake(_videoView.frame.size.width/2, _videoView.frame.size.height/2);
//    CGFloat durationX = _videoView.frame.size.width - 30;
    JMSGVideoContent *content = (JMSGVideoContent *)messageModel.message.content;

    CGFloat durationY = _videoView.frame.size.height - 24;
    _videoDuration.frame = CGRectMake(GBMargin/2, durationY, _videoView.frame.size.width - GBMargin, 24);
    if (ValidNum(content.duration)) {
        _videoDuration.text =  [NSString formatWithTime:[content.duration floatValue]];
    }
    _videoDuration.font = Fit_Font(10);
    _videoDuration.textColor = [UIColor whiteColor];
    _videoDuration.textAlignment = NSTextAlignmentRight;
    if (ValidStr(_messageModel.mediaFilePath)) {
        [self updateVideoShoot:_messageModel.mediaFilePath];
    }else {
        [content videoThumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
            self.videoView.image = [UIImage imageWithData:data];
        }];
    }
}

- (void)updateVideoShoot:(NSString *)videoPath {
    dispatch_queue_t serialQueue = dispatch_queue_create("videoLoad", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath ?: @""] options:nil];
        
        // get video shoot
        AVAssetImageGenerator *imgGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        NSError *error = nil;
        imgGenerator.appliesPreferredTrackTransform = YES;
        CGImageRef cgImg = [imgGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error: &error];
        if (!error) {
            UIImage *img = [UIImage imageWithCGImage:cgImg];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.videoView.image = img;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.videoView.image = nil;
            });
        }
    });
}

- (void)playVideo {
    if (ValidStr(_messageModel.mediaFilePath)) {
        [self play];
    }else {
        JMSGVideoContent *content = (JMSGVideoContent *)_messageModel.message.content;
        [content videoDataWithProgress:nil completionHandler:^(NSData *data, NSString *objectId, NSError *error) {
            self.messageModel.mediaFilePath = content.originMediaLocalPath;
            
            [self play];
        }];
    }
}

- (void)play {
    NSError *error = nil;
    NSString *copyPath = [NSString stringWithFormat:@"%@",_messageModel.mediaFilePath];
    [NSFileManager.defaultManager copyItemAtPath:_messageModel.mediaFilePath toPath:copyPath error:&error];
    NSLog(@"视频播放mediaFilePath%@",copyPath);
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:copyPath]];
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
    playerVC.player = player;
    
    [GBRootViewController presentViewController:playerVC animated:YES completion:^{
        [player play];
    }];
}

@end
