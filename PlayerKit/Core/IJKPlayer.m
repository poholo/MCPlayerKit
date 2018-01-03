//
// Created by majiancheng on 16/8/10.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import "IJKPlayer.h"

@implementation IJKPlayer

@end

//#import <IJKMediaFramework/IJKFFMoviePlayerController.h>
//
//#import "UALogger.h"
//#import "AppCongfig.h"
//#import "NSURL+Extend.h"
//
//@interface IJKPlayer ()
//
//@property(nonatomic, strong) NSArray *playUrls;
//@property(nonatomic, strong) IJKFFMoviePlayerController *ijkPlayer;
//@property(nonatomic, assign) NSInteger currentPlayerIndex;
//
//@property(nonatomic, assign) BOOL changeVoluming;
//@property(nonatomic, assign) BOOL setVolumeSucess;
//@property(nonatomic, assign) float volume;
//@property(nonatomic, assign) BOOL isLiveOptions;;
//@property(nonatomic, assign) BOOL isFirstReplay;
//
//@property(nonatomic, assign) CFAbsoluteTime startTime;
//
//- (IJKFFMoviePlayerController *)ijkplayer4URL:(NSURL *)URL isLiveOptions:(BOOL)isLiveOptions;
//
//- (void)configureDefaultPlayer:(IJKFFMoviePlayerController *)player;
//
//- (IJKFFOptions *)defaultOptions;
//
//@end
//
//@implementation IJKPlayer
//
//- (void)dealloc {
//    [self releaseSpace];
//#if DEBUG
//    UALog(@"%@--%s--%zd dealloc", [self class], __func__, __LINE__);
//#endif
//}
//
//- (void)releaseSpace {
//    [super releaseSpace];
//    [self.ijkPlayer destorySensetimeStickerInstance];
//}
//
//- (instancetype)init {
//    if (self = [super init]) {
//#ifdef DEBUG
//        [IJKFFMoviePlayerController setLogReport:YES];
//        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
//#else
//        [IJKFFMoviePlayerController setLogReport:NO];
//        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
//#endif
//        [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
//        _setVolumeSucess = YES;
//    }
//    return self;
//}
//
//- (void)playUrls:(nonnull NSArray<NSString *> *)urls {
//    [self playUrls:urls isLiveOptions:NO];
//}
//
//- (void)playUrls:(NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions {
//    [super playUrls:urls isLiveOptions:isLiveOptions];
//
//    self.isLiveOptions = isLiveOptions;
//    self.currentPlayerIndex = 0;
//    self.playUrls = urls;
//    self.ijkPlayer = [self ijkplayer4URL:[NSURL source4URI:[self currentUrlStr:self.currentPlayerIndex]] isLiveOptions:isLiveOptions];
//
//
////    NSString * faceModel = [[NSBundle mainBundle] pathForResource:@"face_track_3.3.0" ofType:@"model"];
////    [IJKFFMoviePlayerController initSensetimeSDK:faceModel];
////
////    [self.ijkPlayer createSensetimeStickerInstance:[[NSBundle mainBundle] pathForResource:@"rabbiteating" ofType:@"zip"]];
//
//    [self installMovieNotificationObservers];
//    [self preparePlay];
//}
//
//- (IJKFFOptions *)liveOptions {
//    //IJKFFOptions *options = [IJKFFOptions optionsByDefault];
//    IJKFFOptions *options = [IJKFFOptions optionsByLive];
//
//    //    [options setPlayerOptionIntValue:20 forKey:@"max-fps"];
//    [options setPlayerOptionIntValue:8 forKey:@"framedrop"];
//    [options setPlayerOptionIntValue:3 forKey:@"video-pictq-size"];
//    [options setPlayerOptionIntValue:0 forKey:@"videotoolbox"];
//    [options setPlayerOptionIntValue:960 forKey:@"videotoolbox-max-frame-width"];
//    [options setPlayerOptionIntValue:8 * 1000 forKey:@"get-av-frame-timeout"];
//    [options setPlayerOptionIntValue:1 forKey:@"start-on-prepared"];
//    [options setPlayerOptionIntValue:1 forKey:@"waqu_live_stream"];
//
//    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
//    [options setFormatOptionIntValue:1 forKey:@"reconnect"];
//    [options setFormatOptionIntValue:-1 forKey:@"timeout"];
//    [options setFormatOptionIntValue:0 forKey:@"http-detect-range-support"];
//    [options setFormatOptionIntValue:1000 forKey:@"analyzeduration"];
//    [options setFormatOptionIntValue:4096 forKey:@"probesize"];
//
//    [options setFormatOptionValue:@"wqliveijkplayer" forKey:@"user-agent"];
//
//    [options setCodecOptionIntValue:0 forKey:@"skip_loop_filter"];
//
//#if DEBUG
//    options.showHudView = NO;
//#else
//    options.showHudView   = NO;
//#endif
//
//    return options;
//}
//
//
//- (void)preparePlay {
//    [super preparePlay];
//    [self.ijkPlayer prepareToPlay];
//    [self updatePlayerLayer];
//}
//
//- (void)play {
//    [super play];
//    [self.ijkPlayer play];
//}
//
//- (void)pause {
//    [super pause];
//    [self.ijkPlayer pause];
//}
//
//- (BOOL)isPlaying {
//    return self.ijkPlayer.isPlaying;
//}
//
//- (void)seekSeconds:(CGFloat)seconds {
//    [self.ijkPlayer setCurrentPlaybackTime:seconds];
//}
//
//
//- (void)playRate:(CGFloat)playRate {
//    [self.ijkPlayer setPlaybackRate:playRate];
//}
//
//- (CGFloat)rate {
//    return self.ijkPlayer.playbackRate;
//}
//
//- (void)cancelLoading {
//    [self.ijkPlayer didShutdown];
//}
//
//- (void)destory {
//    [super destory];
//    [self removeMovieNotificationObservers];
//    self.playUrls = nil;
//    if (self.ijkPlayer) {
//        [self.ijkPlayer pause];
//        [self.ijkPlayer.view removeFromSuperview];
//        [self.ijkPlayer shutdown];
//        self.ijkPlayer = nil;
//    }
//}
//
//- (NSTimeInterval)currentTime {
//    return [self.ijkPlayer currentPlaybackTime];
//}
//
//- (NSTimeInterval)duration {
//    return [self.ijkPlayer duration];
//}
//
//+ (int)initSensetimeSDK:(NSString *)faceModelPath {
//    return [IJKFFMoviePlayerController initSensetimeSDK:faceModelPath];
//}
//
//+ (void)destorySensetimeSDK {
//    [IJKFFMoviePlayerController destorySensetimeSDK];
//}
//
//- (int)createSensetimeStickerInstance:(NSString *)stickerZipPath {
//    return [_ijkPlayer createSensetimeStickerInstance:stickerZipPath];
//}
//
//- (int)changeSensetimeStickerPackage:(NSString *)stickerZipPath {
//    return [_ijkPlayer changeSensetimeStickerPackage:stickerZipPath];
//}
//
//- (void)destorySensetimeStickerInstance {
//    [_ijkPlayer destorySensetimeStickerInstance];
//}
//
//- (uint64_t)addSticker:(NSString *)stickerFilePath startTime:(uint64_t)startTime endTime:(uint64_t)endTime centerX:(float)centerX centerY:(float)centerY scaleX:(float)scaleX scaleY:(float)scaleY angle:(int)angle {
//    return [_ijkPlayer addSticker:stickerFilePath startTime:startTime endTime:endTime centerX:centerX centerY:centerY scaleX:scaleX scaleY:scaleY angle:angle];
//}
//
//- (uint64_t)addCaption:(unsigned char *)buffer startTime:(uint64_t)startTime endTime:(uint64_t)endTime width:(int)width height:(int)height centerX:(float)centerX centerY:(float)centerY scaleX:(float)scaleX scaleY:(float)scaleY angle:(int)angle {
//    return [_ijkPlayer addCaption:buffer startTime:startTime endTime:endTime width:width height:height centerX:centerX centerY:centerY scaleX:scaleX scaleY:scaleY angle:angle];
//}
//
//- (bool)updateStickerObject:(uint64_t)objId objType:(int)objType startTime:(int64_t)startTime endTime:(int64_t)endTime width:(int)width height:(int)height centerX:(float)centerX centerY:(float)centerY scaleX:(float)scaleX scaleY:(float)scaleY angle:(int)angle {
//    return [_ijkPlayer updateStickerObject:objId objType:objType startTime:startTime endTime:endTime width:width height:height centerX:centerX centerY:centerY scaleX:scaleX scaleY:scaleY angle:angle];
//}
//
//- (int)deleteStickerObject:(uint64_t)objId objType:(int)objType {
//    return [_ijkPlayer deleteStickerObject:objId objType:objType];
//}
//
//- (int)enableStickerObject:(uint64_t)objId objType:(int)objType enable:(bool)enable {
//    return [_ijkPlayer enableStickerObject:objId objType:objType enable:enable];
//}
//
//- (int)initRecord:(NSString *)fileName {
//    return [_ijkPlayer initRecord:fileName];
//}
//
//- (int)initRecordEX:(NSString *)fileName width:(int)width height:(int)height videoBitrate:(int)videoBitrate {
//    return [_ijkPlayer initRecordEX:fileName width:width height:height videoBitrate:videoBitrate];
//}
//
//- (int)setBackgroundMusicInsertTime:(long)insertTime {
//    return [_ijkPlayer setBackgroundMusicInsertTime:insertTime];
//}
//
//- (long)setBackgroundMusicPath:(NSString *)musicPath {
//    return [_ijkPlayer setBackgroundMusicPath:musicPath];
//}
//
//- (BOOL)setBackgroundMusicRegion:(uint64_t)startTime endTime:(uint64_t)endTime {
//    return [_ijkPlayer setBackgroundMusicRegion:startTime endTime:endTime];
//}
//
//- (BOOL)setOutputAudioVolume:(int)trackIdx volume:(float)volume {
//    return [_ijkPlayer setOutputAudioVolume:trackIdx volume:volume];
//}
//
//+ (long)executeFfmpegCmd:(int)argc paramArray:(char **)argv {
//    return [IJKFFMoviePlayerController executeFfmpegCmd:argc paramArray:argv];
//}
//
//- (BOOL)startRecord:(NSTimeInterval)startTime filePath:(NSString *)filePath type:(RecordType)type {
//    [super startRecord:startTime filePath:filePath type:type];
//    NSInteger ret = [self.ijkPlayer initRecord:filePath];
//    if (ret > 0) {
//        [self.ijkPlayer startRecord:type];
//    }
//    return ret > 0;
//
//}
//
//- (void)endRecord:(NSTimeInterval)endTime {
//    [super endRecord:endTime];
//    [self.ijkPlayer stopRecord];
//}
//
//- (UIView *)playerView {
//    return self.ijkPlayer.view;
//}
//
//- (PlayerCoreType)playerType {
//    return PlayerCoreIJKPlayer;
//}
//
//- (NSInteger)currentPlayerItemIndex {
//    return self.currentPlayerIndex;
//}
//
//- (BOOL)hasNextVideoItem {
//    NSInteger currentItemIndex = self.currentPlayerIndex + 1;
//    if (NSNotFound == currentItemIndex || currentItemIndex >= self.playUrls.count) {
//        return NO;
//    } else if (currentItemIndex <= self.playUrls.count - 1) {
//        return YES;
//    }
//    return NO;
//}
//
//- (void)playNextVideoItem {
//    [self destory];
//    self.currentPlayerIndex++;
//    self.ijkPlayer = [self ijkplayer4URL:[NSURL source4URI:[self currentUrlStr:self.currentPlayerIndex]] isLiveOptions:_isLiveOptions];
//    [self installMovieNotificationObservers];
//    [self preparePlay];
//}
//
//- (NSString *)currentUrlStr:(NSInteger)index {
//    if (self.currentPlayerIndex < self.playUrls.count) {
//        return self.playUrls[self.currentPlayerIndex];
//    }
//    return @"";
//}
//
//- (void)changeAudioVolume:(CGFloat)volume {
//    _changeVoluming = YES;
//    _setVolumeSucess = [self.ijkPlayer setPlaybackAudioVolume:volume];
//    _volume = volume;
//    UALog(@"~~~volume %s _setVolumeSucess = %d", __func__, _setVolumeSucess);
//}
//
//- (CGSize)naturalSize {
//    return [_ijkPlayer naturalSize];
//}
//
//#pragma mark - getter setter
//
//- (void)setPlayerState:(PlayerState)playerState {
//    [self changePlayerState:playerState];
//}
//
//- (CGFloat)cacheProgress {
//    if (self.ijkPlayer.duration <= 0.0) {
//        return 1.0f;
//    }
//
//    return (CGFloat) (self.ijkPlayer.playableDuration / self.ijkPlayer.duration);
//}
//
//#pragma mark - private
//
//- (IJKFFMoviePlayerController *)ijkplayer4URL:(NSURL *)URL isLiveOptions:(BOOL)isLiveOptions {
//    IJKFFOptions *options = nil;
//    if (isLiveOptions) {
//        options = [self liveOptions];
//    } else {
//        options = [self defaultOptions];
//    }
//
//    IJKFFMoviePlayerController *ijkplayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:URL withOptions:options];
//    [self configureDefaultPlayer:ijkplayer];
//    self.URL = URL;
//
//    return ijkplayer;
//}
//
//- (void)configureDefaultPlayer:(IJKFFMoviePlayerController *)player {
//    player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    player.scalingMode = IJKMPMovieScalingModeAspectFit;
//    player.shouldAutoplay = YES;
//    player.view.userInteractionEnabled = NO;
//}
//
//- (IJKFFOptions *)defaultOptions {
//    IJKFFOptions *options = [IJKFFOptions optionsByVideo];
//    [options setOptionIntValue:1 forKey:@"framedrop" ofCategory:kIJKFFOptionCategoryPlayer];
//    [options setOptionIntValue:48 forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec];
//    [options setOptionIntValue:0 forKey:@"http-detect-range-support" ofCategory:kIJKFFOptionCategoryFormat];
//    [options setOptionIntValue:0 forKey:@"start-on-prepared" ofCategory:kIJKFFOptionCategoryPlayer];
//    if (!self.notNeedSetProbesize) {
//        NSNumber *probesize = [AppCongfig findAppCongfig].playProbesize;
//        [options setOptionIntValue:probesize.integerValue forKey:@"probesize" ofCategory:kIJKFFOptionCategoryFormat];
//        [options setOptionIntValue:probesize.integerValue forKey:@"max-buffer-size" ofCategory:kIJKFFOptionCategoryPlayer];
//    }
//    [options setPlayerOptionIntValue:_enableVideoToolBox forKey:@"videotoolbox"];
//
//    return options;
//}
//
//
//- (void)loadStateDidChange:(NSNotification *)notification {
//    //    MPMovieLoadStateUnknown        = 0,
//    //    MPMovieLoadStatePlayable       = 1 << 0,
//    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
//    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
//
//    if (self.ijkPlayer != notification.object) return;
//    IJKMPMovieLoadState loadState = self.ijkPlayer.loadState;
//
//    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
//        UALog(@"%@:::::: loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", [self class], (int) loadState);
//        if ([_delegate respondsToSelector:@selector(startPlay)]) {
//            [_delegate startPlay];
//        }
//        [self configureDefaultPlayer:_ijkPlayer];
//    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
//        UALog(@"%@::::::loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", [self class], (int) loadState);
//        self.playerState = PlayerStateLoadingNoBg;
//    } else {
//        UALog(@"%@::::::loadStateDidChange: ???: %d\n", [self class], (int) loadState);
//    }
//}
//
//- (void)moviePlayBackDidFinish:(NSNotification *)notification {
//    if (self.ijkPlayer != notification.object) return;
//    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
//
//    switch (reason) {
//        case IJKMPMovieFinishReasonPlaybackEnded:
//            UALog(@"%@::::::playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", [self class], reason);
//            switch (self.actionAtItemEnd) {
//                case PlayerActionAtItemEndAdvance : {
//                    [self playFinish];
//                }
//                    break;
//                case PlayerActionAtItemEndPause : {
//                    if ([self.delegate respondsToSelector:@selector(playEndPause)]) {
//                        [self.delegate playEndPause];
//                    }
//                    [self pause];
//
//                }
//                    break;
//                case PlayerActionAtItemEndCircle : {
//                    if ([self.delegate respondsToSelector:@selector(finishCirclePlay)]) {
//                        [self.delegate finishCirclePlay];
//                    }
//
//                    self.isFirstReplay = YES;
//                    self.startTime = CFAbsoluteTimeGetCurrent();
//                    if ([self.delegate respondsToSelector:@selector(replay)]) {
//                        [self.delegate replay];
//                    }
//                    [self.ijkPlayer play];
//                }
//                    break;
//                case PlayerActionAtItemEndNone : {
//                    [self playFinish];
//                }
//                    break;
//            }
//            break;
//
//        case IJKMPMovieFinishReasonUserExited:
//            UALog(@"%@::::::playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", [self class], reason);
//            [self playError];
//            break;
//
//        case IJKMPMovieFinishReasonPlaybackError:
//            UALog(@"%@::::::playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", [self class], reason);
//            self.playerState = PlayerStateError;
//            [self playError];
//            break;
//
//        default:
//            UALog(@"%@::::::playbackPlayBackDidFinish: ???: %d\n", [self class], reason);
//            break;
//    }
//}
//
//- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification {
//    if (self.ijkPlayer != notification.object) return;
//    self.playerState = PlayerStateStarting;
//    UALog(@"%@::::::mediaIsPreparedToPlayDidChange\n", [self class]);
//}
//
//- (void)moviePlayBackStateDidChange:(NSNotification *)notification {
//    //    MPMoviePlaybackStateStopped,
//    //    MPMoviePlaybackStatePlaying,
//    //    MPMoviePlaybackStatePaused,
//    //    MPMoviePlaybackStateInterrupted,
//    //    MPMoviePlaybackStateSeekingForward,
//    //    MPMoviePlaybackStateSeekingBackward
//    if (self.ijkPlayer != notification.object) return;
//
//    switch (self.ijkPlayer.playbackState) {
//        case IJKMPMoviePlaybackStateStopped: {
//            self.playerState = PlayerStateStopped;
//            /*
//            UALog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: stoped", [self class], (int) self.ijkPlayer.playbackState);
//            if(!self.circlePlay) {
//                [self playFinish];
//            } else {
//                if([self.delegate respondsToSelector:@selector(replay)]) {
//                    [self.delegate replay];
//                }
//                [self.ijkPlayer play];
//            }
//             */
//            break;
//        }
//        case IJKMPMoviePlaybackStatePlaying: {
//            UALog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: playing", [self class], (int) self.ijkPlayer.playbackState);
//            self.playerState = PlayerStatePlaying;
//            UALog(@"~~~volume %s _setVolumeSucess = %d", __func__, _setVolumeSucess);
//            if (_changeVoluming && !_setVolumeSucess) {
//                [self changeAudioVolume:_volume];
//                UALog(@"~~~volume %s _setVolumeSucess = %d", __func__, _setVolumeSucess);
//                __weak typeof(self) weakSelf = self;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                    __strong typeof(weakSelf) strongSelf = weakSelf;
//                    [strongSelf changeAudioVolume:_volume];
//                });
//            }
//
//            if (self.isFirstReplay) {
//                CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
//                UALog(@"[IJKPlayer][end = start] %lf", time - self.startTime);
//                self.isFirstReplay = NO;
//            }
//
//            [self updatePlayerLayer];
//            break;
//        }
//        case IJKMPMoviePlaybackStatePaused: {
//            UALog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: paused", [self class], (int) self.ijkPlayer.playbackState);
//            break;
//        }
//        case IJKMPMoviePlaybackStateInterrupted: {
//            UALog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: interrupted", [self class], (int) self.ijkPlayer.playbackState);
//            break;
//        }
//        case IJKMPMoviePlaybackStateSeekingForward:
//        case IJKMPMoviePlaybackStateSeekingBackward: {
//            UALog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: seeking", [self class], (int) self.ijkPlayer.playbackState);
//            break;
//        }
//        default: {
//            UALog(@"%@::::::IJKMPMoviePlayBackStateDidChange %d: unknown", [self class], (int) self.ijkPlayer.playbackState);
//            break;
//        }
//    }
//}
//
//#pragma mark Install Movie Notifications
//
///* Register observers for the various movie object notifications. */
//- (void)installMovieNotificationObservers {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.ijkPlayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.ijkPlayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaIsPreparedToPlayDidChange:) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.ijkPlayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.ijkPlayer];
//}
//
//#pragma mark Remove Movie Notification Handlers
//
///* Remove the movie notification observers from the movie object. */
//- (void)removeMovieNotificationObservers {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.ijkPlayer];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.ijkPlayer];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.ijkPlayer];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.ijkPlayer];
//}
//
//
//@end
