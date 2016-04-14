//
//  SearchResultsRollView.h
//  Fiu
//
//  Created by FLYang on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface SearchResultsRollView : UIScrollView <UITableViewDataSource, UITableViewDelegate>

@pro_strong UITableView             *   fSceneTable;     //  情景列表
@pro_strong UITableView             *   sceneTable;      //  场景列表
@pro_strong UITableView             *   userTable;       //  用户列表
@pro_strong UITableView             *   goodsTable;      //  商品列表

- (void)setSearchResultTable:(NSArray *)tableArr;

@end
