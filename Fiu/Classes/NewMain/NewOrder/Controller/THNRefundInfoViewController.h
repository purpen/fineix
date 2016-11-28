//
//  THNRefundInfoViewController.h
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "ProductInfoModel.h"
#import "THNStateHeaderView.h"

@interface THNRefundInfoViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *refundId;
@property (nonatomic, strong) FBRequest *refundRequest;
@property (nonatomic, strong) UITableView *infoTable;
@property (nonatomic, strong) ProductInfoModel *productModel;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) THNStateHeaderView *headerView;

@end
