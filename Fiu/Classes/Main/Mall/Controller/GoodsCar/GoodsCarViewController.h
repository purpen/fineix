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

@interface GoodsCarViewController : FBViewController <UITableViewDelegate, UITableViewDataSource>

@pro_strong FBRequest               *   goodsListRequest;
@pro_strong FBRequest               *   stockRequest;
@pro_strong FBRequest               *   deleteRequest;
@pro_strong BuyCarDefault           *   defaultCarView;     //  没有商品的购物车背景

@pro_strong UITableView             *   carItemTabel;
@pro_strong UIButton                *   editBtn;
@pro_strong UIView                  *   bottomView;
@pro_strong UIButton                *   goPayBtn;
@pro_strong UIButton                *   chooseAllBtn;
@pro_assign CGFloat                     payPrice;
@pro_strong UILabel                 *   sumPrice;
@pro_strong UILabel                 *   sumLab;


@end
