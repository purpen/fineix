//
//  PraisedViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@interface PraisedViewController : FBViewController

@pro_strong FBRequest               *   sceneListRequest;
@pro_assign NSInteger                   currentpageNum;
@pro_assign NSInteger                   totalPageNum;

@pro_strong UITableView             *   homeTableView;          //  加载首页场景的表格
@pro_assign BOOL                        rollDown;               //  是否下拉
@pro_assign CGFloat                     lastContentOffset;      //  滚动的方向

@end
