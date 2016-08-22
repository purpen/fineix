//
//  THNCategoryViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "MJRefresh.h"

@interface THNCategoryViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong NSString *categoryId;
@pro_strong NSString *vcTitle;

@pro_strong FBRequest *goodsListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;
@pro_strong NSMutableArray *goodsListMarr;
@pro_strong NSMutableArray *goodsIdMarr;
@pro_strong NSMutableArray *goodsMarr;
@pro_strong UICollectionView *goodsList;

@end
