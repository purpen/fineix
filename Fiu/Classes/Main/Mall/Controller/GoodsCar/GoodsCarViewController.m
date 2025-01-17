//
//  GoodsCarViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsCarViewController.h"
#import "CarGoodsModelItem.h"
#import "FBCarItemsTableViewCell.h"
#import "FBEditCarItemTableViewCell.h"
#import "FBGoodsInfoViewController.h"
#import "UIView+TYAlertView.h"
#import "FBSureOrderViewController.h"
#import "GoodsRow.h"
#import "MallListGoodsCollectionViewCell.h"
#import "THNRecommendCollectionReusableView.h"

static NSString *const URLGoodsCar = @"/shopping/fetch_cart";
static NSString *const URLCarGoodsStock = @"/shopping/fetch_cart_product_count";
static NSString *const URLDeleteCarItem = @"/shopping/remove_cart";
static NSString *const URLEditItemsNum = @"/shopping/edit_cart";
static NSString *const URLCarGoPay = @"/shopping/checkout";
static NSString *const URLMallList = @"/product/getlist";
static NSString *const goodsListCellId = @"MallListGoodsCollectionViewCellId";
static NSString *const MallListHeaderCellViewId = @"mallListHeaderCellViewId";
static CGFloat const itemHeight = ((SCREEN_WIDTH - 45)/2)*1.21;

@interface GoodsCarViewController () {
    BOOL    _isEdit;
}

@end

@implementation GoodsCarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];

    if ([self isUserLogin]) {
        [self networkGoodsCarList];
        
    } else {
        [self showDefaultBackView:0];
        if (self.carItemList.count > 0) {
            [self.carItemList removeAllObjects];
            [self.carItemTabel reloadData];
        }
    }
    
    self.chooseAllBtn.selected = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cacelAll" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setGoodsCarVcUI];
    [self thn_networkGoodsListData];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    if (Is_iPhoneX) {
        if (self.openType == 1) {
            _carItemTabel.frame = CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT - 88 - 34);
        } else {
            _carItemTabel.frame = CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT - 170);
        }
    }
}

#pragma mark - 设置视图
- (void)setGoodsCarVcUI {
    [self.navView addSubview:self.editBtn];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.equalTo(self.navView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.navView.mas_bottom).with.offset(0);
    }];
    
    [self.view addSubview:self.carItemTable];
    
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(_carItemTabel.mas_bottom).with.offset(0);
    }];
}

