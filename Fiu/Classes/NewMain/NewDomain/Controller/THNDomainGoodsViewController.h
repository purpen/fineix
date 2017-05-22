//
//  THNDomainGoodsViewController.h
//  Fiu
//
//  Created by FLYang on 2017/5/18.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNDomainGoodsViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>
    
@property (nonatomic, strong) NSString *domainId;
@property (nonatomic, strong) FBRequest *goodsRequests;
@property (nonatomic, strong) FBRequest *delegateRequest;
@property (nonatomic, strong) UITableView *goodsTable;
@property (nonatomic, assign) NSInteger goodsCurrentpageNum;
@property (nonatomic, assign) NSInteger goodsTotalPageNum;
@property (nonatomic, strong) NSMutableArray *goodsListMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;
@property (nonatomic, strong) NSMutableArray *idMarr;
    
@end
