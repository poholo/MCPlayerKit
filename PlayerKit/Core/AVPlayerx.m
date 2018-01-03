//
// Created by majiancheng on 16/8/10.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import "AVPlayerx.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "PlayerKitLog.h"
#import "NSURL+Extend.h"
#import "SafeKVOController.h"
#import "SafeNotificationManager.h"


@interface AVPlayerx ()

@property(nonatomic, strong) AVQueuePlayer *player;
@property(nonatomic, strong) AVPlayerLayer *avplayerLayer;
@property(nonatomic, strong) NSMutableArray<AVPlayerItem *> *playerItems;
@property(nonatomic, strong) NSMutableArray<SafeKVOController *> *playerItemsKVOManagers;
@property(nonatomic, strong) SafeKVOController *playerKVOManager;
@property(nonatomic, strong) SafeNotificationManager *notificationManager;

@property(nonatomic, assign) CFAbsoluteTime startTime;


- (AVPlayerItem *)playerItemFromPath:(NSString *)path;

- (void)configurePlayerObserver;

- (void)configurePlayerItemObserver:(AVPlayerItem *)playerItem;

- (void)removePlayerItemsObserver;

- (NSInteger)indexOfItem:(AVPlayerItem *)playerItem;

- (float)availableDuration;

@end

@implementation AVPlayerx

- (void)dealloc {
    [self releaseSpace];
    PKLog(@"%@--%s--%d dealloc", [self class], __func__, __LINE__);
}

- (void)releaseSpace {
    [super releaseSpace];

    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
}

- (void)playUrls:(nonnull NSArray<NSString *> *)urls {
    self.playerState = PlayerStateLoading;
    [super playUrls:urls];
    for (NSString *url in urls) {
        AVPlayerItem *playerItem = [self playerItemFromPath:url];
        if (playerItem) {
            [self.playerItems addObject:playerItem];
        }
    }

    if (self.playerItems.count == 0) {
        self.playerState = PlayerStateUrlError;
        return;
    }
    self.player = [AVQueuePlayer queuePlayerWithItems:self.playerItems];
    if (self.actionAtItemEnd == PlayerActionAtItemEndCircle) {
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    }
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 10) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }
    self.avplayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];

    [self configurePlayerObserver];
    [self configurePlayerItemObserver:self.player.currentItem];
    [self preparePlay];
}

- (void)playUrls:(NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions {
    [self playUrls:urls];
}

- (void)preparePlay {
    [self setupAudio];
    [super preparePlay];
    [self updatePlayerLayer];
}

- (void)setupAudio {
    /* Set audio session to mediaplayback */
    NSError *error = nil;
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"AVPlayerx: AVAudioSession.setCategory() failed: %@\n", error ? [error localizedDescription] : @"nil");
        return;
    }

    error = nil;
    if (![[AVAudioSession sharedInstance] setActive:YES error:&error]) {
        NSLog(@"AVPlayerx: AVAudioSession.setActive(YES) failed: %@\n", error ? [error localizedDescription] : @"nil");
        return;
    }
}

- (void)play {
    [super play];
    [self.player setRate:self.rate];
    [self.player play];
}

- (void)pause {
    if ([self isPlaying]) {
        [super pause];
        self.player.rate = 0.0f;
        [self.player pause];
    }
}

- (BOOL)isPlaying {
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 10) {
        return self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    } else {
        return self.player.rate > .0f;
    }
}

- (void)seekSeconds:(CGFloat)seconds {
    [self.player seekToTime:CMTimeMake(seconds, 1)];
}

- (void)playRate:(CGFloat)playRate {
    [super playRate:playRate];
    if (self.isPlaying) {
        [self play];
    }
}


- (CGFloat)rate {
    return self.player.rate;
}

- (void)cancelLoading {
    [super cancelLoading];
    [_player.currentItem.asset cancelLoading];
}

