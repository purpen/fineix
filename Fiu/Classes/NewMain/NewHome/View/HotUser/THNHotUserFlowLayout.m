//
//  THNHotUserFlowLayout.m
//  Fiu
//
//  Created by FLYang on 16/9/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHotUserFlowLayout.h"

@implementation THNHotUserFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(140, 190);
        self.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
        self.minimumLineSpacing = 5.0f;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

@end
