//
//  MCMediaNotify.h

//
//  Created by mjc on 14-5-14.
//  Copyright (c) 2014年 mjc Technology Center ltd. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MCMediaNotifyType) {
    MCMediaProgress = 1, //视频前进后退进度
    MCMediaBrightness, //视频亮度 调节
};


@interface MCMediaNotify : UIView


+ (void)showImage:(UIImage *)image message:(NSString *)message mediaNotifyType:(MCMediaNotifyType)mediaNotifyType inView:(UIView *)view;

+ (void)dismiss;

@end
