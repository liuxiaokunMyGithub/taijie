//
//  JMVoiceBubbleContentView.m
//  JMessageOCDemo
//
//  Created by oshumini on 2017/6/14.
//  Copyright © 2017年 HXHG. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JMVoiceBubbleContentView.h"
#import "MessageModel.h"
#import "GBTaiJie-Swift.h"
#import "JCHATAudioPlayerHelper.h"

@interface JMVoiceBubbleContentView ()
@property(strong, nonatomic)UIImageView *voiceImg;
@property(strong, nonatomic)UILabel *voiceTimeLabel;

@property(weak, nonatomic)MessageModel *messageModel;
@property(assign, nonatomic)BOOL isMediaActivity;
@property(assign, nonatomic)NSInteger index;//voice 语音图片的当前显示
@property(assign, nonatomic)BOOL continuePlayer;

@end

@implementation JMVoiceBubbleContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _voiceImg = [UIImageView new];
        [self addSubview: _voiceImg];
        _isMediaActivity = NO;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapVoiceContents)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tapGesture];
        _voiceTimeLabel = [[UILabel alloc] init];
        _voiceTimeLabel.font = Fit_Font(12);
        [self addSubview:_voiceTimeLabel];
    }
    return self;
}

- (void)layoutContentViewWithMessage:(id <IMUIMessageModelProtocol> _Nonnull)message {
    _messageModel = (MessageModel *)message;
    JMSGVoiceContent *voiceMessage = (JMSGVoiceContent *)_messageModel.message.content;
    _voiceImg.frame = CGRectMake(0, 0, 12, 16);
    _voiceTimeLabel.text = [NSString stringWithFormat:@"%@''",voiceMessage.duration];
    if (message.isOutGoing) {
        _voiceImg.image = [UIImage imageNamed:@"outgoing_voice_3"];
        _voiceImg.center = CGPointMake(_messageModel.layout.bubbleContentSize.width - 20,
                                       _messageModel.layout.bubbleContentSize.height/2);
        _voiceTimeLabel.frame = CGRectMake(5, 0, self.width - 12, self.height);
        _voiceTimeLabel.textAlignment = NSTextAlignmentLeft;
        _voiceTimeLabel.textColor = [UIColor whiteColor];

    } else {
        _voiceImg.image = [UIImage imageNamed:@"incoming_voice_3"];
        _voiceImg.center = CGPointMake(20,
                                       _messageModel.layout.bubbleContentSize.height/2);
        _voiceTimeLabel.frame = CGRectMake(15, 0, self.width - 20, self.height);
        _voiceTimeLabel.textAlignment = NSTextAlignmentRight;
        _voiceTimeLabel.textColor = [UIColor kAssistInfoTextColor];
    }
}

#pragma mark --连续播放语音
//- (void)playVoice {
////    DDLogDebug(@"Action - playVoice");
//    __block NSString *status = nil;
//
//    self.continuePlayer = NO;
//    if ([(id<playVoiceDelegate>)(self.delegate) respondsToSelector:@selector(getContinuePlay:indexPath:)]) {
//        [(id<playVoiceDelegate>)(self.delegate) getContinuePlay:self indexPath:self.indexPath];
//    }
//    [self.readView setHidden:YES];
//
//    if (![_model.message.flag  isEqual: @1]) {
//        [_model.message updateFlag:@1];
//    }
//    @GBWeakObj(self);
//    [self.messageModel getMediaDataCallback:^(NSData *data, NSString *msgId) {
//    @GBStrongObj(self);
//            if (data != nil) {
//                status =  @"下载语音成功";
//                self.index = 0;
//
//                if (!self.isMediaActivity) {
//                    if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
//                        [[JCHATAudioPlayerHelper shareInstance] stopAudio];
//                        [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
//                    }
//                    [[JCHATAudioPlayerHelper shareInstance] setDelegate:(id) self];
//                    self.isMediaActivity = YES;
//                } else {
//                    self.isMediaActivity = NO;
////                    self.continuePlayer = NO;
//                    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
//                    [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
//                }
//                [[JCHATAudioPlayerHelper shareInstance] managerAudioWithData:data toplay:YES];
//                [self changeVoiceImage];
//            }
//    }];
//    return;
//}

- (void)onTapVoiceContents {
    @GBWeakObj(self);
    [self.messageModel getMediaDataCallback:^(NSData *data, NSString *msgId) {
        if (data) {
            self.index = 0;
            if (!self.isMediaActivity) {
                @GBStrongObj(self);
                self.isMediaActivity = YES;
                if ([self.messageModel.msgId isEqualToString:msgId]) {
                    [IMUIAudioPlayerHelper.sharedInstance playAudioWithData:@"" :data progressCallback:^(NSString * _Nonnull identify, NSTimeInterval currentTime, NSTimeInterval duration) {
                        
                    } finishCallBack:^(NSString * _Nonnull identify) {
                        @GBStrongObj(self);
                        self.isMediaActivity = NO;
                        self.index = 0;
                        if ([self.messageModel.message isReceived]) {
                            [self.voiceImg setImage:[UIImage imageNamed:@"incoming_voice_3"]];
                        } else {
                            [self.voiceImg setImage:[UIImage imageNamed:@"outgoing_voice_3"]];
                        }
                    } stopCallBack:^(NSString * _Nonnull identify) {
                        // self.isMediaActivity = NO;
                        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeVoiceImage) object:nil];
                        
                        self.index = 0;
                        if ([self.messageModel.message isReceived]) {
                            [self.voiceImg setImage:[UIImage imageNamed:@"incoming_voice_3"]];
                        } else {
                            [self.voiceImg setImage:[UIImage imageNamed:@"outgoing_voice_3"]];
                        }
                    }];
                }
            }else {
                [IMUIAudioPlayerHelper.sharedInstance stopAudio];
                //                _isMediaActivity = !_isMediaActivity;
                self.isMediaActivity = NO;
            }
            [self changeVoiceImage];
        }
    }];
    //    _isMediaActivity = !_isMediaActivity;
    return;
}

- (void)changeVoiceImage {
    if (!_isMediaActivity) {

        return;
    }
    
    __block NSString *voiceImagePreStr = @"";
    if ([_messageModel.message isReceived]) {
        voiceImagePreStr = @"incoming_voice_";
    } else {
        voiceImagePreStr = @"outgoing_voice_";
    }
    
    GB_MAIN_THREAD((^{
        self.voiceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%zd", voiceImagePreStr, self.index % 4]];
    }));
    if (_isMediaActivity) {
        self.index++;
        [self performSelector:@selector(changeVoiceImage) withObject:nil afterDelay:0.25];
    }
}

//- (void)prepare {
//    [(id<playVoiceDelegate>)self.delegate successionalPlayVoice:self indexPath:self.indexPath];
//}
//
//#pragma mark ---播放完成后
//- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
//    [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
//    _isMediaActivity = NO;
//    self.index = 0;
//    if ([self.messageModel.message isReceived]) {
//                                    [self.voiceImg setImage:[UIImage imageNamed:@"incoming_voice_3"]];
//                                } else {
//                                    [self.voiceImg setImage:[UIImage imageNamed:@"outgoing_voice_3"]];
//                                }
//    if (self.continuePlayer) {
//        self.continuePlayer = NO;
//        if ([self.delegate respondsToSelector:@selector(successionalPlayVoice:indexPath:)]) {
//            [self performSelector:@selector(prepare) withObject:nil afterDelay:0.5];
//        }
//    }
//}


@end
