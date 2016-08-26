//
//  THNActiveRuleModel.m
//  Fiu
//
//  Created by THN-Dong on 16/8/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActiveRuleModel.h"

@implementation THNActiveRuleModel


-(CGFloat)cellHeight{
    if (!_cellHeight) {
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 10, MAXFLOAT);
        // 计算文字的高度
        CGFloat textH = [self.summary boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        _cellHeight = textH + 20 + 44;
    }
    return _cellHeight;
}


@end
