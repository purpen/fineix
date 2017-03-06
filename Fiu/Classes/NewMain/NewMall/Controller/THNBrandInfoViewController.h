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

@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) UICollectionView *brandCollection;
@property (nonatomic, strong) FBRequest *brandRequest;
@property (nonatomic, strong) FBRequest *brandGoodsRequest;
@property (nonatomic, strong) FBRequest *sceneRequest;
@property (nonatomic, strong) FBRequest *likeSceneRequest;
@property (nonatomic, strong) FBRequest *cancelLikeRequest;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;
@property (nonatomic, strong) NSMutableArray *goodsListMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;
@property (nonatomic, strong) NSMutableArray *sceneListMarr;
@property (nonatomic, strong) NSMutableArray *sceneIdMarr;

@end
