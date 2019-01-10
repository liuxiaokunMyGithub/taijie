//
//  XHVoiceRecordHUD.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-13.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHVoiceRecordHUD.h"
#import "JChatConstants.h"
#define kXHVoiceRecordPauseString @"手指上滑，取消发送"
#define kXHVoiceRecordResaueString @"松开手指，取消发送"

@interface XHVoiceRecordHUD ()

@property (nonatomic, weak) UILabel *remindLabel;
@property (nonatomic, weak) UIImageView *gbmicroPhoneImageView;
@property (nonatomic, weak) UIImageView *cancelRecordImageView;
@property (nonatomic, weak) UIImageView *recordingHUDImageView;

/**
 *  逐渐消失自身
 *
 *  @param compled 消失完成的回调block
 */
- (void)dismissCompled:(void(^)(BOOL fnished))compled;

/**
 *  配置是否正在录音，需要隐藏和显示某些特殊的控件
 *
 *  @param recording 是否录音中
 */
- (void)configRecoding:(BOOL)recording;

/**
 *  根据语音输入的大小来配置需要显示的HUD图片
 *
 *  @param peakPower 输入音频的声音大小
 */
- (void)configRecordingHUDImageWithPeakPower:(CGFloat)peakPower;

/**
 *  配置默认参数
 */
- (void)setup;

@end

@implementation XHVoiceRecordHUD

- (void)startRecordingHUDAtView:(UIView *)view {
  CGPoint center = CGPointMake(CGRectGetWidth(view.frame) / 2.0, CGRectGetHeight(view.frame) / 2.0);
  self.center = center;
  [view addSubview:self];
  [self configRecoding:YES];
}

- (void)pauseRecord {
  [self configRecoding:YES];
  self.remindLabel.backgroundColor = [UIColor clearColor];
  self.remindLabel.text = kXHVoiceRecordPauseString;
//  self.backgroundColor = UIColorFromRGBA(0x3f80dd);
    self.remindLabel.backgroundColor = [UIColor clearColor];
    self.backgroundColor = UIColorFromRGBA(0x828282);
}

- (void)resaueRecord {
  [self configRecoding:NO];
  self.remindLabel.backgroundColor = [UIColor clearColor];
  self.remindLabel.text = kXHVoiceRecordResaueString;
//  [self setBackgroundColor:UIColorFromRGBA(0xf47e7e)];
    self.remindLabel.backgroundColor = UIColorFromRGBA(0x8B0F24);

    self.backgroundColor = UIColorFromRGBA(0x828282);
}

- (void)stopRecordCompled:(void(^)(BOOL fnished))compled {
  [self dismissCompled:compled];
}

- (void)cancelRecordCompled:(void(^)(BOOL fnished))compled {
  [self dismissCompled:compled];
}

- (void)dismissCompled:(void(^)(BOOL fnished))compled {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        compled(finished);
    }];
}

- (void)configRecoding:(BOOL)recording {
  self.gbmicroPhoneImageView.hidden = !recording;
  self.recordingHUDImageView.hidden = !recording;
  self.cancelRecordImageView.hidden = recording;
}

- (void)configRecordingHUDImageWithPeakPower:(CGFloat)peakPower {
  NSString *imageName = @"RecordingSignal00";
  if (peakPower <= 0.3) {
    imageName = [imageName stringByAppendingString:@"1"];
  } else if (peakPower > 0.3 && peakPower <= 0.4) {
    imageName = [imageName stringByAppendingString:@"2"];
  } else if (peakPower > 0.4 && peakPower <= 0.5) {
    imageName = [imageName stringByAppendingString:@"3"];
  } else if (peakPower > 0.5 && peakPower <= 0.6) {
    imageName = [imageName stringByAppendingString:@"4"];
  } else if (peakPower > 0.6 && peakPower <= 0.7) {
    imageName = [imageName stringByAppendingString:@"5"];
  } else if (peakPower > 0.7 && peakPower <= 0.8) {
    imageName = [imageName stringByAppendingString:@"6"];
  } else if (peakPower > 0.8 && peakPower <= 0.9) {
    imageName = [imageName stringByAppendingString:@"7"];
  } else if (peakPower > 0.9 && peakPower <= 1.0) {
    imageName = [imageName stringByAppendingString:@"8"];
  }
  self.recordingHUDImageView.image = [UIImage imageNamed:imageName];
}

- (void)setPeakPower:(CGFloat)peakPower {
  _peakPower = peakPower;
  [self configRecordingHUDImageWithPeakPower:peakPower];
}

- (void)setup {
//  self.backgroundColor = UIColorFromRGBA(0x3f80dd);
    self.backgroundColor = UIColorFromRGBA(0x828282);
  self.layer.masksToBounds = YES;
  self.layer.cornerRadius = 10;
  if (!_remindLabel) {
    UILabel *remindLabel= [[UILabel alloc] initWithFrame:CGRectMake(8.0, 105.0, 125.0, 22.0)];
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.font = [UIFont systemFontOfSize:13];
//    remindLabel.layer.masksToBounds = YES;
//    remindLabel.layer.cornerRadius = 4;
    remindLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    remindLabel.backgroundColor = [UIColor clearColor];
    remindLabel.text = kXHVoiceRecordPauseString;
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:remindLabel];
    _remindLabel = remindLabel;
  }
  
  if (!_gbmicroPhoneImageView) {
    UIImageView *microPhoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27.0, 10, 50.0, 105.0)];
    microPhoneImageView.image = [UIImage imageNamed:@"icon_voice2"];
    microPhoneImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    microPhoneImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:microPhoneImageView];
    _gbmicroPhoneImageView = microPhoneImageView;
  }
  
  if (!_recordingHUDImageView) {
    UIImageView *recordHUDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(82.0, 25.0, 18.0, 68.0)];
    recordHUDImageView.image = [UIImage imageNamed:@"RecordingSignal001"];
    recordHUDImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    recordHUDImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:recordHUDImageView];
      
    _recordingHUDImageView = recordHUDImageView;
  }
  
  if (!_cancelRecordImageView) {
    UIImageView *cancelRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 15, 80.0, 80.0)];
    cancelRecordImageView.image = [UIImage imageNamed:@"icon_cancel"];
    cancelRecordImageView.hidden = YES;
    cancelRecordImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    cancelRecordImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:cancelRecordImageView];
      cancelRecordImageView.centerX = self.centerX;
    _cancelRecordImageView = cancelRecordImageView;
  }
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setup];
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
