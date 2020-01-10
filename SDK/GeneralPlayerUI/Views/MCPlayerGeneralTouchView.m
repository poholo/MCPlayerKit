//
// Created by majiancheng on 2018/12/29.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "MCPlayerGeneralTouchView.h"

#import <MediaPlayer/MediaPlayer.h>
#import <MCStyle/MCStyle.h>

#import "MCPlayerKitDef.h"
#import "MCMediaNotify.h"
#import "NSNumber+MCExtend.h"

NSString *const kMCTouchTapAction = @"kMCTouchTapAction";
NSString *const kMCTouchBegin = @"kMCTouchBegin";
NSString *const kMCTouchSeekAction = @"kMCTouchSeekAction";
NSString *const kMCTouchCurrentTimeAction = @"kMCTouchCurrentTimeAction";
NSString *const kMCTouchDurationAction = @"kMCTouchDurationAction";

@interface MCPlayerGeneralTouchView () <UIGestureRecognizerDelegate> {
    CGPoint _panOrigin;
    NSTimeInterval _timeSliding;

    BOOL _ischangingVolume;        ///< 正在改变音量
    BOOL _isChangingBright;        ///< 正在调节亮度
    BOOL _isWillSeeking;           ///< 正在seek
    BOOL _isWait2Seek;
}

@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property(nonatomic, assign) CGPoint beginPoint;

@end

@implementation MCPlayerGeneralTouchView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addGestureRecognizer:self.tapGestureRecognizer];
    [self addGestureRecognizer:self.panGestureRecognizer];
}

- (void)tapClick {
    MCLog(@"[MCTouchView]tap");
    if (self.callBack) {
        self.callBack(kMCTouchTapAction, nil);
    }
}

- (void)pan:(UIPanGestureRecognizer *)panGesture {
    if (self.unableSeek) return;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (self.callBack) {
                self.callBack(kMCTouchBegin, nil);
            }

            _panOrigin = [panGesture locationInView:self];
            if (self.callBack) {
                _timeSliding = [self.callBack(kMCTouchCurrentTimeAction, nil) doubleValue];
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (panGesture.numberOfTouches != 1) {
                // pinch 时 单指不动 另一指移动 也可能触发
                return;
            }
            //矢量  带有方向 速度
            CGPoint velocityPoint = [panGesture velocityInView:self];
            //相对于起始位置计算移动距离 (当转换方向,但是位置未跨越起始位置,正负值 没有变化)
            //        CGPoint panDiffPoint = [panGestureRecognizer translationInView:self.view];
            //重新设置 视频相关属性
            [self resetPlayerAttributeSettingWithPanTransPoint:velocityPoint];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (self.callBack) {
                self.callBack(kMCTouchSeekAction, @(_timeSliding));
            }
            _isWillSeeking = NO;
            _isChangingBright = NO;
            _ischangingVolume = NO;
            [MCMediaNotify dismiss];

        }
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        default:;
            break;
    }
}


#pragma mark  调节  进度 亮度 声音设置

- (void)resetPlayerAttributeSettingWithPanTransPoint:(CGPoint)panTransPoint {
    //滑动轨迹与水平线夹角在正负45度，都认为是水平滑动，超过45度，就认为是垂直滚动。
    //fabs计算|x|, 当x不为负时返回x，否则返回-x
    if ((fabs(panTransPoint.y) / fabs(panTransPoint.x)) <= 1) {
        if (fabs(panTransPoint.x) < _kMC_AV_offsetChoseDirection) {
            return;
        }
        // 判断角度     tan(45),这里需要通过正负来判断手势方向
        //进度
        [self resetVideorogressWithPanTransPoint:panTransPoint];
    } else {
        if (fabs(panTransPoint.y) < _kMC_AV_offsetChoseDirection) {
            return;
        }
        //缓存列表直接打开横屏 获取宽度正常 / 竖屏下获取宽度正常 ; 竖屏切换到横屏 获取宽度异常
        float middleX = CGRectGetMidX(self.frame);
        if (_panOrigin.x < middleX) {
            //亮度
            [self resetBrightnessWithPanTransPoint:panTransPoint];
        } else {
            //声音
            [self resetVolumeWithPanTransPoint:panTransPoint];
        }

    }
}

// 调节亮度
- (void)resetBrightnessWithPanTransPoint:(CGPoint)panTransPoint {
    if (_isWillSeeking || _ischangingVolume) {
        return;
    }
    float brightness = 0;
    if (panTransPoint.y < 0) {
        //上
        brightness = MIN(1., [UIScreen mainScreen].brightness - 0.0001 * panTransPoint.y);
    } else {
        //下
        brightness = MAX(0, [UIScreen mainScreen].brightness - 0.0001 * panTransPoint.y);
    }
    [UIScreen mainScreen].brightness = brightness;
    [MCMediaNotify showImage:[MCStyle customImage:@"player_control_0"] message:[NSString stringWithFormat:@"%.f%%", brightness * 100] mediaNotifyType:MCMediaBrightness inView:self];
    _isChangingBright = YES;
}

//调整进度
- (void)resetVideorogressWithPanTransPoint:(CGPoint)panTransPoint {
    if (!self.callBack) return;
    NSTimeInterval duration = [self.callBack(kMCTouchDurationAction, nil) doubleValue];
    if (_isChangingBright || _ischangingVolume || duration <= 0.0) {
        return;
    }

    _timeSliding += 0.01 * panTransPoint.x;
    if (panTransPoint.x < 0) {
        //后退
        _timeSliding = MAX(_timeSliding, 0);
        [MCMediaNotify showImage:[MCStyle customImage:@"player_control_2"] message:[NSString stringWithFormat:@"%@/%@", [@(_timeSliding) hhMMss], [@(duration) hhMMss]] mediaNotifyType:MCMediaProgress inView:self];
    } else {
        _timeSliding = MIN(_timeSliding, duration);//video_forward
        [MCMediaNotify showImage:[MCStyle customImage:@"player_control_1"] message:[NSString stringWithFormat:@"%@/%@", [@(_timeSliding) hhMMss], [@(duration) hhMMss]] mediaNotifyType:MCMediaProgress inView:self];
    }
    _isWillSeeking = YES;
}

//调控声音
- (void)resetVolumeWithPanTransPoint:(CGPoint)panTransPoint {
    if (_isChangingBright || _isWillSeeking) {
        return;
    }
    MPMusicPlayerController *mp = [MPMusicPlayerController applicationMusicPlayer];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (panTransPoint.y < 0) {
        //上
        mp.volume = MIN(1, mp.volume - 0.0001 * panTransPoint.y);
        //            [_videoPlayer setVolume:MIN(1, mp.volume - 0.001 * panTransPoint.y)];
    } else {
        //下
        mp.volume = MAX(0, mp.volume - 0.0001 * panTransPoint.y);
    }
#pragma clang diagnostic pop
    _ischangingVolume = YES;
}

#pragma mark - getter

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    }
    return _tapGestureRecognizer;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    }
    return _panGestureRecognizer;
}
@end