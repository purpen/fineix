//
//  THNBrandInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/9/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "FBSegmentView.h"

@interface THNBrandInfoViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    FBSegmentViewDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong NSString *brandId;
@pro_strong UICollectionView *brandCollection;
@pro_strong FBRequest *brandRequest;
@pro_strong FBRequest *brandGoodsRequest;
@pro_strong FBRequest *sceneRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;
@pro_strong NSMutableArray *goodsListMarr;
@pro_strong NSMutableArray *goodsIdMarr;
@pro_strong NSMutableArray *sceneListMarr;
@pro_strong NSMutableArray *sceneIdMarr;

@end
