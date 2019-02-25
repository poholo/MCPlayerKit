//
//  MCPlayerConfig.m
//  litttleplayer
//
//  Created by littleplayer on 16/5/4.
//  Copyright © 2016年 mjc inc. All rights reserved.
//

#import "MCPlayerConfig.h"


//////////////////////AVPlayerKVO///////////////////////////////////////////
NSString *const _kMC_Player_ExternalPlayBackActive = @"externalPlaybackActive";
NSString *const _kMC_Player_Status = @"status";
NSString *const _kMC_Player_CurrentItem = @"currentItem";

//////////////////////AVPlayerItem//////////////////////////////////////////////////////
NSString *const _kMC_PlayerItem_Status = @"status";
NSString *const _kMC_PlayerItem_PlaybackBufferEmpty = @"playbackBufferEmpty";
NSString *const _kMC_PlayerItem_PlaybackLikelyToKeepUp = @"playbackLikelyToKeepUp";
NSString *const _kMC_PlayerItem_LoadedTimeRanges = @"loadedTimeRanges";

@implementation MCPlayerConfig

@end
