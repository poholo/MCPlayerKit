//
//  MCMediaNotify.m
//
//  Created by mjc on 14-5-14.
//  Copyright (c) 2014年 Beijing Mooc Technology Center ltd. All rights reserved.
//

#import "MCMediaNotify.h"

@interface MCMediaNotify () {
    UILabel *textLabel;
}
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation MCMediaNotify

+ (MCMediaNotify *)sharedView {
    static dispatch_once_t once;
    static MCMediaNotify *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:CGRectMake(0, 0, 110, 90)];
    });
    return sharedView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0;
        self.layer.borderWidth = 0.0;
//        self.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    return self;
}

+ (void)showImage:(UIImage *)image message:(NSString *)message mediaNotifyType:(MediaNotifyType)mediaNotifyType inView:(UIView *)view {
    [[self sharedView] showImage:image message:message mediaNotifyType:mediaNotifyType inView:view duration:0];
}

+ (BOOL)isVisible {
    return ([self sharedView].alpha == 1);
}

+ (void)dismiss {
    if ([self isVisible]) {
        [[self sharedView] dismiss];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
//        self.alpha = 0;
    }                completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];


}

- (void)showImage:(UIImage *)image message:(NSString *)message mediaNotifyType:(MediaNotifyType)mediaNotifyType inView:(UIView *)view duration:(CGFloat)duration {

    UIView *containerView = (UIView *) [[self class] sharedView];
    if (!textLabel) {
        textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:12.f];
        textLabel.textColor = [UIColor whiteColor];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
    }


    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    containerView.opaque = NO;
    CGRect containerFrame = CGRectMake(0, 0, 110, 90);
    containerView.frame = containerFrame;

    containerView.center = CGPointMake(view.center.x, view.center.y);

    self.imageView.image = image;
    CGRect imageRect = _imageView.frame;
    imageRect.size = CGSizeMake(image.size.width, image.size.height);
    _imageView.frame = imageRect;
    self.imageView.center = CGPointMake(containerFrame.size.width / 2., 20 + CGRectGetHeight(self.imageView.frame) / 2);
    textLabel.backgroundColor = [UIColor clearColor];


//    CGSize labelSize = [message sizeWithFont:textLabel.font];
    CGRect labelFrame = CGRectMake(0, containerFrame.size.height - 14 - 20, containerFrame.size.width, 14);
    textLabel.frame = labelFrame;
    switch (mediaNotifyType) {
        case MediaProgress:
            textLabel.attributedText = [self getAttributedString:message];
            break;
        case MediaBrightness:
            textLabel.text = message;
            break;
        default:
            break;
    }


    if (!textLabel.superview) {
        [containerView addSubview:textLabel];


    }
    [view addSubview:containerView];

    self.alpha = 1;


}

- (UIImageView *)imageView {
    if (_imageView == nil)
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 96. / 2., 33.)];

    if (!_imageView.superview)
        [self addSubview:_imageView];

    return _imageView;
}

- (NSMutableAttributedString *)getAttributedString:(NSString *)text {
    //创建一个NSMutableAttributedString
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:text];

    [attriString addAttribute:(NSString *) NSForegroundColorAttributeName
                        value:(id) [UIColor whiteColor]
                        range:NSMakeRange(0, 5)];

    [attriString addAttribute:(NSString *) NSForegroundColorAttributeName
                        value:(id) [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1]
                        range:NSMakeRange(5, 6)];

//    NSRange rangeOfString = [text rangeOfString:text];
//    [attriString addAttribute:(NSString *)NSFontAttributeName
//                        value:(id)[UIFont systemFontOfSize:12.0f]
//                        range:rangeOfString];

    return attriString;
}

@end
