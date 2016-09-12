//
//  SearchGoodsViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "MJRefresh.h"

@interface SearchGoodsViewController : FBViewController <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_assign NSInteger index;
@pro_strong FBRequest *searchListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;

@pro_strong UILabel *noneLab;
@pro_strong UICollectionView *goodsList;
@pro_strong NSMutableArray *goodsListMarr;
@pro_strong NSMutableArray *goodsIdMarr;

- (void)searchAgain:(NSString *)keyword;

@end
