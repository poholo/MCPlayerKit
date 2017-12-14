//
//  PlayerView.h
//  WaQuVideo
//
//  Created by majiancheng on 2017/3/17.
//  Copyright © 2017年 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlayerViewDelegate.h"
#import "PlayerConfig.h"

@protocol PlayerViewControlDelegate;


/**
 *  播放器UI父类
 */
@interface PlayerBaseView : UIView <PlayerViewDelegate> {
    UIView *_drawView;
    CALayer *_drawLayer;
    PlayerStyle _playerStyle;
}


@property(nonatomic, assign) PlayerStyle playerStyle;
@property(nonatomic, weak) id <PlayerViewControlDelegate> playerControlDelegate;

- (void)prepareUI;

@end
