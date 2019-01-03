//
// Created by imooc on 16/5/5.
// Copyright (c) 2016 mjc inc. All rights reserved.
//


#import "PlayerLoadingView.h"

#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MCStyle/MCStyleDef.h>

#import "MCPlayerViewConfig.h"
#import "HWWeakTimer.h"

@interface PlayerLoadingView ()

@property(nonatomic, strong) MBProgressHUD *progressHUD;

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) CGFloat progress;

@end

@implementation PlayerLoadingView

- (void)dealloc {
    [self releaseSpace];
    [self disposeTimer];
    [self disposeHUD];
}

- (void)disposeTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)disposeHUD {
    [_progressHUD hideAnimated:YES];
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;
}

- (NSTimer *)timer {
    if (_timer == nil) {

        __weak typeof(self) weakSelf = self;

        _timer = [HWWeakTimer scheduledTimerWithTimeInterval:.1 block:^(id userInfo) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.progress += .05f;
            if (strongSelf.progress >= 1.0f) {
                strongSelf.progress = 0.0f;
            }
            [strongSelf.progressHUD setProgress:self.progress];
        }                                           userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (void)releaseSpace {
    [_loadingImageView removeFromSuperview];
    _loadingImageView = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        _loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_k_AV_Loading_image]];
        _loadingImageView.contentMode = UIViewContentModeScaleAspectFill;

        [self addSubview:_loadingImageView];
        self.hidden = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)updateConstraints {
    [_loadingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _loadingImageView.frame = self.bounds;
}

- (void)startShowBg {
    if (self.hidden == NO) return;
    self.hidden = NO;
    _loadingImageView.hidden = NO;

    [self startAnimationLoading];
}

/** loading有背景图 */
- (void)startRotatingAndDefaultBg {
    if (self.hidden == NO) return;
    self.hidden = NO;
    [self startAnimationLoading];
}

/** loading无背景图 */
- (void)startRotatingNoDefaultBg {
    if (self.hidden == NO) return;
    self.hidden = NO;
    _loadingImageView.hidden = YES;
    [self startAnimationLoading];
}

- (void)startAnimationLoading {
    [self.progressHUD showAnimated:YES];
    [self timer];
}

- (void)endRotating {
    if (self.hidden) return;
    self.hidden = YES;
    [self disposeTimer];
    [self disposeHUD];
}

- (void)updatePlayerPicture:(NSString *)url {
    [_loadingImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:_k_AV_Loading_image]];
}

- (void)hiddenRotateLoadingView:(BOOL)hiddenRotateLoadingView {
    _progressHUD.hidden = hiddenRotateLoadingView;
}

- (MBProgressHUD *)progressHUD {
    if (_progressHUD == nil) {
        _progressHUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _progressHUD.contentColor = [MCColor colorVII];
        _progressHUD.bezelView.color = [UIColor clearColor];
        _progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _progressHUD.backgroundView.color = [UIColor clearColor];
        _progressHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        _progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    }
    return _progressHUD;
}

@end


