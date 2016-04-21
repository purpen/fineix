//
//  GoodsCategoryViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBMenuView.h"
#import "GoodsCategoryView.h"

@interface GoodsCategoryViewController : FBViewController <FBNavigationBarItemsDelegate, FBMenuViewDelegate, UIScrollViewDelegate>

@pro_strong FBMenuView                  *       categoryMenuView;       //  滑动导航栏
@pro_strong NSArray                     *       categoryTitleArr;       //  导航栏标题
@pro_strong GoodsCategoryView           *       goodsCategoryView;      //  商品列表视图

@end
