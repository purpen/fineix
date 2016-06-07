//
//  GoodsCategoryViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBMenuView.h"
#import "CategoryTagRollView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>

@interface GoodsCategoryViewController : FBViewController <FBNavigationBarItemsDelegate, FBMenuViewDelegate, UIScrollViewDelegate, CategotyTagBtnSelectedDelegate, UITableViewDelegate, UITableViewDataSource>

@pro_strong FBRequest                   *       childTagsRequest;       //  子分类
@pro_strong FBRequest                   *       goodsListRequest;       //  商品分类
@pro_assign NSInteger                           currentpageNum;
@pro_assign NSInteger                           totalPageNum;

@pro_strong NSString                    *       categoryId;             //  分类id
@pro_strong NSString                    *       tagId;                  //  子分类id
@pro_strong NSMutableArray              *       categoryIdMarr;         //  父分类id
@pro_strong NSMutableArray              *       idMarr;                 //  获取商品分类的id
@pro_strong FBMenuView                  *       categoryMenuView;       //  滑动导航栏
@pro_strong NSMutableArray              *       categoryTitleArr;       //  导航栏标题
@pro_strong NSArray                     *       tagTitleArr;            //  分类标签标题
@pro_strong CategoryTagRollView         *       headerView;             //  分类标签视图
@pro_strong UITableView                 *       goodsListTable;         //  商品列表

- (void)showCategoryTag:(NSInteger)index;

@end
