//
//  THNProductModel.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNProductModel.h"

@implementation THNProductModel

-(CGFloat)cellHeight{
    if (!_cellHeight) {
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 10, MAXFLOAT);
        // 计算文字的高度
        CGFloat textH = [self.summary boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        _cellHeight = textH + 10 + 15 + 211 + 44 + 10 + 18 + 5;
    }
    return _cellHeight;
}

@end
