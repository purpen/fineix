//
//  SearchSceneViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "MJRefresh.h"

@interface SearchSceneViewController : FBViewController <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@pro_assign NSInteger index;
@pro_strong FBRequest *likeSceneRequest;
@pro_strong FBRequest *cancelLikeRequest;
@pro_strong FBRequest *searchListRequest;
@pro_assign NSInteger currentpageNum;
@pro_assign NSInteger totalPageNum;

@pro_strong UILabel *noneLab;
@pro_strong UICollectionView *sceneList;
@pro_strong NSMutableArray *searchSceneListMarr;
@pro_strong NSMutableArray *searchSceneIdMarr;

- (void)searchAgain:(NSString *)keyword;

@end
