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

@pro_strong HTHorizontalSelectionList       *   menuView;       //  分类导航
@pro_strong NSArray                         *   titleArr;       //  分类标题

@end
