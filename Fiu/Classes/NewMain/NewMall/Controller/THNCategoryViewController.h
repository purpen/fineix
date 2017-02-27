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
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) NSString          *categoryId;
@property (nonatomic, strong) NSString          *vcTitle;
@property (nonatomic, strong) FBMenuView        *menuView;
@property (nonatomic, strong) FBRequest         *categoryRequest;
@property (nonatomic, strong) FBRequest         *subjectRequest;
@property (nonatomic, strong) UICollectionView  *goodsList;
@property (nonatomic, strong) FBRequest         *goodsListRequest;
@property (nonatomic, assign) NSInteger          currentpageNum;
@property (nonatomic, assign) NSInteger          totalPageNum;

@property (nonatomic, strong) NSMutableArray *goodsListMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;
@property (nonatomic, strong) NSMutableArray *categoryMarr;
@property (nonatomic, strong) NSMutableArray *categoryIdMarr;
@property (nonatomic, strong) NSMutableArray *subjectMarr;
@property (nonatomic, strong) NSMutableArray *subjectIdMarr;
@property (nonatomic, strong) NSMutableArray *subjectTypeMarr;

@end
