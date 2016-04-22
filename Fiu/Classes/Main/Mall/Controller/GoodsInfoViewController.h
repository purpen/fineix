//
//  GoodsInfoViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBRollImages.h"

@interface GoodsInfoViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

/*
 *  商品类型
 *
 */
@pro_assign NSInteger                   goodsType;
@pro_strong UIView                  *   buyView;            //  去购买&加入购物车视图
@pro_strong UITableView             *   goodsInfoTable;     //  商品详情
@pro_strong FBRollImages            *   rollImgView;        //  轮播图

@end
