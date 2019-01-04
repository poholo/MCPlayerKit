//
// Created by imooc on 16/5/5.
// Copyright (c) 2016 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCPlayerLoadingView : UIView

/** loading有背景图 */
- (void)startRotating;

/** loading无背景图 */
- (void)startRotatingNoBg;

- (void)endRotating;

- (void)updatePlayerPicture:(NSString *)url;

- (void)hiddenRotateLoadingView:(BOOL)hiddenRotateLoadingView;

@end
