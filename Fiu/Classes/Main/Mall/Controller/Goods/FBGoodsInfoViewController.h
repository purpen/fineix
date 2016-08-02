//
//  FBGoodsInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBRollImages.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface FBGoodsInfoViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@pro_strong FBRollImages    *   rollImgView;        //  轮播图
@pro_strong UITableView     *   goodsTable;
@pro_strong UIView          *   buyView;
@pro_strong UIButton        *   buyingBtn;
@pro_strong UIButton        *   addCarBtn;
@pro_strong UIWebView       *   goodsInfoWeb;
@pro_strong UILabel         *   pullLab;

@pro_strong NSString        *   goodsID;            //  商品id
@pro_strong FBRequest       *   goodsInfoRequest;
@pro_strong FBRequest       *   commentRequest;
@pro_strong FBRequest       *   addCarRequest;

@end
