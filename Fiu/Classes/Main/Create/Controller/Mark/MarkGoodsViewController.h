//
//  MarkGoodsViewController.h
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBSearchView.h"
#import "FBMenuView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>

typedef void(^GetImgBlock)(NSString * imgUrl, NSString * title, NSString * price, NSString * ids, CGFloat imgW, CGFloat imgH);

@interface MarkGoodsViewController : FBPictureViewController <FBSearchDelegate, FBMenuViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) FBRequest               *   markGoodsRequest;
@property (nonatomic, strong) FBRequest               *   goodsDataRequest;
@property (nonatomic, strong) FBRequest               *   searchRequest;
@property (nonatomic, strong) FBRequest               *   getImgRequest;
@property (nonatomic, assign) NSInteger                   currentpageNum;
@property (nonatomic, assign) NSInteger                   totalPageNum;
@property (nonatomic, assign) NSInteger                   searchCurrentpageNum;
@property (nonatomic, assign) NSInteger                   searchTotalPageNum;

@property (nonatomic, strong) UICollectionView        *   searchListView;
@property (nonatomic, strong) UICollectionView        *   goodsListView;          //  商品列表
@property (nonatomic, strong) FBMenuView              *   categoryMenuView;       //  滑动导航栏
@property (nonatomic, strong) FBSearchView            *   searchGoods;            //  搜索框

@property (nonatomic, strong) GetImgBlock getImgBlock;

@end
