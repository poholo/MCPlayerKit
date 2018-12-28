//
// Created by imooc on 16/5/5.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlayerLoadingView : UIView {
    UIImageView *_loadingImageView;         ///< loading 图
}

@property(nonatomic, strong) UIImageView *loadingImageView;

- (void)releaseSpace;

- (void)startShowBg;

/** loading有背景图 */
- (void)startRotatingAndDefaultBg;

/** loading无背景图 */
- (void)startRotatingNoDefaultBg;

- (void)endRotating;

- (void)updatePlayerPicture:(NSString *)url;

- (void)hiddenRotateLoadingView:(BOOL)hiddenRotateLoadingView;
@end
