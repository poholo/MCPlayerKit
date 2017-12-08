//
//  PlayerKit.m
//  WaQuVideo
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 mjc inc. All rights reserved.
//


#import "PlayerKit.h"

#import <IJKMediaFramework/IJKMediaFramework.h>
#import <ReactiveCocoa.h>

#import "UALogger.h"
#import "IJKPlayer.h"
#import "Utilities.h"
#import "HWWeakTimer.h"
#import "AVPlayerx.h"
#import "SnapDto.h"
#import "Entity+GlobalDao.h"
#import "VideoEditorProcess.h"
#import "GCDQueue.h"


@interface PlayerKit () <PlayerDelegate, PlayerViewControlDelegate>

/** 计时器 */
@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) NSArray<NSString *> *urls;
@property(nonatomic, assign) BOOL isPause;

@end

@implementation PlayerKit

- (void)dealloc {
    [self destoryPlayer];
}

- (instancetype)initWithPlayerView:(PlayerBaseView <PlayerViewDelegate> *)playerView {
    self = [super init];
    if (self) {
        _playerView = playerView;

        if ([_playerView respondsToSelector:@selector(showLoading)]) {
            [_playerView showLoading];
        }
        self.playerEnvironment = PlayerEnvironmentOnBecomeActiveStatus;

        _playerView.playerControlDelegate = self;
    }
    return self;
}

- (void)updatePlayerView:(PlayerBaseView <PlayerViewDelegate> *)playerView {
    _playerView = playerView;
    _playerView.playerControlDelegate = self;
    self.playerEnvironment = PlayerEnvironmentOnBecomeActiveStatus;
    [self updatePlayerLayer];
}

- (void)destoryPlayer {
    [self fireTimer];
    [_player destory];
    _player = nil;
}

- (BOOL)startRecordFilePath:(NSString *)filePath {
    return [self startRecordFilePath:filePath type:RecordNormal];
}

- (BOOL)startRecordFilePath:(NSString *)filePath type:(RecordType)type {
    [self play];
    NSLog(@"wq_ff currentTime = %f ======", _player.currentTime);
    return [_player startRecord:_player.currentTime filePath:filePath type:type];
}

- (void)endRecord {
    [_player endRecord:_player.currentTime];
}

- (NSTimeInterval)duration {
    return [_player duration];
}

- (NSTimeInterval)currentTime {
    return [_player currentTime];
}

- (BOOL)isPlaying {
    return [_player isPlaying];
}

- (void)setActionAtItemEnd:(PlayerActionAtItemEnd)actionAtItemEnd {
    _actionAtItemEnd = actionAtItemEnd;
    _player.actionAtItemEnd = actionAtItemEnd;
}

- (void)seekSeconds:(CGFloat)seconds {
    [_player seekSeconds:seconds];
    if ([self.playerStatusDelegate respondsToSelector:@selector(afterSeekNeed2Play)]) {
        BOOL need2Play = [self.playerStatusDelegate afterSeekNeed2Play];
        if (need2Play) {
            [self play];
        } else {
            [self pause];
        }
    } else {
        [self play];
    }
}

+ (int)initSensetimeSDK:(NSString *)faceModelPath {
    return [Player initSensetimeSDK:faceModelPath];
}

+ (void)destorySensetimeSDK {
    [Player destorySensetimeSDK];
}

- (int)createSensetimeStickerInstance:(NSString *)stickerZipPath {
    return [_player createSensetimeStickerInstance:stickerZipPath];
}

- (int)changeSensetimeStickerPackage:(NSString *)stickerZipPath {
    return [_player changeSensetimeStickerPackage:stickerZipPath];
}

- (void)destorySensetimeStickerInstance {
    [_player destorySensetimeStickerInstance];
}

- (CGSize)naturalSize {
    return [_player naturalSize];
}

