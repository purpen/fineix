//
//  FBSureOrderViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface FBSureOrderViewController : FBViewController <UITableViewDelegate, UITableViewDataSource>

/**
 *  type：下单类型
 *  0:购物车 ／ 1:立即购买
 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) id result;
@property (nonatomic, strong) NSDictionary *orderDict;
@property (nonatomic, strong) NSMutableArray  *carGoodsMarr;
@property (nonatomic, strong) FBRequest *buyingRequest;
@property (nonatomic, strong) FBRequest *addressRequest;
@property (nonatomic, strong) FBRequest *orderRrquest;
@property (nonatomic, strong) FBRequest *carPayRequest;
@property (nonatomic, strong) FBRequest *freightRequest;

@property (nonatomic, strong) UITableView *orderTable;
@property (nonatomic, strong) UIView *sureView;
@property (nonatomic, strong) NSString *payPrice;
@property (nonatomic, strong) UILabel *sumPrice;
@property (nonatomic, strong) UILabel *bounsLab;
@property (nonatomic, strong) UILabel *bounsPriceLab;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITextField *summaryText;
@property (nonatomic, strong) UILabel *coinLab;

@end
