//
//  GoodsImgFlowLayout.m
//  Fiu
//
//  Created by FLYang on 16/5/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsImgFlowLayout.h"

#define __NSABS_IMPL__(A,L) ({ __typeof__(A) __NSX_PASTE__(__a,L) = (A); (__NSX_PASTE__(__a,L) < 0) ? - __NSX_PASTE__(__a,L) : __NSX_PASTE__(__a,L); })
#define ABS(A) __NSABS_IMPL__(A,__COUNTER__)

@implementation GoodsImgFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 初始化参数
- (void)prepareLayout {
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.itemSize = CGSizeMake(220, 150);
    
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 50);
}

#pragma mark - 初始化Cell布局
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * arr = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes * attributes in arr) {
        CGFloat center = ABS(centerX - attributes.center.x);
        CGFloat scale = 1 - center / (self.collectionView.frame.size.width + self.itemSize.width);
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return arr;
}

#pragma mark - 刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - 滚动时的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect rect;
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.frame.size;
    
    NSArray * arr = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat min = MAXFLOAT;
    for (UICollectionViewLayoutAttributes * attributes in arr) {
        if (ABS(min) > ABS(attributes.center.x - centerX)) {
            min = attributes.center.x - centerX;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + min, proposedContentOffset.y);
}

@end
