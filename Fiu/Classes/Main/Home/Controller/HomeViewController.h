//
//  HomeViewController.h
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBViewController.h"
#import "Fiu.h"

@interface HomeViewController : FBViewController <FBNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

@pro_strong UITableView             *   homeTableView;          //  加载首页场景的表格
@pro_assign BOOL                        rollDown;               //  是否下拉
@pro_assign CGFloat                     lastContentOffset;      //  滚动的方向

@end
