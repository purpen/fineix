//
//  THNMallViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "GroupHeaderView.h"
#import "CategoryMenuView.h"
#import "MJRefresh.h"
#import "FBRefresh.h"
#import "FBMenuView.h"

@interface THNMallViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    FBMenuViewDelegate
>

@property (nonatomic, strong) FBRequest *categoryRequest;
@property (nonatomic, strong) FBRequest *mallListRequest;
@property (nonatomic, strong) FBRequest *subjectRequest;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;
@property (nonatomic, strong) UICollectionView *mallList;
@property (nonatomic, strong) NSMutableArray *goodsDataMarr;
@property (nonatomic, strong) NSMutableArray *subjectMarr;
@property (nonatomic, strong) NSMutableArray *subjectIdMarr;
@property (nonatomic, strong) NSMutableArray *subjectTypeMarr;
@property (nonatomic, strong) CategoryMenuView *topCategoryView;
//@property (nonatomic, strong) UIButton *goTopBtn;

@property (nonatomic, strong) FBMenuView *menuView;
@property (nonatomic, strong) NSMutableArray *categoryMarr;
@property (nonatomic, strong) NSMutableArray *categoryIdMarr;

@end
