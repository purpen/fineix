//
//  THNMarkGoodsViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBSearchView.h"
#import "THNAddGoodsBtn.h"
#import <SVProgressHUD/SVProgressHUD.h>

typedef void(^GetUserGoodsInfoBlock)(NSString *goodsTitle, NSString *goodsId);

@interface THNMarkGoodsViewController : FBPictureViewController <
    FBSearchDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@pro_strong FBSearchView *searchGoods;
@pro_strong FBRequest *goodsRequest;
@pro_strong THNAddGoodsBtn *addGoodBtn;
@pro_strong UITableView *goodsList;

@pro_copy GetUserGoodsInfoBlock getUserGoodsInfoBlock;

@end
