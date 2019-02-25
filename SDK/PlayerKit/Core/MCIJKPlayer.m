//
// Created by majiancheng on 16/8/10.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import "MCIJKPlayer.h"

#import <IJKMediaFramework/IJKFFMoviePlayerController.h>

#import "NSURL+MCExtend.h"
#import "MCPlayerKitDef.h"

@interface MCIJKPlayer ()

@property(nonatomic, strong) NSArray *playUrls;
@property(nonatomic, strong) IJKFFMoviePlayerController *ijkPlayer;
@property(nonatomic, assign) NSInteger currentPlayerIndex;

@property(nonatomic, assign) BOOL changeVoluming;
@property(nonatomic, assign) BOOL setVolumeSucess;
@property(nonatomic, assign) float volume;

- (IJKFFMoviePlayerController *)ijkplayer4URL:(NSURL *)URL isLiveOptions:(BOOL)isLiveOptions;

- (void)configureDefaultPlayer:(IJKFFMoviePlayerController *)player;

- (IJKFFOptions *)defaultOptions;

@end

@implementation MCIJKPlayer


- (void)dealloc {
    [self releaseSpace];
    MCLog(@"%@--%s--%d dealloc", [self class], __func__, __LINE__);
}

- (void)releaseSpace {
    [super releaseSpace];
}

- (instancetype)init {
    if (self = [super init]) {
#ifdef DEBUG
        [IJKFFMoviePlayerController setLogReport:YES];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
        [IJKFFMoviePlayerController setLogReport:NO];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
        [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
        _setVolumeSucess = YES;
    }
    return self;
}

- (void)playUrls:(nonnull NSArray<NSString *> *)urls {
    [self playUrls:urls isLiveOptions:NO];
}

- (void)playUrls:(NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions {
    self.startTime = CFAbsoluteTimeGetCurrent();
    self.playerState = MCPlayerStateLoading;
    [super playUrls:urls isLiveOptions:isLiveOptions];

    self.currentPlayerIndex = 0;
    self.playUrls = urls;
    self.ijkPlayer = [self ijkplayer4URL:[NSURL source4URI:self.playUrls.firstObject] isLiveOptions:isLiveOptions];


    [self installMovieNotificationObservers];
    [self preparePlay];
}

- (IJKFFOptions *)liveOptions {
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];

    //    [options setPlayerOptionIntValue:20 forKey:@"max-fps"];
    [options setPlayerOptionIntValue:8 forKey:@"framedrop"];
    [options setPlayerOptionIntValue:3 forKey:@"video-pictq-size"];
    [options setPlayerOptionIntValue:0 forKey:@"videotoolbox"];
    [options setPlayerOptionIntValue:960 forKey:@"videotoolbox-max-frame-width"];
    [options setPlayerOptionIntValue:8 * 1000 forKey:@"get-av-frame-timeout"];
    [options setPlayerOptionIntValue:1 forKey:@"start-on-prepared"];
    [options setPlayerOptionIntValue:1 forKey:@"waqu_live_stream"];

    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
    [options setFormatOptionIntValue:1 forKey:@"reconnect"];
    [options setFormatOptionIntValue:-1 forKey:@"timeout"];
    [options setFormatOptionIntValue:0 forKey:@"http-detect-range-support"];
    [options setFormatOptionIntValue:1000 forKey:@"analyzeduration"];
    [options setFormatOptionIntValue:4096 forKey:@"probesize"];

    [options setFormatOptionValue:@"wqliveijkplayer" forKey:@"user-agent"];

    [options setCodecOptionIntValue:0 forKey:@"skip_loop_filter"];

#if DEBUG
    options.showHudView = YES;
#else
    options.showHudView   = NO;
#endif

    return options;
}


- (IJKFFOptions *)defaultOptions {
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setOptionIntValue:1 forKey:@"framedrop" ofCategory:kIJKFFOptionCategoryPlayer];
//    [options setOptionIntValue:48 forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec]; 循环滤波
    [options setOptionIntValue:0 forKey:@"http-detect-range-support" ofCategory:kIJKFFOptionCategoryFormat];
    [options setOptionIntValue:0 forKey:@"start-on-prepared" ofCategory:kIJKFFOptionCategoryPlayer];
//    if (!self.notNeedSetProbesize) {
//        NSNumber *probesize = @(51200L);
//        [options setOptionIntValue:probesize.integerValue forKey:@"probesize" ofCategory:kIJKFFOptionCategoryFormat];
//        [options setOptionIntValue:probesize.integerValue forKey:@"max-buffer-size" ofCategory:kIJKFFOptionCategoryPlayer];
//    }
//    [options setPlayerOptionIntValue:YES forKey:@"videotoolbox"];
#if DEBUG
    options.showHudView = NO;
#else
    options.showHudView = NO;
#endif
    return options;
}

- (void)preparePlay {
    [super preparePlay];
    self.playerState = MCPlayerStateLoading;
    [self.ijkPlayer prepareToPlay];
}

- (void)play {
    [super play];
    [self.ijkPlayer play];
}

- (void)pause {
    [super pause];
    [self.ijkPlayer pause];
}

- (BOOL)isPlaying {
    return self.ijkPlayer.isPlaying;
}

- (void)seekSeconds:(CGFloat)seconds {
    [self.ijkPlayer setCurrentPlaybackTime:seconds];
}

