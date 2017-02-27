//
//  GoodsCarViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "BuyCarDefault.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "THNMacro.h"
#import "THNCarServiceTextView.h"

@interface GoodsCarViewController : FBViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, strong) FBRequest               *stockRequest;
@property (nonatomic, strong) FBRequest               *deleteRequest;
@property (nonatomic, strong) FBRequest               *editCarItemRequest;
@property (nonatomic, strong) FBRequest               *carPayRequest;
@property (nonatomic, strong) BuyCarDefault           *defaultCarView;     //  没有商品的购物车背景

@property (nonatomic, strong) THNCarServiceTextView *headerTextView;
@property (nonatomic, strong) UITableView           *carItemTabel;
@property (nonatomic, strong) UIButton              *editBtn;
@property (nonatomic, strong) UIView                *bottomView;
@property (nonatomic, strong) UIButton              *goPayBtn;
@property (nonatomic, strong) UIButton              *chooseAllBtn;
@property (nonatomic, assign) CGFloat               payPrice;
@property (nonatomic, strong) UILabel               *sumPrice;
@property (nonatomic, strong) UILabel               *sumLab;
@property (nonatomic, strong) UIView                *haveJDGoodsLab;

@property (nonatomic, strong) NSMutableArray        *carItemList;
@property (nonatomic, strong) NSMutableArray        *stockList;
@property (nonatomic, strong) NSMutableArray        *goodsIdList;
@property (nonatomic, strong) NSMutableArray        *chooseItems;
@property (nonatomic, strong) NSMutableArray        *priceMarr;
@property (nonatomic, strong) NSMutableArray        *carGoodsCount;

@property (nonatomic, strong) UICollectionView      *productList;
@property (nonatomic, strong) FBRequest             *productListRequest;
@property (nonatomic, strong) NSMutableArray        *productDataMarr;
@property (nonatomic, strong) NSMutableArray        *productIdMarr;

/**
 跳转购物车的入口，nav还是tabBar
 */
@property (nonatomic, assign) NSInteger              openType;

@end
