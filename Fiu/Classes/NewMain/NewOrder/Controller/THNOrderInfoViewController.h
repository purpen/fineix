//
//  THNOrderInfoViewController.h
//  Fiu
//
//  Created by FLYang on 2016/11/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "OrderInfoModel.h"
#import "ProductInfoModel.h"
#import "DeliveryAddressModel.h"
#import "THNOrderOperationView.h"
#import "UIView+TYAlertView.h"

@interface THNOrderInfoViewController : THNViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    THNOrderOperationViewDelegate
>

@property (nonatomic, strong) FBRequest             *orderRequest;
@property (nonatomic, strong) FBRequest             *operationRequest;
@property (nonatomic, strong) DeliveryAddressModel  *addressModel;
@property (nonatomic, strong) OrderInfoModel        *orderModel;
@property (nonatomic, strong) NSMutableArray        *orderDataMarr;
@property (nonatomic, strong) NSString              *orderId;
@property (nonatomic, strong) UITableView           *orderInfoTable;
@property (nonatomic, strong) THNOrderOperationView *bottomView;

@end
