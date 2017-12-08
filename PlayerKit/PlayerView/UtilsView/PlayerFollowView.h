//
// Created by majiancheng on 2017/5/17.
// Copyright (c) 2017 mjc inc. All rights reserved.
//

#import <UIKit/UIKit.h>



@class Video;
@class PlaylistInfoDto;
@class FollowButton;

typedef NS_ENUM(NSInteger, FollowType) {
    FollowUnknow,
    FollowAnchor,
    FollowPlayList,
    FollowTopic
};

@protocol PlayerFollowViewDelegate <NSObject>

- (void)updateLikeSection0VideoCard:(FollowButton *)followButton followType:(FollowType)followType;

- (id)requestFolllowData;

- (BOOL)updateFolowSelected;

@end

@interface PlayerFollowView : UIView

- (void)releaseSpace;

@property (nonatomic, weak) id<PlayerFollowViewDelegate> delegate;

- (void)updateData:(id)data;

- (void)showFollowPlayerViewAnimaiton:(BOOL)animation;

- (void)hiddenFollowPlayerViewAnimation:(BOOL)animaiton;

- (void)updateSeleted:(BOOL)isSelected;

@end