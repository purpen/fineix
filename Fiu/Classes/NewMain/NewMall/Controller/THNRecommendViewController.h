//
//  THNRecommendViewController.h
//  Fiu
//
//  Created by FLYang on 2017/4/11.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNRecommendViewController : THNViewController <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *recommendList;

/**
 最新商品
 */
@property (nonatomic, strong) NSMutableArray *newestGoodsMarr;
@property (nonatomic, strong) FBRequest *newestGoodsRequest;

/**
 热门商品
 */
@property (nonatomic, strong) FBRequest *hotGoodsRequest;
@property (nonatomic, strong) NSMutableArray *hotGoodsMarr;

/**
 推荐专题
 */
@property (nonatomic, strong) FBRequest *subjectRequest;
@property (nonatomic, assign) NSInteger currentPageNum;
@property (nonatomic, assign) NSInteger totalPageNum;
@property (nonatomic, strong) NSMutableArray *subjectMarr;
@property (nonatomic, strong) NSMutableArray *subjectIdMarr;
@property (nonatomic, strong) NSMutableArray *subjectTypeMarr;

@end
