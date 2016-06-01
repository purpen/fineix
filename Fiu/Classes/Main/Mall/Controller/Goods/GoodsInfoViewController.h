//
//  GoodsInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBRollImages.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface GoodsInfoViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

/*
 *  商品类型
 *
 */
@pro_strong UIView                  *   buyView;            //  去购买&加入购物车视图
@pro_strong UITableView             *   goodsInfoTable;     //  商品详情
@pro_strong FBRollImages            *   rollImgView;        //  轮播图
@pro_strong NSString                *   goodsID;            //  商品id
@pro_strong NSString                *   thnGoodsId;

@pro_strong FBRequest               *   wantBuyRequest;
@pro_strong FBRequest               *   goodsInfoRequest;
@pro_strong FBRequest               *   reGoodsRequest;
@pro_strong FBRequest               *   goodsSceneRequest;
@pro_assign BOOL                        isWant;
- (void)networkWantBuyData;

@end
