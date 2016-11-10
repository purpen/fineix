//
//  THNAdjustView.h
//  Fiu
//
//  Created by FLYang on 2016/11/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNAdjustView : UIView <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong UICollectionView *adjustView;
@pro_strong NSArray *titleArr;

@end
