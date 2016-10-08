//
//  FBSureOrderViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBSureOrderViewController.h"
#import "OrderItems.h"
#import "DeliveryAddressModel.h"
#import "FBUserAddressTableViewCell.h"
#import "FBGoodsItemsTableViewCell.h"
#import "FBOrderOtherTableViewCell.h"
#import "DeliveryAddressViewController.h"
#import "FBOrderSendWayViewController.h"
#import "FBOrderTimeViewController.h"
#import "BonusViewController.h"
#import "OrderInfoModel.h"
#import "FBPayTheWayViewController.h"
#import "PaySuccessViewController.h"

static NSString *const URLBuying = @"/shopping/now_buy";
static NSString *const URLUserAddress = @"/shopping/default_address";
static NSString *const URLSureOrder = @"/shopping/confirm";
static NSString *const URLCarGoPay = @"/shopping/checkout";

@interface FBSureOrderViewController ()<BounsDelegate> {
    NSString * _rid;
    NSString * _rrid;
    NSString * _addbookId;
    NSString * _isNowbuy;
    NSString * _summary;
    NSString * _paymentMethod;
    NSString * _transferTime;
    NSString * _bonusCode;
    NSString * _fromSite;
    NSInteger  _bounsPrice;
    BOOL       _isUserBouns;
}

@pro_strong NSMutableArray          *   goodsItems;
@pro_strong DeliveryAddressModel    *   userAddress;
@pro_strong OrderInfoModel          *   orderInfo;

@end

@implementation FBSureOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self networkUserAddress];
    
    if (self.type == 1) {
        [self networkBuyingOrderData];
    } else if (self.type == 0) {
        [self networkCarGoPayData:self.carGoodsMarr];
    }
    
    [self setOrderVcUI];
}

