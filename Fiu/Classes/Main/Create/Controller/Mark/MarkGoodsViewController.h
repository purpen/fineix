//
//  MarkGoodsViewController.h
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBSearchView.h"
#import "FBMenuView.h"

@interface MarkGoodsViewController : FBPictureViewController <FBSearchDelegate, FBMenuViewDelegate>

@pro_strong FBMenuView                  *       categoryMenuView;       //  滑动导航栏
@pro_strong NSArray                     *       categoryTitleArr;       //  导航栏标题
@pro_strong FBSearchView                *       searchGoods;            //  搜索框


@end
