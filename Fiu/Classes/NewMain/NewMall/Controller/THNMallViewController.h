//
//  THNMallViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "GroupHeaderView.h"
#import "CategoryMenuView.h"
#import "FBMenuView.h"

@interface THNMallViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    FBMenuViewDelegate
>

/**
 好货滚动容器
 */
@property (nonatomic, strong) UIScrollView *mallRollView;

//  好货推荐专题
@property (nonatomic, strong) FBRequest *categoryRequest;


//  好货分类
@property (nonatomic, strong) FBMenuView *menuView;
@property (nonatomic, strong) NSMutableArray *categoryMarr;
@property (nonatomic, strong) NSMutableArray *categoryIdMarr;




@end
