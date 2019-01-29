//
// Created by majiancheng on 2018/1/3.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "CollectionCell.h"
#import "Dto.h"


@implementation CollectionCell {

}

- (void)loadData:(Dto *)dto {

}

+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

+ (CGSize)size {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
}

@end