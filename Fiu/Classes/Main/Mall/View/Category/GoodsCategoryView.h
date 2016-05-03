//
//  GoodsCategoryView.h
//  Fiu
//
//  Created by FLYang on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CategoryTagRollView.h"

@interface GoodsCategoryView : UIScrollView <UITableViewDelegate, UITableViewDataSource>

@pro_strong UINavigationController              *   nav;
@pro_strong UITableView                         *   categoryTable;

/**
 *  创建商品列表
 */
- (void)addGoodsCategoryTableView:(NSArray *)number;

/**
 *  改变视图的偏移量
 */
- (void)changeContentOffSet:(NSInteger)index;

@end
