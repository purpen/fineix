//
//  THNHotUserView.h
//  Fiu
//
//  Created by FLYang on 16/9/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "HotUserListUser.h"

@interface THNHotUserView : UICollectionView <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@pro_strong UINavigationController *nav;
@pro_strong NSMutableArray *hotUserMarr;
@pro_strong NSMutableArray *hotUserIdMarr;

- (void)thn_setHotUserListData:(NSMutableArray *)hotUserMarr;

@end
