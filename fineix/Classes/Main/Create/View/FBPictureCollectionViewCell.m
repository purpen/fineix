//
//  FBPictureCollectionViewCell.m
//  fineix
//
//  Created by FLYang on 16/2/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureCollectionViewCell.h"

@implementation FBPictureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

#pragma mark - 相册照片
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.borderColor = [UIColor colorWithHexString:color alpha:1].CGColor;
    }
    return _imageView;
}

#pragma mark - 选择照片时的边框状态
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.imageView.layer.borderWidth = selected ? 3 : 0;
}

@end