- (void)destory {
    [super destory];
    [self removePlayerItemsObserver];
    [self.playerKVOManager safelyRemoveAllObservers];
    [self.playerItems removeAllObjects];
    [self pause];
    [self.player removeAllItems];
    [self.notificationManager removeAllObservers:self];
    [self.avplayerLayer removeFromSuperlayer];

    self.playerKVOManager = nil;
    self.notificationManager = nil;
    self.playerItems = nil;
    self.avplayerLayer = nil;
    self.player = nil;
}

- (NSTimeInterval)currentTime {
    return CMTimeGetSeconds(self.player.currentItem.currentTime);
}

- (NSTimeInterval)duration {
    return CMTimeGetSeconds(self.player.currentItem.duration);
}

- (CALayer *)playerLayer {
    return self.avplayerLayer;
}

- (PlayerCoreType)playerType {
    return PlayerCoreAVPlayer;
}

- (NSInteger)currentPlayerItemIndex {
    return [self indexOfItem:self.player.currentItem];
}

- (BOOL)hasNextVideoItem {
    NSInteger currentItemIndex = [self indexOfItem:self.player.currentItem] + 1;
    if (NSNotFound == currentItemIndex || currentItemIndex >= self.playerItems.count) {
        return NO;
    } else if (currentItemIndex < self.playerItems.count) {
        return YES;
    }
    return NO;
}

- (void)playNextVideoItem {
    [self removePlayerItemsObserver];
    [self.player advanceToNextItem];
    [self configurePlayerItemObserver:self.player.currentItem];
    [self preparePlay];
}

- (void)playFinish:(NSNotification *)notification {
    if (notification.object != self.player.currentItem) return;
    [self playFinishX];
}

- (void)playFinishX {
    switch (self.actionAtItemEnd) {
        case PlayerActionAtItemEndAdvance : {
            [super playFinish];
        }
            break;
        case PlayerActionAtItemEndPause : {
            [self pause];
        }
            break;
        case PlayerActionAtItemEndCircle : {
            if ([self.delegate respondsToSelector:@selector(finishCirclePlay)]) {
                [self.delegate finishCirclePlay];
            }
            [self seekSeconds:0.0f];
            [self play];
        }
            break;
        case PlayerActionAtItemEndNone : {
            [super playFinish];
        }
            break;
    }
}

#pragma mark - getter setter

- (NSMutableArray *)playerItems {
    if (_playerItems == nil) {
        _playerItems = [[NSMutableArray alloc] init];
    }
    return _playerItems;
}

- (NSMutableArray<SafeKVOController *> *)playerItemsKVOManagers {
    if (_playerItemsKVOManagers == nil) {
        _playerItemsKVOManagers = [[NSMutableArray alloc] init];
    }
    return _playerItemsKVOManagers;
}


- (SafeKVOController *)playerKVOManager {
    if (_playerKVOManager == nil) {
        _playerKVOManager = [[SafeKVOController alloc] initWithTarget:self.player];
    }
    return _playerKVOManager;
}

- (void)setPlayerState:(PlayerState)playerState {
    _playerState = playerState;
    [self changePlayerState:playerState];
}

- (CGSize)naturalSize {
    NSArray<AVAssetTrack *> *tracks = [_player.currentItem.asset tracksWithMediaType:AVMediaTypeVideo];
    AVAsset *asset = _player.currentItem.asset;
    CGAffineTransform form = asset.preferredTransform;
    if (tracks.count == 0) {
        return CGSizeZero;
    } else {
        AVAssetTrack *track = tracks.firstObject;

        NSArray<NSString *> *availableMetadataFormats = asset.availableMetadataFormats;
        NSArray<AVMetadataItem *> *commonMetadata = asset.commonMetadata;
        NSArray<AVMetadataItem *> *metadata = asset.metadata;
        return tracks.firstObject.naturalSize;
    }
}

- (SafeNotificationManager *)notificationManager {
    if (_notificationManager == nil) {
        _notificationManager = [[SafeNotificationManager alloc] init];
    }
    return _notificationManager;
}

#pragma mark - private

- (AVPlayerItem *)playerItemFromPath:(NSString *)path {
    if ([path isEqualToString:@"live_small"]) {
        return nil;
    }
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL source4URI:path]];
    playerItem.preferredPeakBitRate = 800.0f;
    return playerItem;
}

