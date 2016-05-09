//
//  TagFlowLayout.m
//  Fiu
//
//  Created by FLYang on 16/5/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "TagFlowLayout.h"

@implementation TagFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.max = 5.0f;
    }
    return self;
}

#pragma mark - Cell折行
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
    for (NSInteger idx = 1; idx < attributes.count; ++ idx) {
        UICollectionViewLayoutAttributes * cur = attributes[idx];
        UICollectionViewLayoutAttributes * pre = attributes[idx - 1];
        
        NSInteger origin = CGRectGetMaxX(pre.frame);
        CGFloat targetX = origin + self.max;
        if (CGRectGetMinX(cur.frame) > targetX) {
            if (targetX + CGRectGetWidth(cur.frame) < self.collectionViewContentSize.width) {
                CGRect frame = cur.frame;
                frame.origin.x = targetX;
                cur.frame = frame;
            }
        }
    }
    
    return attributes;
}

@end