#pragma mark - 网络请求
#pragma mark 购物车列表
- (void)networkGoodsCarList {
    [SVProgressHUD show];
    
    self.goodsCarRequest = [FBAPI getWithUrlString:URLGoodsCar requestDictionary:nil delegate:self];
    [self.goodsCarRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self clearMarr];
        
        //  合计价格
        self.payPrice = 0.0f;
        self.sumPrice.text = [NSString stringWithFormat:@"￥%.2f", self.payPrice];
        
        NSArray *carItems = [[result valueForKey:@"data"] valueForKey:@"items"];
        
        for (NSDictionary * carItemDict in carItems) {
            CarGoodsModelItem *carModel = [[CarGoodsModelItem alloc] initWithDictionary:carItemDict];
            //  是否有京东的商品,给出提示
            if (carModel.vopId > 0) {
                self.carItemTabel.tableHeaderView = self.haveJDGoodsLab;
            }
            
            [self.carItemList addObject:carModel];
            [self.goodsIdList addObject:[NSString stringWithFormat:@"%zi", carModel.productId]];
        }
        
        [self getCarItemMarrSort:self.carItemList];
        for (NSInteger idx = 0; idx < self.carItemList.count; ++ idx) {
            [self.carGoodsCount addObject:[NSString stringWithFormat:@"%zi", [[self.carItemList valueForKey:@"n"][idx] integerValue]]];
        }
        self.priceMarr = [NSMutableArray arrayWithArray:[self.carItemList valueForKey:@"price"]];
        
        //  没有购物车数据的时候默认背景
        [self showDefaultBackView:self.carItemList.count];
        
        [self.carItemTabel reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 编辑购物车获取商品库存
- (void)networkGetCarGoodsStockData {
    self.stockRequest = [FBAPI getWithUrlString:URLCarGoodsStock requestDictionary:nil delegate:self];
    [self.stockRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * stockArr = [[result valueForKey:@"data"] valueForKey:@"items"];
        self.stockList = [NSMutableArray arrayWithArray:[stockArr valueForKey:@"quantity"]];
        [self.carItemTabel reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

#pragma mark 删除购物车商品
- (void)networkDeleteCarItemData:(NSMutableArray *)itemData {
    [SVProgressHUD show];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:itemData options:0 error:nil];
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.deleteRequest = [FBAPI postWithUrlString:URLDeleteCarItem requestDictionary:@{@"array":json} delegate:self];
    [self.deleteRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self networkGoodsCarList];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"deleteSuccess", nil)];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 修改购物车商品数量
- (void)networkEditCarItemsData:(NSMutableArray *)editItemData {
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:editItemData options:0 error:nil];
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.editCarItemRequest = [FBAPI postWithUrlString:URLEditItemsNum requestDictionary:@{@"array":json} delegate:self];
    [self.editCarItemRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [self networkGoodsCarList];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 购物车结算
- (void)networkCarGoPayData:(NSMutableArray *)itemData {
    [SVProgressHUD show];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:itemData options:0 error:nil];
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.carPayRequest = [FBAPI postWithUrlString:URLCarGoPay requestDictionary:@{@"array":json, @"referral_code":[self thn_getGoodsReferralCode]} delegate:self];
    [self.carPayRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
            FBSureOrderViewController * sureOrderVC = [[FBSureOrderViewController alloc] init];
            sureOrderVC.result = result;
            sureOrderVC.type = 0;
            [self.navigationController pushViewController:sureOrderVC animated:YES];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 推荐商品列表
- (void)thn_networkGoodsListData {
    [SVProgressHUD show];
    self.productListRequest = [FBAPI getWithUrlString:URLMallList requestDictionary:@{@"page":@"1",
                                                                                      @"size":@"8",
                                                                                      @"stick":@"1",
                                                                                      @"sort":@"0"} delegate:self];
    [self.productListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow *goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.productDataMarr addObject:goodsModel];
            [self.productIdMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.idField]];
        }
        
        [self.productList reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)getCarItemMarrSort:(NSMutableArray *)carItem {
    if (carItem.count > 1) {
        NSMutableArray *JDGoodsMarr = [NSMutableArray array];
        NSMutableArray *JDGoodsIdMarr = [NSMutableArray array];
        
        for (NSUInteger idx = 0; idx < carItem.count; ++ idx) {
            CarGoodsModelItem *model = carItem[idx];
            if (model.vopId > 0) {
                [JDGoodsMarr addObject:model];
                [JDGoodsIdMarr addObject:[NSString stringWithFormat:@"%zi", model.productId]];
                [carItem removeObject:model];
                [self.goodsIdList removeObject:[NSString stringWithFormat:@"%zi", model.productId]];
            }
        }
        
        if (JDGoodsMarr.count > 0) {
            [carItem addObjectsFromArray:JDGoodsMarr];
            [self.goodsIdList addObjectsFromArray:JDGoodsIdMarr];
        }
    }
}

#pragma mark - 服务描述性文字视图
- (THNCarServiceTextView *)headerTextView {
    if (!_headerTextView) {
        _headerTextView = [[THNCarServiceTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    }
    return _headerTextView;
}

#pragma mark 加载商品的列表
- (UITableView *)carItemTable {
    if (!_carItemTabel) {
        if (self.openType == 1) {
            _carItemTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        } else {
            _carItemTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113) style:(UITableViewStyleGrouped)];
        }
        _carItemTabel.delegate = self;
        _carItemTabel.dataSource = self;
        _carItemTabel.estimatedRowHeight = 0;
        _carItemTabel.estimatedSectionHeaderHeight = 0;
        _carItemTabel.estimatedSectionFooterHeight = 0;
        _carItemTabel.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        _carItemTabel.showsVerticalScrollIndicator = NO;
        _carItemTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _carItemTabel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.carItemList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEdit == YES) {
        static NSString * editCarItemsTableViewCellId = @"EditCarItemsTableViewCellId";
        FBEditCarItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:editCarItemsTableViewCellId];
        if (!cell) {
            cell = [[FBEditCarItemTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:editCarItemsTableViewCellId];
        }
        [cell setEditCarItemData:self.carItemList[indexPath.section] withStock:[self.stockList[indexPath.section] integerValue]];
        [cell.chooseBtn addTarget:self action:@selector(chooseDeleteItem:event:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    
    } else if (_isEdit == NO) {
        static NSString * carItemsTableViewCellId = @"CarItemsTableViewCellId";
        FBCarItemsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:carItemsTableViewCellId];
        if (!cell) {
            cell = [[FBCarItemsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:carItemsTableViewCellId];
        }
        [cell setGoodsCarItemData:self.carItemList[indexPath.section]];
        [cell.chooseBtn addTarget:self action:@selector(chooseGoPayItem:event:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 2.0f;
    } else
        return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

#pragma mark - 选择商品删除
- (void)chooseDeleteItem:(UIButton *)button event:(id)event {
    UITouch * touch = [[event allTouches] anyObject];
    CGPoint cellPoint = [touch locationInView:self.carItemTabel];
    NSIndexPath * indexPath = [self.carItemTabel indexPathForRowAtPoint:cellPoint];
    
    NSString * type = [NSString stringWithFormat:@"%@", [self.carItemList valueForKey:@"type"][indexPath.section]];
    NSString * targetId = [self.carItemList valueForKey:@"targetId"][indexPath.section];
    NSString * n = [NSString stringWithFormat:@"%@", [self.carItemList valueForKey:@"n"][indexPath.section]];
    NSDictionary * chooseDict = @{@"type":type, @"target_id":targetId, @"n":n};

    if (button.selected == YES) {
        [self.chooseItems addObject:chooseDict];
    } else {
        [self.chooseItems removeObject:chooseDict];
    }
}

#pragma mark - 选择商品结算
- (void)chooseGoPayItem:(UIButton *)button event:(id)event {
    UITouch * touch = [[event allTouches] anyObject];
    CGPoint cellPoint = [touch locationInView:self.carItemTabel];
    NSIndexPath * indexPath = [self.carItemTabel indexPathForRowAtPoint:cellPoint];
    
    NSString * type = [NSString stringWithFormat:@"%@", [self.carItemList valueForKey:@"type"][indexPath.section]];
    NSString * targetId = [self.carItemList valueForKey:@"targetId"][indexPath.section];
    NSString * n = [NSString stringWithFormat:@"%@", [self.carItemList valueForKey:@"n"][indexPath.section]];
    NSString * referralCode = [self.carItemList valueForKey:@"referralCode"][indexPath.section];
    if (referralCode.length == 0) {
        referralCode = @"";
    }
    NSDictionary * chooseDict = @{@"type":type, @"target_id":targetId, @"n":n, @"referral_code":referralCode};
    CGFloat payMoney = [self.priceMarr[indexPath.section] floatValue];
    
    if (button.selected == YES) {
        [self.chooseItems addObject:chooseDict];
        self.payPrice += (payMoney * [n integerValue]);
    } else {
        [self.chooseItems removeObject:chooseDict];
        self.payPrice -= (payMoney * [n integerValue]);
    }
    self.sumPrice.text = [NSString stringWithFormat:@"￥%.2f", self.payPrice];
    
    if (self.chooseItems.count == self.carItemList.count) {
        self.chooseAllBtn.selected = YES;
    } else {
        self.chooseAllBtn.selected = NO;
    }
}

#pragma mark - 跳转产看商品详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEdit == NO) {
        FBGoodsInfoViewController * goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = self.goodsIdList[indexPath.section];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}

#pragma mark - 有京东商品时的提示
- (UIView *)haveJDGoodsLab {
    if (!_haveJDGoodsLab) {
        _haveJDGoodsLab = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        THNCarServiceTextView *textView = [[THNCarServiceTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        [_haveJDGoodsLab addSubview:textView];
        
        UILabel *haveJDGoods = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 15)];
        haveJDGoods.font = [UIFont systemFontOfSize:12];
        haveJDGoods.textAlignment = NSTextAlignmentCenter;
        haveJDGoods.textColor = [UIColor colorWithHexString:@"#999999" alpha:1];
        haveJDGoods.text = @"由京东配货的商品需要单独结算";
        [_haveJDGoodsLab addSubview:haveJDGoods];
    }
    return _haveJDGoodsLab;
}

#pragma mark - 默认背景_没有商品的购物车
- (BuyCarDefault *)defaultCarView {
    if (!_defaultCarView) {
        _defaultCarView = [[BuyCarDefault alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 300)];
        [_defaultCarView thn_setDefaultViewImage:@"shopcarbig" promptText:NSLocalizedString(@"NoGoods", nil) hiddenButton:YES];
        THNCarServiceTextView *textView = [[THNCarServiceTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [_defaultCarView addSubview:textView];
    }
    return _defaultCarView;
}

- (void)showDefaultBackView:(NSInteger)count {
    if (count == 0) {
        self.carItemTable.tableHeaderView = self.defaultCarView;
        self.carItemTabel.tableFooterView = self.productList;
        self.bottomView.hidden = YES;
        self.editBtn.hidden = YES;
        
    } else {
        self.carItemTabel.tableHeaderView = self.headerTextView;
        self.carItemTabel.tableFooterView = [UIView new];
        self.bottomView.hidden = NO;
        self.editBtn.hidden = NO;
    }
}

#pragma mark - 底部视图·
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        [_bottomView addSubview:self.chooseAllBtn];
        [_bottomView addSubview:self.goPayBtn];
        
        UILabel * sumPrice = [[UILabel alloc] init];
        sumPrice.textColor = [UIColor colorWithHexString:fineixColor];
        sumPrice.font = [UIFont systemFontOfSize:14];
        self.sumPrice = sumPrice;
        [_bottomView addSubview:sumPrice];
        [sumPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@44);
            make.top.equalTo(_bottomView.mas_top).with.offset(0);
            make.bottom.equalTo(_bottomView.mas_bottom).with.offset(0);
            make.right.equalTo(self.goPayBtn.mas_left).with.offset(-10);
        }];
        
        UILabel * sumLab = [[UILabel alloc] init];
        sumLab.textColor = [UIColor colorWithHexString:titleColor];
        sumLab.font = [UIFont systemFontOfSize:14];
        sumLab.text = NSLocalizedString(@"sumOrderPrice", nil);
        self.sumLab = sumLab;
        [_bottomView addSubview:sumLab];
        [sumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.equalTo(_bottomView.mas_top).with.offset(0);
            make.bottom.equalTo(_bottomView.mas_bottom).with.offset(0);
            make.right.equalTo(sumPrice.mas_left).with.offset(0);
        }];
        
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineLab.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        
        [_bottomView addSubview:lineLab];
        [_bottomView addSubview:sumPrice];
        [_bottomView addSubview:sumLab];
    }
    return _bottomView;
}

#pragma mark - 全选按钮
- (UIButton *)chooseAllBtn {
    if (!_chooseAllBtn) {
        _chooseAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        [_chooseAllBtn setImage:[UIImage imageNamed:@"Check"] forState:(UIControlStateNormal)];
        [_chooseAllBtn setImage:[UIImage imageNamed:@"Check_red"] forState:(UIControlStateSelected)];
        [_chooseAllBtn setTitle:NSLocalizedString(@"CheckAll", nil) forState:(UIControlStateNormal)];
        [_chooseAllBtn setTitleEdgeInsets:(UIEdgeInsetsMake(0, 15, 0, 0))];
        _chooseAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_chooseAllBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        _chooseAllBtn.selected = NO;
        [_chooseAllBtn addTarget:self action:@selector(chooseAllBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _chooseAllBtn;
}

- (void)chooseAllBtnClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseAll" object:nil];
        //  全选商品
        [self.chooseItems removeAllObjects];
        
        CGFloat sumPrice = 0.0f;
        for (NSInteger idx = 0; idx < self.carItemList.count; ++ idx) {
            NSString * type = [NSString stringWithFormat:@"%@", [self.carItemList valueForKey:@"type"][idx]];
            NSString * targetId = [self.carItemList valueForKey:@"targetId"][idx];
            NSString * n = [NSString stringWithFormat:@"%@", [self.carItemList valueForKey:@"n"][idx]];
            NSString * referralCode = [self.carItemList valueForKey:@"referralCode"][idx];
            if (referralCode.length == 0) {
                referralCode = @"";
            }
            NSDictionary * chooseDict = @{@"type":type, @"target_id":targetId, @"n":n, @"referral_code":referralCode};
            [self.chooseItems addObject:chooseDict];
            
            //  合计价格
            CGFloat payMoney = [self.priceMarr[idx] floatValue];
            sumPrice += (payMoney * [n integerValue]);
            self.payPrice = sumPrice;
        }
        self.sumPrice.text = [NSString stringWithFormat:@"￥%.2f", self.payPrice];
    
    } else if (button.selected == YES) {
        button.selected = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cacelAll" object:nil];
        //  取消全选
        [self.chooseItems removeAllObjects];
        //  合计价格
        self.payPrice = 0.0f;
        self.sumPrice.text = [NSString stringWithFormat:@"￥%.2f", self.payPrice];
    }
}

#pragma mark - 去结算／删除
- (UIButton *)goPayBtn {
    if (!_goPayBtn) {
        _goPayBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 44)];
        [_goPayBtn setTitle:NSLocalizedString(@"GoPay", nil) forState:(UIControlStateNormal)];
        [_goPayBtn setTitle:NSLocalizedString(@"Delete", nil) forState:(UIControlStateSelected)];
        [_goPayBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _goPayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _goPayBtn.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        [_goPayBtn addTarget:self action:@selector(goPayBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _goPayBtn;
}

- (void)goPayBtnClick:(UIButton *)button {
    if (self.chooseItems.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择商品"];
        
    } else {
        if (button.selected == NO) {
            //  结算
            [self networkCarGoPayData:self.chooseItems];

        } else {
            //  删除
            TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"删除商品" message:@"确定将这个商品删除？"];
            alertView.layer.cornerRadius = 10;
            alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
            [alertView addAction:[TYAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:(TYAlertActionStyleCancel) handler:nil]];
            [alertView addAction:[TYAlertAction actionWithTitle:NSLocalizedString(@"sure", nil) style:(TYAlertActionStyleDefault) handler:^(TYAlertAction *action) {
                [self networkDeleteCarItemData:self.chooseItems];
            }]];
            [alertView showInWindowWithBackgoundTapDismissEnable:YES];
        }
    }
}

#pragma mark - 编辑购物车
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setTitle:NSLocalizedString(@"Edit", nil) forState:(UIControlStateNormal)];
        [_editBtn setTitle:NSLocalizedString(@"Done", nil) forState:(UIControlStateSelected)];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _editBtn.selected = NO;
        [_editBtn addTarget:self action:@selector(beginEditCar:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _editBtn;
}

- (void)beginEditCar:(UIButton *)button {
    if (button.selected == NO) {
        //  编辑状态
        [self networkGetCarGoodsStockData];
        button.selected = YES;
        _isEdit = YES;
        self.goPayBtn.selected = YES;
        self.sumLab.hidden = YES;
        self.sumPrice.hidden = YES;
        self.chooseAllBtn.selected = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cacelAll" object:nil];
        [self.chooseItems removeAllObjects];
        [self.carItemTabel reloadData];
        
    } else if (button.selected == YES) {
        //  编辑购物车后的数量
        NSMutableArray * editCarGoodsCount = [NSMutableArray array];
        NSArray * cellArr = [self.carItemTabel indexPathsForVisibleRows];
        for (NSInteger idx = 0; idx < cellArr.count; ++ idx) {
            if (_isEdit) {
                FBEditCarItemTableViewCell * cell = [self.carItemTabel cellForRowAtIndexPath:cellArr[idx]];
                if (cell.newNum != cell.nowNum) {
                    NSInteger index = [self.carGoodsCount indexOfObject:[NSString stringWithFormat:@"%zi", cell.nowNum]];
                    [self.carGoodsCount replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%zi", cell.newNum]];
                }
            }
            NSString * type = [NSString stringWithFormat:@"%@", [self.carItemList valueForKey:@"type"][idx]];
            NSString * targetId = [self.carItemList valueForKey:@"targetId"][idx];
            NSString * n = self.carGoodsCount[idx];
            NSDictionary * params = @{
                                      @"target_id":targetId,
                                      @"type":type,
                                      @"n":n
                                      };
            [editCarGoodsCount addObject:params];
        }
        [self networkEditCarItemsData:editCarGoodsCount];
        
        //  默认状态
        self.chooseAllBtn.selected = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cacelAll" object:nil];
        [self.chooseItems removeAllObjects];
        button.selected = NO;
        _isEdit = NO;
        self.goPayBtn.selected = NO;
        self.sumLab.hidden = NO;
        self.sumPrice.hidden = NO;
        [self.carItemTabel reloadData];
    }
}

#pragma mark - 推荐商品列表
- (UICollectionView *)productList {
    if (!_productList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, itemHeight);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayou.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40);
        
        _productList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (itemHeight * 4) + 130)
                                        collectionViewLayout:flowLayou];
        _productList.showsVerticalScrollIndicator = NO;
        _productList.delegate = self;
        _productList.dataSource = self;
        _productList.scrollEnabled = NO;
        _productList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_productList registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:goodsListCellId];
        [_productList registerClass:[THNRecommendCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                      withReuseIdentifier:MallListHeaderCellViewId];
    }
    return _productList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productDataMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallListGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsListCellId
                                                                                       forIndexPath:indexPath];
    if (self.productDataMarr.count) {
        [cell setGoodsListData:self.productDataMarr[indexPath.row]];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    THNRecommendCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                       withReuseIdentifier:MallListHeaderCellViewId
                                                                                               forIndexPath:indexPath];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
    goodsVC.goodsID = self.productIdMarr[indexPath.row];
    [self.navigationController pushViewController:goodsVC animated:YES];
}

#pragma mark - 设置导航栏
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navViewTitle.text = NSLocalizedString(@"GoodsCarVcTitle", nil);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - 
- (NSMutableArray *)carItemList {
    if (!_carItemList) {
        _carItemList = [NSMutableArray array];
    }
    return _carItemList;
}

- (NSMutableArray *)goodsIdList {
    if (!_goodsIdList) {
        _goodsIdList = [NSMutableArray array];
    }
    return _goodsIdList;
}

- (NSMutableArray *)chooseItems {
    if (!_chooseItems) {
        _chooseItems = [NSMutableArray array];
    }
    return _chooseItems;
}

- (NSMutableArray *)carGoodsCount {
    if (!_carGoodsCount) {
        _carGoodsCount = [NSMutableArray array];
    }
    return _carGoodsCount;
}

- (NSMutableArray *)productIdMarr {
    if (!_productIdMarr) {
        _productIdMarr = [NSMutableArray array];
    }
    return _productIdMarr;
}

- (NSMutableArray *)productDataMarr {
    if (!_productDataMarr) {
        _productDataMarr = [NSMutableArray array];
    }
    return _productDataMarr;
}

#pragma mark - clear
- (void)clearMarr {
    [self.carItemList removeAllObjects];
    [self.goodsIdList removeAllObjects];
    [self.chooseItems removeAllObjects];
    [self.priceMarr removeAllObjects];
    [self.carGoodsCount removeAllObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cacelAll" object:nil];
}

@end
