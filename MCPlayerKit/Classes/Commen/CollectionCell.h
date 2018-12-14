//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dto;


@interface CollectionCell : UICollectionViewCell

- (void)loadData:(Dto *)dto;

+ (NSString *)identifier;

+ (CGSize)size;

@end