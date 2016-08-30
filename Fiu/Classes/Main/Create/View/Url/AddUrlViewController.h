//
//  AddUrlViewController.h
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBSearchView.h"
#import "AddUrlView.h"
#import "SearchGoodsView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FindGoodsView.h"

typedef void(^FindGoodsDataBlock)(NSString * title, NSString * price, NSString * ids);
typedef void(^UserAddGoodsData)(NSDictionary * data);

@interface AddUrlViewController : FBPictureViewController <FBSearchDelegate, WebBtnSelectedDelegate, UIWebViewDelegate>

@pro_strong FBSearchView                    *   searchGoods;        //  搜索框
@pro_strong AddUrlView                      *   addUrlView;         //  购物网站分类
@pro_strong SearchGoodsView                 *   searchGoodsView;    //  搜索商品视图
@pro_strong FindGoodsView                   *   findGoodsView;      //  找到商品
@pro_strong FBRequest                       *   findGoodsRequest;
@pro_strong FBRequest                       *   addGoodsRequest;

@pro_strong NSString            *   goodsTitle;
@pro_strong NSString            *   goodsSalePrice;
@pro_strong NSString            *   goodsMarketPrice;
@pro_strong NSString            *   goodsUrl;
@pro_strong NSString            *   goodsId;
@pro_strong NSString            *   goodsImg;

@pro_copy FindGoodsDataBlock    findGodosBlock;
@pro_copy UserAddGoodsData      userAddGoodsBlock;

@end
