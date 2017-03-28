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

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) FBRequest *searchListRequest;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;

@property (nonatomic, strong) UILabel *noneLab;
@property (nonatomic, strong) UICollectionView *goodsList;
@property (nonatomic, strong) NSMutableArray *goodsListMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;

- (void)searchAgain:(NSString *)keyword;

@end
