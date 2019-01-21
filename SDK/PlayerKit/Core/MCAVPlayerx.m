//
// Created by majiancheng on 16/8/10.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import "MCAVPlayerx.h"

#import "NSURL+Extend.h"
#import "MCSafeKVOController.h"
#import "MCSafeNotificationManager.h"
#import "MCPlayerKitDef.h"


@interface MCAVPlayerx ()

@property(nonatomic, strong) AVQueuePlayer *player;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) NSMutableArray<AVPlayerItem *> *playerItems;
@property(nonatomic, strong) NSMutableArray<MCSafeKVOController *> *playerItemsKVOManagers;
@property(nonatomic, strong) MCSafeKVOController *playerKVOManager;
@property(nonatomic, strong) MCSafeNotificationManager *notificationManager;
@property(nonatomic, strong) id boundaryTime;

- (AVPlayerItem *)playerItemFromPath:(NSString *)path;

- (void)configurePlayerObserver;

- (void)configurePlayerItemObserver:(AVPlayerItem *)playerItem;

- (void)removePlayerItemsObserver;

- (NSInteger)indexOfItem:(AVPlayerItem *)playerItem;

- (float)availableDuration;

@end

@implementation MCAVPlayerx

- (void)dealloc {
    [self releaseSpace];
    MCLog(@"%@--%s--%d dealloc", [self class], __func__, __LINE__);
}

- (void)releaseSpace {
    [super releaseSpace];

    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
}

- (void)playUrls:(nonnull NSArray<NSString *> *)urls {
    self.startTime = CFAbsoluteTimeGetCurrent();
    self.playerState = PlayerStateLoading;
    [super playUrls:urls];
    for (NSString *url in urls) {
        AVPlayerItem *playerItem = [self playerItemFromPath:url];
        if (playerItem) {
            [self.playerItems addObject:playerItem];
        }
    }

    if (self.playerItems.count == 0) {
        self.playerState = PlayerStateError;
        return;
    }
    self.player = [AVQueuePlayer queuePlayerWithItems:self.playerItems];
    [self.player play];

    if (self.actionAtItemEnd == PlayerActionAtItemEndCircle) {
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    }
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 10) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }
    self.playerLayer = [self configPlayerLayer:self.player];

    [self configurePlayerObserver];
    [self configurePlayerItemObserver:self.player.currentItem];
    [self preparePlay];
}

- (AVPlayerLayer *)configPlayerLayer:(AVPlayer *)player {
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    switch (self.playerLayerVideoGravity) {
        case PlayerLayerVideoGravityResizeAspect: {
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        }
            break;
        case PlayerLayerVideoGravityResizeAspectFill: {
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        }
            break;
        case PlayerLayerVideoGravityResize: {
            playerLayer.videoGravity = AVLayerVideoGravityResize;
        }
            break;
    }
    return playerLayer;
}

- (void)playUrls:(NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions {
    [self playUrls:urls];
}

- (void)play {
    [super play];
    [self.player play];
}

- (void)pause {
    [super pause];
    [self.player pause];
}

- (BOOL)isPlaying {
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 10) {
        return self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    } else {
        return self.player.rate > .0f;
    }
}

- (void)seekSeconds:(CGFloat)seconds {
    [self.player seekToTime:CMTimeMake((NSInteger) (seconds * 1000), 1000)];
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
    if (self.playerKVOManager) {
        [self removePlayerItemsObserver];
        [self.playerKVOManager safelyRemoveAllObservers];
        [self.playerItems removeAllObjects];
        [self pause];
        [self.player removeAllItems];
        [self.notificationManager removeAllObservers:self];
        [self.playerLayer removeFromSuperlayer];

        self.playerKVOManager = nil;
        self.notificationManager = nil;
        self.playerItems = nil;
        self.playerLayer = nil;
        self.player = nil;
    }
}

- (NSTimeInterval)currentTime {
    return CMTimeGetSeconds(self.player.currentItem.currentTime);
}

- (NSTimeInterval)duration {
    return CMTimeGetSeconds(self.player.currentItem.duration);
}

- (PlayerCoreType)playerType {
    return PlayerCoreAVPlayer;
}

- (void)playFinish:(NSNotification *)notification {
    if (notification.object != self.player.currentItem) return;
    [self playFinishX];
}

