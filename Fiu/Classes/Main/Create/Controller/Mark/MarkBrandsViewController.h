//
//  MarkBrandsViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBSearchView.h"
#import "THNAddGoodsBtn.h"
#import <SVProgressHUD/SVProgressHUD.h>

typedef void(^GetBrandAndGoodsInfoBlock)(NSString *brandTitle, NSString *brandId, NSString *goodsTitle, NSString *goodsId);
@interface MarkBrandsViewController : FBPictureViewController <
    FBSearchDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) FBSearchView *searchGoods;  //  搜索框
@property (nonatomic, strong) UIButton *brandNameBtn;
@property (nonatomic, strong) UITableView *brandList;
@property (nonatomic, strong) UITableView *goodsList;
@property (nonatomic, strong) FBRequest *brandRequest;
@property (nonatomic, strong) FBRequest *goodsRequest;
@property (nonatomic, strong) THNAddGoodsBtn *addGoodBtn;

@property (nonatomic, weak) GetBrandAndGoodsInfoBlock getBrandAndGoodsInfoBlock;

@end
