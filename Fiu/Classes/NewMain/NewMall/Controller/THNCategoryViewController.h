//
//  THNCategoryViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "MJRefresh.h"
#import "FBMenuView.h"

@interface THNCategoryViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    FBMenuViewDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_strong NSString *categoryId;
@pro_strong NSString *vcTitle;
//@pro_strong FBMenuView *menuView;
@pro_strong UICollectionView *goodsList;

@pro_strong FBRequest *childTagsRequest;
@pro_strong FBRequest *goodsListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;

@pro_strong NSMutableArray *goodsListMarr;
@pro_strong NSMutableArray *goodsIdMarr;
@pro_strong NSMutableArray *childTagsList;
@pro_strong NSMutableArray *childTagsId;

@end
