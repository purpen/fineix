//
//  SearchViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "HTHorizontalSelectionList.h"

@interface SearchViewController : FBViewController <HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>

@pro_strong HTHorizontalSelectionList       *   searchMenu;         //  分类导航栏
@pro_strong NSArray                         *   menuTitle;          //  分类信息标题

@end