- (BOOL)conditionLimit2CannotPlay {
    if (self.playerEnvironment == PlayerEnvironmentOnResignActiveStatus) {
        return YES;
    }

    if (self.playerUserStatus == PlayerUserAirplayStatus) {
        return YES;
    } else {
        if (self.playerUserStatus == PlayerUserPauseStatus) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - WaQuIJKSnapDelegate

- (uint64_t)addSticker:(NSString *)stickerFilePath startTime:(uint64_t)startTime endTime:(uint64_t)endTime centerX:(float)centerX centerY:(float)centerY scaleX:(float)scaleX scaleY:(float)scaleY angle:(int)angle {
    return [_player addSticker:stickerFilePath startTime:startTime endTime:endTime centerX:centerX centerY:centerY scaleX:scaleX scaleY:scaleY angle:angle];
}

- (uint64_t)addCaption:(unsigned char *)buffer startTime:(uint64_t)startTime endTime:(uint64_t)endTime width:(int)width height:(int)height centerX:(float)centerX centerY:(float)centerY scaleX:(float)scaleX scaleY:(float)scaleY angle:(int)angle {
    uint64_t snapId = [_player addCaption:buffer startTime:startTime endTime:endTime width:width height:height centerX:centerX centerY:centerY scaleX:scaleX scaleY:scaleY angle:angle];
    // [self.videoEditProcess preAddSnapId:[NSString stringWithFormat:@"%lld", snapId] buffer:buffer startTime:startTime endTime:endTime width:width height:height centerX:centerX centerY:centerY scaleX:scaleX scaleY:scaleY angle:angle];
    return snapId;
}

- (bool)updateStickerObject:(uint64_t)objId objType:(int)objType startTime:(int64_t)startTime endTime:(int64_t)endTime width:(int)width height:(int)height centerX:(float)centerX centerY:(float)centerY scaleX:(float)scaleX scaleY:(float)scaleY angle:(int)angle {
    return [_player updateStickerObject:objId objType:objType startTime:startTime endTime:endTime width:width height:height centerX:centerX centerY:centerY scaleX:scaleX scaleY:scaleY angle:angle];
}

- (int)deleteStickerObject:(uint64_t)objId objType:(int)objType {
    int ret = [_player deleteStickerObject:objId objType:objType];
    // [self.videoEditProcess preDeleteObject:objId objType:objType];
    return ret;
}

- (int)enableStickerObject:(uint64_t)objId objType:(int)objType enable:(bool)enable {
    return [_player enableStickerObject:objId objType:objType enable:enable];
}

- (int)initRecord:(NSString *)fileName {
    return [_player initRecord:fileName];
}

- (int)initRecordEX:(NSString *)fileName width:(int)width height:(int)height videoBitrate:(int)videoBitrate {
    return [_player initRecordEX:fileName width:width height:height videoBitrate:videoBitrate];
}

- (void)startRecord {
    [_player startRecord:0];
}

- (void)stopRecord {
    [_player stopRecord];
}

- (int)setBackgroundMusicInsertTime:(uint64_t)insertTime {
    return [_player setBackgroundMusicInsertTime:insertTime];
}

- (long)setBackgroundMusicPath:(NSString *)musicPath {
    return [_player setBackgroundMusicPath:musicPath];
}

- (BOOL)setBackgroundMusicRegion:(uint64_t)startTime endTime:(uint64_t)endTime {
    return [_player setBackgroundMusicRegion:startTime endTime:endTime];
}

- (BOOL)setOutputAudioVolume:(int)trackIdx volume:(float)volume {
    return [_player setOutputAudioVolume:trackIdx volume:volume];
}

+ (long)executeFfmpegCmd:(int)argc paramArray:(char **)argv {
    return 0;
}


#pragma mark -
#pragma mark NSTimer

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [HWWeakTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (void)fireTimer {
    if (_timer != nil || [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timeTick {
    double curSecs = _player.currentTime;
    double sumSecs = _player.duration;
    if ([_playerView respondsToSelector:@selector(updateProgress:)]
            && [_playerView respondsToSelector:@selector(updateLeftTime:)]
            && [_playerView respondsToSelector:@selector(updateRightTime:)]
            && [_playerView respondsToSelector:@selector(updateBufferProgress:)]) {
        [_playerView updateProgress:(CGFloat) (curSecs / sumSecs)];
        [_playerView updateLeftTime:[Utilities millisecondToHumanString:(curSecs + .5) * 1000]];
        [_playerView updateRightTime:[Utilities millisecondToHumanString:(sumSecs + .5) * 1000]];
        [_playerView updateBufferProgress:_player.cacheProgress];
    }

    if ([self.playerStatusDelegate respondsToSelector:@selector(currentTime:)]) {
        [self.playerStatusDelegate currentTime:self.currentTime];
    }
}

#pragma mark - PlayerDelegate


- (void)loading {
}

- (void)startPlay {
    if ([_playerView respondsToSelector:@selector(showStateStarting)]) {
        [_playerView showStateStarting];
    }
}

- (void)pauseCaching {
    if ([_playerView respondsToSelector:@selector(showBuffering)]) {
        [_playerView showBuffering];
    }
}

- (void)cacheProgress:(float)cacheRate {
    if ([_playerView respondsToSelector:@selector(updateBufferProgress:)]) {
        [_playerView updateBufferProgress:cacheRate];
    }
}

- (void)playError {
    if ([_playerView respondsToSelector:@selector(showError)]) {
        [_playerView showError];
    }
}

- (void)playFinish {
    if ([_playerView respondsToSelector:@selector(showPlayEnd)]) {
        [_playerView showPlayEnd];
    }

    if ([self.playerStatusDelegate respondsToSelector:@selector(playerEndplay)]) {
        [self.playerStatusDelegate playerEndplay];
    }

    if ([self.playerStatusDelegate respondsToSelector:@selector(playerEndAutoNext)]) {
        [self.playerStatusDelegate playerEndAutoNext];
    }
}

- (void)playEndPause {
    if ([self.playerStatusDelegate respondsToSelector:@selector(playEndPause)]) {
        [self.playerStatusDelegate playEndPause];
    }
}

- (void)replay {
    if ([self.playerStatusDelegate respondsToSelector:@selector(playerEndAutoNext)]) {
        [self.playerStatusDelegate playerEndAutoNext];
    }
}

- (void)changePlayerState:(PlayerState)playerState {
    UALog(@"PlayerState == %zd", playerState);
    switch (playerState) {
        case PlayerStateNone: {
        }
            break;
        case PlayerStateLoading      : {
            if ([_playerView respondsToSelector:@selector(showLoading)]) {
                [_playerView showLoading];
            }

            if ([_playerView respondsToSelector:@selector(updateRightTime:)]) {
                [_playerView updateRightTime:[Utilities millisecondToHumanString:_player.duration * 1000]];
            }
            [self timer];
        }
            break;
        case PlayerStateLoadingNoBg  : {

            if ([_playerView respondsToSelector:@selector(showLoadingNoDefaultBg)]) {
                [_playerView showLoadingNoDefaultBg];
            }
            [self timer];
        }
            break;
        case PlayerStateBuffering    : {

            if ([_playerView respondsToSelector:@selector(showBuffering)]) {
                [_playerView showBuffering];
            }
        }
            break;
        case PlayerStateStarting     : {
            [self pause];
            [self isPlaySmarty];
            [self timer];

            if ([_playerView respondsToSelector:@selector(showStateStarting)]) {
                [_playerView showStateStarting];
            }

            if ([self.playerStatusDelegate respondsToSelector:@selector(playerStartplay)]) {
                [self.playerStatusDelegate playerStartplay];
            }
            [self updatePlayerLayer];


//            if(self.changeDefinitionTypeCurrentTime > 0) {
//                [self  seekSeconds:self.changeDefinitionTypeCurrentTime];
//            }
//            else if([_playerDelegate respondsToSelector:@selector(jumpHistoryPlayRecordTime)]) {
//                [_playerDelegate jumpHistoryPlayRecordTime];
//            }
        }
            break;
        case PlayerStatePlaying      : {

            if ([_playerView respondsToSelector:@selector(showPlaying)]) {
                [_playerView showPlaying];
            }
        }
            break;
        case PlayerStatePlayEnd      : {

            if ([_playerView respondsToSelector:@selector(showPlayEnd)]) {
                [_playerView showPlayEnd];
            }
            if ([self.playerStatusDelegate respondsToSelector:@selector(playerEndAutoNext)]) {
                [self.playerStatusDelegate playerEndAutoNext];
            }
        }
            break;
        case PlayerStatePausing      : {

            if ([_playerView respondsToSelector:@selector(showPausing)]) {
                [_playerView showPausing];
            }
//            [self logCallBackStatus:self.playerState];
        }
            break;
        case PlayerStateStopped      : {

            if ([_playerView respondsToSelector:@selector(showStopped)]) {
                [_playerView showStopped];
            }
//            [self logCallBackStatus:self.playerState];
        }
            break;
        case PlayerState3GUnenable: {

            if ([_playerView respondsToSelector:@selector(show3GUnenable)]) {
                [_playerView show3GUnenable];
            }
//            [self pause:WQPlayerPauseBy3GCannotPlay];
        }
            break;
        case PlayerStateNetError    : {

            if ([_playerView respondsToSelector:@selector(showNetError)]) {
                [_playerView showNetError];
            }
//            [self pause:PlayerPauseBy3GCannotPlay];
        }
            break;
        case PlayerStateUrlError    : {

            if ([_playerView respondsToSelector:@selector(showUrlError)]) {
                [_playerView showUrlError];
            }
            if ([_playerStatusDelegate respondsToSelector:@selector(playerStartError)]) {
                [_playerStatusDelegate playerStartError];
            }
        }
            break;
        case PlayerStateError        : {
            if ([_playerView respondsToSelector:@selector(showError)]) {
                [_playerView showError];
            }
            if ([_playerStatusDelegate respondsToSelector:@selector(playerStartError)]) {
                [_playerStatusDelegate playerStartError];
            }
        }
            break;
        case PlayerPlayingUsingAirplay : {
//            [self showAirplaying];
        }
            break;
        default: {

        }
            break;
    }
}

- (void)changeCurrentPlayerIndex:(NSInteger)currentIndex {

}


- (void)updatePlayerLayer {
    if ([_playerView respondsToSelector:@selector(updatePlayerLayer:)] && [_player playerLayer]) {
        [_playerView updatePlayerLayer:[_player playerLayer]];
    }

    if ([_playerView respondsToSelector:@selector(updatePlayerView:)] && [_player playerView]) {
        [_playerView updatePlayerView:[_player playerView]];
    }

    if ([_playerView respondsToSelector:@selector(refreshNatureSize:)]) {
        [_playerView refreshNatureSize:_player.naturalSize];
    }

}

- (void)cacheFinish:(Dto *)dto {
    if ([dto isKindOfClass:[SnapDto class]]) {
        SnapDto *dd = dto;
        SnapEntity *entity = [SnapEntity createSnapEntity:dd];
        entity.downloadState = DownloadFinished;
        [entity MMPersistence];
    }
}

- (void)isPlaySmarty {
    [self pause];
    [self play];
}

- (BOOL)playerCanAutoPlay {
    return YES;
}

- (void)finishCirclePlay {
    if ([self.playerStatusDelegate respondsToSelector:@selector(playerEndplay)]) {
        [self.playerStatusDelegate playerEndplay];
    }
}

#pragma mark - PlayerViewControlDelegate

- (void)playUrls:(nonnull NSArray<NSString *> *)urls {
    [self playUrls:urls isLiveOptions:NO];
}

- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions {
    [self playUrls:urls dto:nil isLiveOptions:isLiveOptions];
}

- (void)playUrls:(nonnull NSArray<NSString *> *)urls dto:(Dto <StoreDelegate> *)dto {
    [self playUrls:urls dto:dto isLiveOptions:NO];
}

- (void)playUrls:(nonnull NSArray<NSString *> *)urls dto:(Dto <StoreDelegate> *)dto isLiveOptions:(BOOL)isLiveOptions {
    [self destoryPlayer];
    self.urls = urls;
    _player = ({
        Player *player;
        if (self.playerCoreType == PlayerCoreIJKPlayer) {
            player = [[IJKPlayer alloc] init];
        } else if (self.playerCoreType == PlayerCoreAVPlayer) {
            player = [[AVPlayerx alloc] init];
        } else {
            player = [[IJKPlayer alloc] init];
        }
        player;
    });
    _player.actionAtItemEnd = self.actionAtItemEnd;
    _player.dto = dto;
    [_player playUrls:urls isLiveOptions:isLiveOptions];
    _player.delegate = self;
    if ([_playerView respondsToSelector:@selector(showLoading)]) {
        [_playerView showLoading];
    }
}

- (void)destory {
    [_player destory];
}

- (void)preparePlay {
    if ([self conditionLimit2CannotPlay]) {
        return;
    }
    [_player preparePlay];
}

- (void)play {
    if ([self conditionLimit2CannotPlay]) {
        return;
    }
    [self timer];
    [_player preparePlay];
    [_player play];
    if ([_playerView respondsToSelector:@selector(showPlayBtnPlay:)]) {
        [_playerView showPlayBtnPlay:YES];
    }
}

- (void)pause {
    [self fireTimer];
    [_player pause];
    if ([_playerView respondsToSelector:@selector(showPlayBtnPlay:)]) {
        [_playerView showPlayBtnPlay:NO];
    }
}

- (void)cancelLoading {
    [_player cancelLoading];
}

- (void)playRate:(CGFloat)playRate {
    [_player playRate:playRate];
}

- (CGFloat)playRate {
    return [_player rate];
}

- (NSInteger)currentPlayerItemIndex {
    return [_player currentPlayerItemIndex];
}

- (BOOL)hasNextVideoItem {
    return [_player hasNextVideoItem];
}

- (void)playNextVideoItem {
    [_player playNextVideoItem];
}

- (void)changeAudioVolume:(CGFloat)volume {
    [_player changeAudioVolume:volume];
}

@end
