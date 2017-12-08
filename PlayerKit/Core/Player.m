//
// Created by imooc on 16/5/18.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import "Player.h"

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "Dto.h"

#import "IJKPlayer.h"
#import "AVPlayerx.h"
#import "NSURL+Convert2HTTPS.h"
#import "Dto+DownloadInfo.h"

@implementation Player

@synthesize playerState = _playerState, cacheProgress = _cacheProgress, rate = _rate, delegate = _delegate;

- (void)dealloc {
    [self releaseSpace];
}

- (void)releaseSpace {
    _delegate = nil;
    [self destory];
}

- (void)enableVideoToolBox:(BOOL)enable {
    _enableVideoToolBox = enable;
}


- (void)playUrls:(nonnull NSArray<NSString *> *)urls {
    [self destory];
}


- (void)playUrls:(nonnull NSArray<NSString *> *)urls isLiveOptions:(BOOL)isLiveOptions {
    [self destory];
}

- (CGFloat)rate {
    return _rate;
}

- (void)preparePlay {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)play {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)pause {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (BOOL)isPlaying {
    return NO;
}

- (void)seekSeconds:(CGFloat)seconds {
}


- (void)stop {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)playRate:(CGFloat)playRate {
    _rate = playRate;
}

- (void)destory {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self cancelLoading];
    if ([self playerLayer]) {
        [[self playerLayer] removeFromSuperlayer];
    }
    if (self.playerView) {
        [[self playerView] removeFromSuperview];
    }
}

- (NSTimeInterval)currentTime {
    return 0.0f;
}

- (NSTimeInterval)duration {
    return 0.0f;
}

- (CALayer *)playerLayer {
    return nil;
}

- (UIView *)playerView {
    return nil;
}

- (PlayerCoreType)playerType {
    return PlayerCoreNone;
}

- (NSInteger)currentPlayerItemIndex {
    return NSNotFound;
}

- (BOOL)hasNextVideoItem {
    return NO;
}

- (void)playNextVideoItem {
}

- (void)changePlayerState:(PlayerState)playerState {
    if ([_delegate respondsToSelector:@selector(changePlayerState:)]) {
        [_delegate changePlayerState:playerState];
    }
}

- (void)playFinish {
    if ([_delegate respondsToSelector:@selector(playFinish)]) {
        [_delegate playFinish];
    }
    [self destory];
}

- (void)playError {
    [self destory];
    if ([_delegate respondsToSelector:@selector(playError)]) {
        [_delegate playError];
    }
}

- (void)updatePlayerLayer {
    if ([_delegate respondsToSelector:@selector(updatePlayerLayer)]) {
        [_delegate updatePlayerLayer];
    }

    if ([_delegate respondsToSelector:@selector(adpaterPlayRate)]) {
        [_delegate adpaterPlayRate];
    }
}

- (void)changePlayer:(PlayerCoreType)currentPlayerType {
    if ([_delegate respondsToSelector:@selector(changePlayer:)]) {
        [_delegate changePlayer:currentPlayerType];
    }
}

- (void)cancelLoading {

}

- (void)changeAudioVolume:(CGFloat)volume {
}

- (CGSize)naturalSize {
    return CGSizeZero;
}

+ (int)initSensetimeSDK:(NSString *)faceModelPath {
    return 0;
}

+ (void)destorySensetimeSDK {

}

- (int)createSensetimeStickerInstance:(NSString *)stickerZipPath {
    return 0;
}

- (int)changeSensetimeStickerPackage:(NSString *)stickerZipPath {
    return 0;
}

- (void)destorySensetimeStickerInstance {

}

- (uint64_t)addSticker:(NSString *)stickerFilePath startTime:(uint64_t)startTime endTime:(uint64_t)endTime centerX:(float)centerX centerY:(float)centerY scaleX:(float)scaleX scaleY:(float)scaleY angle:(int)angle {
    return 0;
}

- (uint64_t)addCaption:(unsigned char *)buffer startTime:(uint64_t)startTime endTime:(uint64_t)endTime width:(int)width height:(int)height centerX:(float)centerX centerY:(float)centerY scaleX:(float)scaleX scaleY:(float)scaleY angle:(int)angle {
    return 0;
}

- (bool)updateStickerObject:(uint64_t)objId objType:(int)objType startTime:(int64_t)startTime endTime:(int64_t)endTime width:(int)width height:(int)height centerX:(float)centerX centerY:(float)centerY scaleX:(float)scaleX scaleY:(float)scaleY angle:(int)angle {
    return 0;
}

