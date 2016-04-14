//
//  TurnPageLayout.m
//  test5
//
//  Created by THN-Dong on 16/4/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "TurnPageLayout.h"

#define ACTIVE_DISTANCE 200
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth   ([UIScreen mainScreen].bounds.size.width)

@implementation TurnPageLayout

- (instancetype)init {
    if (self = [super init]) {
        [self initDefault];
    }
    return self;
}

//默认设置
- (void)initDefault {
    self.itemSize = CGSizeMake(250/667.0*kScreenHeight, 450/667.0*kScreenHeight);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 30/667.0*kScreenHeight;
    self.sectionInset = UIEdgeInsetsMake(-20, 30, 0, 30);
    self.zoomFactor = 0.1;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    return YES;
}

//实现放大缩小效果
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *tempAry = [super layoutAttributesForElementsInRect:rect];
    NSArray *array = [[NSArray alloc] initWithArray:tempAry copyItems:YES];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            distance = ABS(distance);
            if (distance < (0.5*kScreenWidth + self.itemSize.width)) {
                CGFloat zoom = 1 + self.zoomFactor * (1 - distance / ACTIVE_DISTANCE);
                //3D缩放
                //                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                //                attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0 , -zoom * 25, 0);
                
                //2D缩放.貌似和3D没有区别
                attributes.transform = CGAffineTransformMakeScale(zoom, zoom);
                
                //                attributes.alpha = zoom - self.zoomFactor;
            }
        }
    }
    return array;
}

//实现分页效果,滚动结束后让item居中
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat centerX = proposedContentOffset.x + 0.5*self.collectionView.bounds.size.width;
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - centerX) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - centerX;
        }
        
    }
    CGPoint point = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    return point;
}


@end