- (void)playFinishX {
    switch (self.actionAtItemEnd) {
        case PlayerActionAtItemEndAdvance : {
            self.playerState = PlayerStatePlayEnd;
        }
            break;
        case PlayerActionAtItemEndCircle : {
            self.startTime = CFAbsoluteTimeGetCurrent();
            self.playerState = PlayerStatePlayEnd;
        }
            break;
        case PlayerActionAtItemEndNone : {
            self.playerState = PlayerStatePlayEnd;
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

- (NSMutableArray<MCSafeKVOController *> *)playerItemsKVOManagers {
    if (_playerItemsKVOManagers == nil) {
        _playerItemsKVOManagers = [[NSMutableArray alloc] init];
    }
    return _playerItemsKVOManagers;
}


- (MCSafeKVOController *)playerKVOManager {
    if (_playerKVOManager == nil) {
        _playerKVOManager = [[MCSafeKVOController alloc] initWithTarget:self.player];
    }
    return _playerKVOManager;
}

- (void)setPlayerState:(PlayerState)playerState {
    if (_playerState == playerState) return;
    _playerState = playerState;
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

- (MCSafeNotificationManager *)notificationManager {
    if (_notificationManager == nil) {
        _notificationManager = [[MCSafeNotificationManager alloc] init];
    }
    return _notificationManager;
}

#pragma mark - private

- (AVPlayerItem *)playerItemFromPath:(NSString *)path {
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL source4URI:path]];
    return playerItem;
}

- (void)configurePlayerObserver {
    [self.playerKVOManager safelyAddObserver:self forKeyPath:_k_Player_ExternalPlayBackActive options:NSKeyValueObservingOptionNew context:nil];
    [self.playerKVOManager safelyAddObserver:self forKeyPath:_k_Player_Status options:NSKeyValueObservingOptionNew context:nil];
    [self.playerKVOManager safelyAddObserver:self forKeyPath:_k_Player_CurrentItem options:NSKeyValueObservingOptionNew context:nil];
    [self.notificationManager addObserver:self selector:@selector(playFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    __weak typeof(self) weakSelf = self;
    self.boundaryTime = [self.player addBoundaryTimeObserverForTimes:@[[NSValue valueWithCMTime:CMTimeMake(1, 100)]] queue:dispatch_get_main_queue() usingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.startEndTime = CFAbsoluteTimeGetCurrent();
        MCLog(@"[AVPlayer] %llf startDuration %llf", [strongSelf currentTime], strongSelf.startEndTime - strongSelf.startTime);
        strongSelf.playerState = PlayerStateStarting;
    }];

}

- (void)configurePlayerItemObserver:(AVPlayerItem *)playerItem {
    MCSafeKVOController *ijkkvoController = [[MCSafeKVOController alloc] initWithTarget:playerItem];
    [ijkkvoController safelyAddObserver:self forKeyPath:_k_PlayerItem_Status options:NSKeyValueObservingOptionNew context:nil];
    [ijkkvoController safelyAddObserver:self forKeyPath:_k_PlayerItem_PlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
    [ijkkvoController safelyAddObserver:self forKeyPath:_k_PlayerItem_PlaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:nil];
    [ijkkvoController safelyAddObserver:self forKeyPath:_k_PlayerItem_LoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItemsKVOManagers addObject:ijkkvoController];

}

- (void)removePlayerItemsObserver {
    if (self.boundaryTime) {
        [self.player removeTimeObserver:self.boundaryTime];
        self.boundaryTime = nil;
    }
    for (MCSafeKVOController *ijkkvoController in self.playerItemsKVOManagers) {
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
    }

    if (object != [self.player currentItem]) {
        return;
    }

    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerStatusFailed) {
            self.playerState = PlayerStateError;
        }

    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"] && self.player.currentItem.playbackBufferEmpty) {
        self.playerState = PlayerStateBuffering;
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"] && self.player.currentItem.playbackLikelyToKeepUp) {
        self.playerState = PlayerStatePlaying;

    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        MCLog(@"[MCPlayer] loadedTimeRanges");
    }

}

- (float)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    // Check to see if the timerange is not an empty array, fix for when video goes on airplay
    // and video doesn't include any time ranges
    if (loadedTimeRanges.count > 0) {
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        CGFloat startSeconds = @(CMTimeGetSeconds(timeRange.start)).floatValue;
        CGFloat durationSeconds = @(CMTimeGetSeconds(timeRange.duration)).floatValue;
        return (startSeconds + durationSeconds);
    } else {
        return 0.0f;
    }
}

- (CGFloat)cacheProgress {
    double durationTime = CMTimeGetSeconds([[self.player currentItem] duration]);
    double bufferTime = [self availableDuration];
    return (CGFloat) (bufferTime / durationTime);
}

@end
