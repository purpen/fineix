//
//  THNPromotionGoodsViewController.h
//  Fiu
//
//  Created by FLYang on 2017/5/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "FBMenuView.h"

@interface THNPromotionGoodsViewController : THNViewController <
    UITableViewDataSource,
    UITableViewDelegate,
    FBMenuViewDelegate
>

@property (nonatomic, strong) NSString *domainId;
//  分类
@property (nonatomic, strong) FBRequest *categoryRequest;
@property (nonatomic, strong) FBMenuView *menuView;
@property (nonatomic, strong) NSMutableArray *categoryMarr;
@property (nonatomic, strong) NSMutableArray *categoryIdMarr;
    
@property (nonatomic, strong) UITableView  *goodsTable;
@property (nonatomic, strong) FBRequest *goodsListRequest;
@property (nonatomic, assign) NSInteger goodsCurrentpageNum;
@property (nonatomic, assign) NSInteger goodsTotalPageNum;
@property (nonatomic, strong) NSMutableArray *goodsListMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;

@end
