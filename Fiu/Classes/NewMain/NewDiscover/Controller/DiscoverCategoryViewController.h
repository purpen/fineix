//
//  DiscoverCategoryViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "FBSegmentView.h"
#import "MJRefresh.h"

@interface DiscoverCategoryViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    FBSegmentViewDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, strong) NSString *vcTitle;
@property (nonatomic, strong) FBSegmentView *menuView;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) FBRequest *likeSceneRequest;
@property (nonatomic, strong) FBRequest *cancelLikeRequest;
@property (nonatomic, strong) FBRequest *subscribeCountRequest;
@property (nonatomic, strong) FBRequest *suThemeRequest;
@property (nonatomic, strong) FBRequest *sceneListRequest;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;
@property (nonatomic, strong) NSMutableArray *sceneListMarr;
@property (nonatomic, strong) NSMutableArray *sceneIdMarr;
@property (nonatomic, strong) NSMutableArray *userIdMarr;
@property (nonatomic, strong) NSMutableArray *commentsMarr;
@property (nonatomic, strong) UICollectionView *sceneList;

@end
