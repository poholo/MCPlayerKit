//
//  PlayerView.h
//  WaQuVideo
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  播放器UI父类
 */
@interface PlayerBaseView : UIView {
@public
    __weak CALayer *_drawLayer;
    __weak UIView *_glView;
}

- (void)prepareUI;

- (void)updatePlayerView:(UIView *)drawPlayerView;

- (void)updatePlayerLayer:(CALayer *)layer;

@end
