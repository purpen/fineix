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


@interface GoodsCategoryViewController : FBViewController <FBNavigationBarItemsDelegate, FBMenuViewDelegate, UIScrollViewDelegate, CategotyTagBtnSelectedDelegate>

@pro_strong NSString                    *       categoryId;             //  分类id
@pro_strong NSArray                     *       categoryTagId;          //  分类标签id
@pro_strong FBMenuView                  *       categoryMenuView;       //  滑动导航栏
@pro_strong NSArray                     *       categoryTitleArr;       //  导航栏标题
@pro_strong NSArray                     *       tagTitleArr;            //  分类标签标题
@pro_strong GoodsCategoryView           *       goodsCategoryView;      //  商品列表视图
@pro_strong CategoryTagRollView         *       headerView;             //  分类标签视图


@end
