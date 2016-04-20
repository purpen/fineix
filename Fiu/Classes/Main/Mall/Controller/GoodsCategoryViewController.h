//
//  GoodsCategoryViewController.h
//  Fiu
//
//  Created by FLYang on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import "FBMenuView.h"

@interface GoodsCategoryViewController : FBViewController <FBMenuViewDelegate>

@pro_strong FBMenuView                  *       categoryMenuView;       //  滑动导航栏
@pro_strong NSArray                     *       categoryTitleArr;       //  导航栏标题

@end