- (void)playRate:(CGFloat)playRate {
    [self.ijkPlayer setPlaybackRate:playRate];
}

- (CGFloat)rate {
    return self.ijkPlayer.playbackRate;
}

- (void)cancelLoading {
    [self.ijkPlayer didShutdown];
}

- (void)destory {
    if (self.ijkPlayer) {
        [super destory];
        [self removeMovieNotificationObservers];
        self.playUrls = nil;

        [self.ijkPlayer pause];
        [self.ijkPlayer.view removeFromSuperview];
        [self.ijkPlayer shutdown];
        self.ijkPlayer = nil;
    }
    [super destory];
}

- (NSTimeInterval)currentTime {
    return [self.ijkPlayer currentPlaybackTime];
}

- (NSTimeInterval)duration {
    return [self.ijkPlayer duration];
}

- (UIView *)playerView {
    return self.ijkPlayer.view;
}

- (MCPlayerCoreType)playerType {
    return MCPlayerCoreIJKPlayer;
}

- (void)changeAudioVolume:(CGFloat)volume {
    _changeVoluming = YES;
    _volume = volume;
    MCLog(@"~~~volume %s _setVolumeSucess = %d", __func__, _setVolumeSucess);
}

- (CGSize)naturalSize {
    return [_ijkPlayer naturalSize];
}

#pragma mark - getter setter

- (CGFloat)cacheProgress {
    if (self.ijkPlayer.duration <= 0.0) {
        return 1.0f;
    }

    return (CGFloat) (self.ijkPlayer.playableDuration / self.ijkPlayer.duration);
}

#pragma mark - private

- (IJKFFMoviePlayerController *)ijkplayer4URL:(NSURL *)URL isLiveOptions:(BOOL)isLiveOptions {
    IJKFFOptions *options = nil;
    if (isLiveOptions) {
        options = [self liveOptions];
    } else {
        options = [self defaultOptions];
    }

    IJKFFMoviePlayerController *ijkplayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:URL withOptions:options];
    [self configureDefaultPlayer:ijkplayer];
    return ijkplayer;
}

- (void)configureDefaultPlayer:(IJKFFMoviePlayerController *)player {
    player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    switch (self.playerLayerVideoGravity) {
        case MCPlayerLayerVideoGravityResizeAspect: {
            player.scalingMode = IJKMPMovieScalingModeAspectFit;
        }
            break;
        case MCPlayerLayerVideoGravityResizeAspectFill: {
            player.scalingMode = IJKMPMovieScalingModeAspectFill;
        }
            break;
        case MCPlayerLayerVideoGravityResize: {
            player.scalingMode = IJKMPMovieScalingModeFill;
        }
            break;
    }
    player.shouldAutoplay = YES;
    player.view.userInteractionEnabled = NO;
}


- (void)loadStateDidChange:(NSNotification *)notification {
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started

    if (self.ijkPlayer != notification.object) return;
    IJKMPMovieLoadState loadState = self.ijkPlayer.loadState;

    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        MCLog(@"%@:::::: loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", [self class], (int) loadState);
        self.playerState = MCPlayerStatePlaying;
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        MCLog(@"%@::::::loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", [self class], (int) loadState);
        self.playerState = MCPlayerStateBuffering;
    } else {
        MCLog(@"%@::::::loadStateDidChange: ???: %d\n", [self class], (int) loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    if (self.ijkPlayer != notification.object) return;
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];

    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            MCLog(@"%@::::::playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", [self class], reason);
            self.startTime = CFAbsoluteTimeGetCurrent();
            self.playerState = MCPlayerStatePlayEnd;
            break;

        case IJKMPMovieFinishReasonUserExited:
            MCLog(@"%@::::::playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", [self class], reason);
            self.playerState = MCPlayerStateError;
            break;

        case IJKMPMovieFinishReasonPlaybackError:
            MCLog(@"%@::::::playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", [self class], reason);
            self.playerState = MCPlayerStateError;
            break;

        default:
            MCLog(@"%@::::::playbackPlayBackDidFinish: ???: %d\n", [self class], reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification {
    if (self.ijkPlayer != notification.object) return;
    MCLog(@"%@::::::mediaIsPreparedToPlayDidChange\n", [self class]);
}

- (void)moviePlayBackStateDidChange:(NSNotification *)notification {
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    if (self.ijkPlayer != notification.object) return;

    switch (self.ijkPlayer.playbackState) {
        case IJKMPMoviePlaybackStateStopped: {
            self.playerState = MCPlayerStatePlayEnd;
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            MCLog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: playing", [self class], (int) self.ijkPlayer.playbackState);
//            self.playerState = MCPlayerStatePlaying;
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            MCLog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: paused", [self class], (int) self.ijkPlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            MCLog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: interrupted", [self class], (int) self.ijkPlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            MCLog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: seeking", [self class], (int) self.ijkPlayer.playbackState);
            break;
        }
        default: {
            MCLog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: unknown", [self class], (int) self.ijkPlayer.playbackState);
            break;
        }
    }
}

- (void)firstVideoFrameRenderedNotification:(NSNotification *)notification {
    if (notification.object != self.ijkPlayer)return;
    self.playerState = MCPlayerStateStarting;
    self.startEndTime = CFAbsoluteTimeGetCurrent();
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaIsPreparedToPlayDidChange:) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstVideoFrameRenderedNotification:) name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification object:self.ijkPlayer];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification object:self.ijkPlayer];
}


@end