#pragma mark - 网络请求
#pragma mark 立即购买
- (void)networkBuyingOrderData {
    [SVProgressHUD show];
    self.buyingRequest = [FBAPI postWithUrlString:URLBuying requestDictionary:self.orderDict delegate:self];
    [self.buyingRequest startRequestSuccess:^(FBRequest *request, id result) {
        //  合计价格
        self.payPrice = [[result valueForKey:@"data"] valueForKey:@"pay_money"];
        self.sumPrice.text = [NSString stringWithFormat:@"￥%@", self.payPrice];
        
        _rid = [[[result valueForKey:@"data"] valueForKey:@"order_info"] valueForKey:@"rid"];
        _rrid = [[[result valueForKey:@"data"] valueForKey:@"order_info"] valueForKey:@"_id"];
        _isNowbuy = [[result valueForKey:@"data"] valueForKey:@"is_nowbuy"];
        _transferTime = @"a";
        _bonusCode = @"";
        
        NSArray * items = [[[[result valueForKey:@"data"] valueForKey:@"order_info"] valueForKey:@"dict"] valueForKey:@"items"];
        for (NSDictionary * itemDict in items) {
            OrderItems * itemModel = [[OrderItems alloc] initWithDictionary:itemDict];
            [self.goodsItems addObject:itemModel];
        }
        [self.orderTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 购物车下单
- (void)networkCarGoPayData:(NSMutableArray *)itemData {
    [SVProgressHUD show];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:itemData options:0 error:nil];
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    self.carPayRequest = [FBAPI postWithUrlString:URLCarGoPay requestDictionary:@{@"array":json} delegate:self];
    [self.carPayRequest startRequestSuccess:^(FBRequest *request, id result) {
        //  合计价格
        self.payPrice = [[result valueForKey:@"data"] valueForKey:@"pay_money"];
        self.sumPrice.text = [NSString stringWithFormat:@"￥%@", self.payPrice];
        
        _rid = [[[result valueForKey:@"data"] valueForKey:@"order_info"] valueForKey:@"rid"];
        _rrid = [[[result valueForKey:@"data"] valueForKey:@"order_info"] valueForKey:@"_id"];
        _isNowbuy = [[result valueForKey:@"data"] valueForKey:@"is_nowbuy"];
        _transferTime = @"a";
        _bonusCode = @"";
        
        NSArray * items = [[[[result valueForKey:@"data"] valueForKey:@"order_info"] valueForKey:@"dict"] valueForKey:@"items"];
        for (NSDictionary * itemDict in items) {
            OrderItems * itemModel = [[OrderItems alloc] initWithDictionary:itemDict];
            [self.goodsItems addObject:itemModel];
        }
        [self.orderTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 默认收货地址
- (void)networkUserAddress {
    [SVProgressHUD show];
    self.addressRequest = [FBAPI getWithUrlString:URLUserAddress requestDictionary:@{} delegate:self];
    [self.addressRequest startRequestSuccess:^(FBRequest *request, id result) {
        _addbookId = [[result valueForKey:@"data"] valueForKey:@"_id"];
        self.userAddress = [[DeliveryAddressModel alloc] initWithDictionary:[result valueForKey:@"data"]];
        [self.orderTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 立即下单
- (void)networkSureOrder:(NSDictionary *)orderData {
    [SVProgressHUD show];
    self.orderRrquest = [FBAPI postWithUrlString:URLSureOrder requestDictionary:orderData delegate:self];
    [self.orderRrquest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary * dataDic = [result objectForKey:@"data"];
        self.orderInfo = [[OrderInfoModel alloc] initWithDictionary:dataDic];
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            if ([self.orderInfo.payMoney isEqual:@0]) {
                [self checkOrderInfoForPayStatusWithPaymentWay:nil];
            }else{
                FBPayTheWayViewController * payWayVC = [[FBPayTheWayViewController alloc] init];
                payWayVC.orderInfo = self.orderInfo;
                [self.navigationController pushViewController:payWayVC animated:YES];
            }
        }
        
    } failure:^(FBRequest *request, NSError *error) {
         [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 请求订单状态以核实支付是否完成
- (void)checkOrderInfoForPayStatusWithPaymentWay:(NSString *)paymentWay
{
    FBRequest * request = [FBAPI postWithUrlString:@"/shopping/detail" requestDictionary:@{@"rid": self.orderInfo.rid} delegate:self];
    [SVProgressHUD showWithStatus:@"正在核实支付结果..." maskType:SVProgressHUDMaskTypeClear];
    //延迟2秒执行以保证服务端已获取支付通知
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        WEAKSELF
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary * dataDic = [result objectForKey:@"data"];
            if ([[dataDic objectForKey:@"status"] isEqualToNumber:@10]) {
                PaySuccessViewController * paySuccessVC = [[PaySuccessViewController alloc] initWithNibName:@"PaySuccessViewController" bundle:nil];
                paySuccessVC.orderInfo = weakSelf.orderInfo;
                paySuccessVC.paymentWay = paymentWay;
                [weakSelf.navigationController pushViewController:paySuccessVC animated:YES];
                
                [SVProgressHUD showSuccessWithStatus:@"支付成功!"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"支付未成功!"];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    });
}


#pragma mark - 设置视图
- (void)setOrderVcUI {
    self.sendTime = NSLocalizedString(@"anySendTime", nil);
    _isUserBouns = NO;
    [self.view addSubview:self.orderTable];
    [self.view addSubview:self.sureView];
}

#pragma makr - 订单视图
- (UITableView *)orderTable {
    if (!_orderTable) {
        _orderTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStyleGrouped)];
        _orderTable.delegate = self;
        _orderTable.dataSource = self;
        _orderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTable.showsVerticalScrollIndicator = NO;
        _orderTable.tableFooterView = self.footerView;
        _orderTable.sectionFooterHeight = 0.01f;
        _orderTable.backgroundColor = [UIColor colorWithHexString:grayLineColor];
    }
    return _orderTable;
}

#pragma mark - 备注视图
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        lineLab.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        [_footerView addSubview:lineLab];
        
        UILabel * summaryLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 50, 44)];
        summaryLab.text = NSLocalizedString(@"summaryText", nil);
        summaryLab.font = [UIFont systemFontOfSize:14];
        summaryLab.textColor = [UIColor colorWithHexString:titleColor];
        
        [_footerView addSubview:summaryLab];
        [_footerView addSubview:self.summaryText];
    }
    return _footerView;
}

- (UITextField *)summaryText {
    if (!_summaryText) {
        _summaryText = [[UITextField alloc] initWithFrame:CGRectMake(60, 5, SCREEN_WIDTH - 70, 44)];
        _summaryText.placeholder = NSLocalizedString(@"writeSummary", nil);
        if (IS_iOS9) {
            _summaryText.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _summaryText.font = [UIFont systemFontOfSize:14];
        }
    }
    return _summaryText;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.goodsItems.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * userAddressTableViewCellId = @"UserAddressTableViewCellId";
        FBUserAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userAddressTableViewCellId];
        if (!cell) {
            cell = [[FBUserAddressTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userAddressTableViewCellId];
        }
        
        if (![self.userAddress valueForKey:@"address"]) {
            cell.addIcon.hidden = NO;
            cell.addIcon.hidden = NO;
            cell.openIcon.hidden = YES;
        } else {
            cell.addIcon.hidden = YES;
            cell.addLab.hidden = YES;
            cell.openIcon.hidden = NO;
            [cell setAddressModel:self.userAddress];
        }
        return cell;
    
    } else if (indexPath.section == 1) {
        static NSString * goodsItemsTableViewCellID = @"GoodsItemsTableViewCellID";
        FBGoodsItemsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsItemsTableViewCellID];
        if (!cell) {
            cell = [[FBGoodsItemsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsItemsTableViewCellID];
        }
        [cell setOrderModelData:self.goodsItems[indexPath.row]];
        return cell;
    
    } else if (indexPath.section == 2) {
        static NSString * orderDistributionTableViewCellID = @"OrderDistributionTableViewCellID";
        FBOrderOtherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:orderDistributionTableViewCellID];
        if (!cell) {
            cell = [[FBOrderOtherTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:orderDistributionTableViewCellID];
        }
        cell.seletedIcon.hidden = YES;
        cell.titleLab.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"OrderDistributionWay", nil)];
        cell.textLab.text = NSLocalizedString(@"freeSend", nil);
        return cell;
    } else if (indexPath.section == 3) {
        static NSString * orderTimeTableViewCellID = @"OrderTimeTableViewCellID";
        FBOrderOtherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:orderTimeTableViewCellID];
        if (!cell) {
            cell = [[FBOrderOtherTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:orderTimeTableViewCellID];
        }
        cell.titleLab.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"SendGoodsTime", nil)];
        cell.textLab.text = self.sendTime;
        return cell;
    
    } else if (indexPath.section == 4) {
        static NSString * orderBonusTableViewCellID = @"OrderBonusTableViewCellID";
        FBOrderOtherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:orderBonusTableViewCellID];
        if (!cell) {
            cell = [[FBOrderOtherTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:orderBonusTableViewCellID];
        }
        cell.titleLab.text = NSLocalizedString(@"OrderBonus", nil);
        if (_isUserBouns == YES) {
            cell.textLab.text = [NSString stringWithFormat:@"%@%zi", NSLocalizedString(@"userBouns", nil), _bounsPrice];
            if (IS_iOS9) {
                cell.textLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
            } else {
                cell.textLab.font = [UIFont systemFontOfSize:13];
            }
            cell.textLab.textColor = [UIColor colorWithHexString:fineixColor];
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 95;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 2.0f;
    }
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DeliveryAddressViewController * deliveryAddressVC = [[DeliveryAddressViewController alloc] init];
        deliveryAddressVC.isSelectType = true;
        deliveryAddressVC.selectedAddress = self.userAddress;
        deliveryAddressVC.selectedAddressBlock = ^(DeliveryAddressModel *deliveryAddress) {
            self.userAddress = deliveryAddress;
            _addbookId = [deliveryAddress valueForKey:@"idField"];
            [self.orderTable reloadData];
        };
        [self.navigationController pushViewController:deliveryAddressVC animated:YES];
    
    }
//    else if (indexPath.section == 2) {
//        FBOrderSendWayViewController * sendWayVC = [[FBOrderSendWayViewController alloc] init];
//        [self.navigationController pushViewController:sendWayVC animated:YES];
//    
//    }
    else if (indexPath.section == 3) {
        FBOrderTimeViewController * timeWayVC = [[FBOrderTimeViewController alloc] init];
        timeWayVC.getSendTimeBlock = ^(NSString * time, NSString * type) {
            _transferTime = type;
            self.sendTime = time;
            [self.orderTable reloadData];
        };
        [self.navigationController pushViewController:timeWayVC animated:YES];
    
    } else if (indexPath.section == 4) {
        BonusViewController * bonusVC = [[BonusViewController alloc] init];
        bonusVC.rid = _rid;
        bonusVC.bounsDelegate = self;
        [self.navigationController pushViewController:bonusVC animated:YES];
    }
    
}

#pragma mark - 获取红包
-(void)getBounsCode:(NSString *)code andBounsNum:(NSNumber *)amount {
    _bonusCode = code;
    _bounsPrice = [amount integerValue];
    _isUserBouns = YES;
    [self.orderTable reloadData];
    
    self.bounsLab.textColor = [UIColor colorWithHexString:titleColor];
    self.bounsPriceLab.text = [NSString stringWithFormat:@"￥%zi", _bounsPrice];
    
    NSInteger userBounsPrice = [self.payPrice integerValue] - _bounsPrice;
    if (userBounsPrice <= 0) {
        self.sumPrice.text = [NSString stringWithFormat:@"￥0"];
    } else if (userBounsPrice > 0) {
        self.sumPrice.text = [NSString stringWithFormat:@"￥%zi", userBounsPrice];
    }
    
}

#pragma mark - 确认订单按钮视图
- (UIView *)sureView {
    if (!_sureView) {
        _sureView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        _sureView.backgroundColor = [UIColor whiteColor];
        
        UIButton * sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 0, 120, 44)];
        sureBtn.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        [sureBtn setTitle:@"确认订单" forState:(UIControlStateNormal)];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [sureBtn addTarget:self action:@selector(sureOrederData) forControlEvents:(UIControlEventTouchUpInside)];
        [_sureView addSubview:sureBtn];
        
        self.sumPrice = [[UILabel alloc] init];
        self.sumPrice.textColor = [UIColor colorWithHexString:fineixColor];
        self.sumPrice.font = [UIFont systemFontOfSize:14];
        [_sureView addSubview:self.sumPrice];
        [self.sumPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@44);
            make.top.equalTo(_sureView.mas_top).with.offset(0);
            make.bottom.equalTo(_sureView.mas_bottom).with.offset(0);
            make.right.equalTo(sureBtn.mas_left).with.offset(-10);
        }];
        
        UILabel * sumLab = [[UILabel alloc] init];
        sumLab.textColor = [UIColor colorWithHexString:titleColor];
        sumLab.font = [UIFont systemFontOfSize:14];
        sumLab.text = NSLocalizedString(@"sumOrderPrice", nil);
        [_sureView addSubview:sumLab];
        [sumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.equalTo(_sureView.mas_top).with.offset(0);
            make.bottom.equalTo(_sureView.mas_bottom).with.offset(0);
            make.right.equalTo(self.sumPrice.mas_left).with.offset(5);
        }];
        
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineLab.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        [_sureView addSubview:lineLab];
        
        self.bounsPriceLab = [[UILabel alloc] init];
        self.bounsPriceLab.textColor = [UIColor colorWithHexString:fineixColor];
        self.bounsPriceLab.font = [UIFont systemFontOfSize:14];
        [_sureView addSubview:self.bounsPriceLab];
        [self.bounsPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.equalTo(_sureView.mas_top).with.offset(0);
            make.bottom.equalTo(_sureView.mas_bottom).with.offset(0);
            make.right.equalTo(sumLab.mas_left).with.offset(0);
        }];
        
        self.bounsLab = [[UILabel alloc] init];
        self.bounsLab.textColor = [UIColor whiteColor];
        self.bounsLab.font = [UIFont systemFontOfSize:14];
        self.bounsLab.text = NSLocalizedString(@"userBounsPrice", nil);
        [_sureView addSubview:self.bounsLab];
        [self.bounsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.equalTo(_sureView.mas_top).with.offset(0);
            make.bottom.equalTo(_sureView.mas_bottom).with.offset(0);
            make.right.equalTo(self.bounsPriceLab.mas_left).with.offset(5);
        }];
        
    }
    return _sureView;
}

- (void)sureOrederData {
    if (_addbookId.length) {
        _fromSite = @"7";
        _paymentMethod = @"a";
        _summary = self.summaryText.text;
        
        NSDictionary * orderDict = @{
                                     @"from_site":_fromSite,
                                     @"rrid":_rrid,
                                     @"addbook_id":_addbookId,
                                     @"is_nowbuy":_isNowbuy,
                                     @"summary":_summary,
                                     @"payment_method":_paymentMethod,
                                     @"transfer_time":_transferTime,
                                     @"bonus_code":[NSString stringWithFormat:@"%@",_bonusCode]
                                     };
        
        [self networkSureOrder:orderDict];
   
    } else {
        [SVProgressHUD showInfoWithStatus:@"请填写一个收货地址"];
    }
   
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"SureOrderVc", nil);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - 
- (NSMutableArray *)goodsItems {
    if (!_goodsItems) {
        _goodsItems = [NSMutableArray array];
    }
    return _goodsItems;
}

@end
