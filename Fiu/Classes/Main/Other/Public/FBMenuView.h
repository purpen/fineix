//
//  FBMenuView.h
//  Fiu
//
//  Created by FLYang on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTHorizontalSelectionList.h"
#import "Fiu.h"

@interface FBMenuView : UIView <HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>

@pro_strong HTHorizontalSelectionList       *   menuView;         //  分类导航栏
@pro_strong NSMutableArray                  *   menuTitle;          //  分类信息标题

@end
