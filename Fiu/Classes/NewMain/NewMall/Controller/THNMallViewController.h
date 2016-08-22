//
//  THNMallViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "GroupHeaderView.h"
#import "FBCategoryView.h"

@interface THNMallViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@pro_strong FBRequest *categoryRequest;
@pro_strong FBRequest *mallListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;
@pro_strong UICollectionView *mallList;
@pro_strong NSMutableArray *categoryMarr;
@pro_strong NSMutableArray *goodsDataMarr;

@end
