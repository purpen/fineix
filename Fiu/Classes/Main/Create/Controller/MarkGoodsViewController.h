//
//  MarkGoodsViewController.h
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "HTHorizontalSelectionList.h"
#import "FBSearchView.h"

@interface MarkGoodsViewController : FBPictureViewController <FBSearchDelegate, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>

@pro_strong FBSearchView                    *   searchGoods;        //  搜索框
@pro_strong HTHorizontalSelectionList       *   menuView;           //  分类导航栏
@pro_strong NSArray                         *   menuTitle;          //  分类信息标题

@end