- (int)deleteStickerObject:(uint64_t)objId objType:(int)objType {
    return 0;
}

- (int)enableStickerObject:(uint64_t)objId objType:(int)objType enable:(bool)enable {
    return 0;
}

- (int)initRecord:(NSString *)fileName {
    return 0;
}

- (int)initRecordEX:(NSString *)fileName width:(int)width height:(int)height videoBitrate:(int)videoBitrate {
    return 0;
}

- (void)startRecord {

}

- (void)stopRecord {

}

- (int)setBackgroundMusicInsertTime:(long)insertTime {
    return 0;
}

- (long)setBackgroundMusicPath:(NSString *)musicPath {
    return 0;
}

- (BOOL)setBackgroundMusicRegion:(uint64_t)startTime endTime:(uint64_t)endTime {
    return NO;
}

- (BOOL)setOutputAudioVolume:(int)trackIdx volume:(float)volume {
    return NO;
}

+ (long)executeFfmpegCmd:(int)argc paramArray:(char **)argv {
    return 0;
}

- (BOOL)startRecord:(NSTimeInterval)startTime filePath:(NSString *)filePath type:(RecordType)type {
    self.recordFilePath = filePath;
    return NO;
}


- (void)endRecord:(NSTimeInterval)endTime {

}

@end


#import <IJKMediaFramework/st_mobile_common.h>
#import <IJKMediaFramework/st_mobile_license.h>
#import <CommonCrypto/CommonDigest.h>

@implementation Player (Utils)

//验证license
+ (BOOL)checkActiveCode {

    NSString *strLicensePath = [[NSBundle mainBundle] pathForResource:@"SENSEME" ofType:@"lic"];
    NSData *dataLicense = [NSData dataWithContentsOfFile:strLicensePath];

    NSString *strKeySHA1 = @"SENSEME";
    NSString *strKeyActiveCode = @"ACTIVE_CODE";

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *strStoredSHA1 = [userDefaults objectForKey:strKeySHA1];
    NSString *strLicenseSHA1 = [[self class] getSHA1StringWithData:dataLicense];

    st_result_t iRet = ST_OK;


    if (strStoredSHA1.length > 0 && [strLicenseSHA1 isEqualToString:strStoredSHA1]) {

        // Get current active code
        // In this app active code was stored in NSUserDefaults
        // It also can be stored in other places
        NSData *activeCodeData = [userDefaults objectForKey:strKeyActiveCode];

        // Check if current active code is available
#if CHECK_LICENSE_WITH_PATH

        // use file
        iRet = st_mobile_check_activecode(
                                          strLicensePath.UTF8String,
                                          (const char *)[activeCodeData bytes]
                                          );

#else

        // use buffer
        NSData *licenseData = [NSData dataWithContentsOfFile:strLicensePath];

        iRet = st_mobile_check_activecode_from_buffer(
                [licenseData bytes],
                (int) [licenseData length],
                [activeCodeData bytes]
        );
#endif


        if (ST_OK == iRet) {

            // check success
            return YES;
        }
    }

    //
    //1. check fail
    //2. new one
    //3. update
    //

    char active_code[1024];
    int active_code_len = 1024;

    // generate one
#if CHECK_LICENSE_WITH_PATH

    // use file
    iRet = st_mobile_generate_activecode(
                                         strLicensePath.UTF8String,
                                         active_code,
                                         &active_code_len
                                         );

#else

    // use buffer
    NSData *licenseData = [NSData dataWithContentsOfFile:strLicensePath];

    iRet = st_mobile_generate_activecode_from_buffer(
            [licenseData bytes],
            (int) [licenseData length],
            active_code,
            &active_code_len
    );
#endif

    if (ST_OK != iRet) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"使用 license 文件生成激活码时失败，可能是授权文件过期。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];

        [alert show];

        return NO;

    } else {

        // Store active code
        NSData *activeCodeData = [NSData dataWithBytes:active_code length:active_code_len];

        [userDefaults setObject:activeCodeData forKey:strKeyActiveCode];
        [userDefaults setObject:strLicenseSHA1 forKey:strKeySHA1];

        [userDefaults synchronize];
    }

    return YES;
}

+ (NSString *)getSHA1StringWithData:(NSData *)data {
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (unsigned int) data.length, digest);

    NSMutableString *strSHA1 = [NSMutableString string];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {

        [strSHA1 appendFormat:@"%02x", digest[i]];
    }

    return strSHA1;
}

@end