- (void)configurePlayerObserver {
    [self.playerKVOManager safelyAddObserver:self forKeyPath:_k_Player_ExternalPlayBackActive options:NSKeyValueObservingOptionNew context:nil];
    [self.playerKVOManager safelyAddObserver:self forKeyPath:_k_Player_Status options:NSKeyValueObservingOptionNew context:nil];
    [self.playerKVOManager safelyAddObserver:self forKeyPath:_k_Player_CurrentItem options:NSKeyValueObservingOptionNew context:nil];
    [self.notificationManager addObserver:self selector:@selector(playFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)configurePlayerItemObserver:(AVPlayerItem *)playerItem {
    SafeKVOController *ijkkvoController = [[SafeKVOController alloc] initWithTarget:playerItem];
    [ijkkvoController safelyAddObserver:self forKeyPath:_k_PlayerItem_Status options:NSKeyValueObservingOptionNew context:nil];
    [ijkkvoController safelyAddObserver:self forKeyPath:_k_PlayerItem_PlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
    [ijkkvoController safelyAddObserver:self forKeyPath:_k_PlayerItem_PlaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:nil];
    [ijkkvoController safelyAddObserver:self forKeyPath:_k_PlayerItem_LoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItemsKVOManagers addObject:ijkkvoController];
}

- (void)removePlayerItemsObserver {
    for (SafeKVOController *ijkkvoController in self.playerItemsKVOManagers) {
        [ijkkvoController safelyRemoveAllObservers];
    }
    [self.playerItemsKVOManagers removeAllObjects];
}

- (NSInteger)indexOfItem:(AVPlayerItem *)playerItem {
    return [self.playerItems indexOfObject:playerItem];
}


#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusFailed) {
            [self removePlayerItemsObserver];
            self.playerState = PlayerStateError;
        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
            self.playerState = PlayerStateLoading;
            [self configurePlayerItemObserver:self.player.currentItem];
        }
        return;
    } else if (object == self.player && [keyPath isEqualToString:@"externalPlaybackActive"]) {

        return;
    } else if (object == self.player && [keyPath isEqualToString:@"currentItem"]) {
        if ([change[@"new"] isEqual:NSNull.null]) {
            PKLog(@"%@", change[@"new"]);
            self.playerState = PlayerStateError;
            return;
        }
    }

    if (object != [self.player currentItem]) {
        return;
    }


    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerStatusFailed) {
            self.playerState = PlayerStateError;
        } else if (self.player.currentItem.status == AVPlayerStatusReadyToPlay) {
            self.playerState = PlayerStateStarting;
        }

    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"] && self.player.currentItem.playbackBufferEmpty) {
        self.playerState = PlayerStateLoadingNoBg;
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"] && self.player.currentItem.playbackLikelyToKeepUp) {
        if ([_delegate respondsToSelector:@selector(playerCanAutoPlay)] && [_delegate playerCanAutoPlay]) {
            self.playerState = PlayerStateStarting;
            if ([_delegate respondsToSelector:@selector(isPlaySmarty)]) {
                [_delegate isPlaySmarty];
            }
        }

    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //缓冲进度
        float durationTime = CMTimeGetSeconds([[self.player currentItem] duration]);
        float bufferTime = [self availableDuration];
        self.cacheProgress = bufferTime / durationTime;
        if ([_delegate respondsToSelector:@selector(playerCanAutoPlay)] && [_delegate playerCanAutoPlay]) {
            self.playerState = PlayerStatePlaying;
            if ([_delegate respondsToSelector:@selector(isPlaySmarty)]) {
                [_delegate isPlaySmarty];
            }
        }

    }

}

- (float)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    // Check to see if the timerange is not an empty array, fix for when video goes on airplay
    // and video doesn't include any time ranges
    if ([loadedTimeRanges count] > 0) {
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
        CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
        return (startSeconds + durationSeconds);
    } else {
        return 0.0f;
    }
}

@end
