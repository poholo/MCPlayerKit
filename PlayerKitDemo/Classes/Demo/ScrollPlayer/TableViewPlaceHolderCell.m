//
// Created by majiancheng on 08/01/2018.
// Copyright (c) 2018 majiancheng. All rights reserved.
//

#import "TableViewPlaceHolderCell.h"
#import "View+MASAdditions.h"

@interface TableViewPlaceHolderCell ()

@property(nonatomic, strong) UILabel *titleLabel;

@end


@implementation TableViewPlaceHolderCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(15);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"Test placeHolderCell";
    }
    return _titleLabel;
}

@end
