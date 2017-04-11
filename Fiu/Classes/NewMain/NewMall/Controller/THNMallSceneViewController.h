//
//  THNBuySceneViewController.h
//  Fiu
//
//  Created by FLYang on 2017/4/11.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNMallSceneViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) FBRequest *sceneListRequest;
@property (nonatomic, assign) NSInteger sceneCurrentpage;
@property (nonatomic, assign) NSInteger sceneTotalPage;
@property (nonatomic, strong) FBRequest *likeSceneRequest;
@property (nonatomic, strong) FBRequest *cancelLikeRequest;
@property (nonatomic, strong) FBRequest *favoriteRequest;
@property (nonatomic, strong) FBRequest *cancelFavoriteRequest;
@property (nonatomic, strong) FBRequest *deleteRequest;
@property (nonatomic, strong) UITableView *sceneTable;
@property (nonatomic, strong) NSMutableArray *sceneListMarr;
@property (nonatomic, strong) NSMutableArray *sceneIdMarr;
@property (nonatomic, strong) NSMutableArray *userIdMarr;

/**
 子视图的位置
 */
@property (nonatomic, assign) NSInteger index;

@end
