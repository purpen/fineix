//
//  MarkBrandsViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBSearchView.h"
#import "FBMenuView.h"
#import "THNAddGoodsBtn.h"
#import <SVProgressHUD/SVProgressHUD.h>

typedef void(^GetBrandAndGoodsInfoBlock)(NSString *brandTitle, NSString *goodsTitle);
@interface MarkBrandsViewController : FBPictureViewController <
    FBSearchDelegate,
    FBMenuViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_strong FBSearchView *searchGoods;  //  搜索框
@pro_strong UIButton *brandNameBtn;
@pro_strong UITableView *brandList;
@pro_strong UITableView *goodsList;
@pro_strong FBRequest *brandRequest;
@pro_strong FBRequest *goodsRequest;
@pro_strong THNAddGoodsBtn *addGoodBtn;

@pro_copy GetBrandAndGoodsInfoBlock getBrandAndGoodsInfoBlock;

@end
