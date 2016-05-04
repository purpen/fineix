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

@interface AddUrlViewController : FBPictureViewController <FBSearchDelegate, WebBtnSelectedDelegate, UIWebViewDelegate>

@pro_strong FBSearchView                    *   searchGoods;        //  搜索框
@pro_strong AddUrlView                      *   addUrlView;         //  购物网站分类
@pro_strong SearchGoodsView                 *   searchGoodsView;    //  搜索商品视图
@pro_strong NSString                        *   goodsUrl;           //  搜索链接
@pro_strong FindGoodsView                   *   findGoodsView;      //  找到商品
@pro_strong NSString                        *   goodsId;            //  商品id
@pro_strong FBRequest                       *   findGoodsRequest;

@end
