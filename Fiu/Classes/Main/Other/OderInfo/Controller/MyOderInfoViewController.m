//
//  MyOderInfoViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyOderInfoViewController.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import "OrderInfoCell.h"
#import "SVProgressHUD.h"
#import "OrderInfoModel.h"
#import "MJRefresh.h"
#import "TYAlertView.h"
#import "UIView+TYAlertView.h"
#import "TipNumberView.h"
#import "RefundmentViewController.h"
#import "CommenttwoViewController.h"
#import "FBPayTheWayViewController.h"
#import "HMSegmentedControl.h"
#import "CounterModel.h"
#import "SGTopTitleView.h"

#import "THNOrderInfoViewController.h"
#import "THNRefundInfoViewController.h"
#import "RefundGoodsModel.h"
#import "THNUserData.h"

static NSString *const OrderListURL             = @"/shopping/orders";
static NSString *const URLRefundList            = @"/shopping/refund_list";

static NSString *const OrderInfoCellIdentifier  = @"orderInfoCell";

@interface MyOderInfoViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate,OrderInfoCellDelegate,SGTopTitleViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;
@property (nonatomic,strong) NSMutableArray *orderListAry;
@property(nonatomic,strong) TipNumberView *tipNumView2;
@property(nonatomic,strong) TipNumberView *tipNumView3;
@property(nonatomic,strong) TipNumberView *tipNumView4;
@property(nonatomic,strong) TipNumberView *tipNumView5;
/**  */
@property (nonatomic, strong) SGTopTitleView *segmentedControl;

@end

@implementation MyOderInfoViewController

-(SGTopTitleView *)segmentedControl{

    if (!_segmentedControl) {
        _segmentedControl = [[SGTopTitleView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _segmentedControl.staticTitleArr = @[@"全部", @"未付款", @"待发货", @"待收货", @"待评价"];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.delegate_SG = self;
        [_segmentedControl staticTitleLabelSelecteded:_segmentedControl.allTitleLabel[[self.type intValue]]];
    }
    return _segmentedControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.segmentedControl];
    [self requestDataForOderList];
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderInfoCell" bundle:nil] forCellReuseIdentifier:OrderInfoCellIdentifier];
    _myTableView.estimatedRowHeight = 212.f;
    _myTableView.rowHeight = UITableViewAutomaticDimension;
    
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":userdata.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dataDict = result[@"data"];
        NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
        _counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
        
        
        //待付款
        if ([_counterModel.order_wait_payment intValue] == 0) {
            //不显示
            [self.tipNumView2 removeFromSuperview];
        }else{
            //显示
            UILabel *label = self.segmentedControl.allTitleLabel[1];
            self.tipNumView2.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_wait_payment];
            CGSize size = [self.tipNumView2.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
            [label addSubview:self.tipNumView2];
            [self.tipNumView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 14));
                }else{
                    make.size.mas_equalTo(CGSizeMake(14, 14));
                }
                if (SCREEN_HEIGHT<667.0) {
                    make.right.mas_equalTo(label.mas_right).with.offset(-5);
                }else{
                    make.right.mas_equalTo(label.mas_right).with.offset(-10);
                }
                make.top.mas_equalTo(label.mas_top).with.offset(5);
            }];
        }
        
        //待发货
        if ([_counterModel.order_ready_goods intValue] == 0) {
            //不显示
            [self.tipNumView3 removeFromSuperview];
        }else{
            //显示
            UILabel *label = self.segmentedControl.allTitleLabel[2];
            self.tipNumView3.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_ready_goods];
            CGSize size = [self.tipNumView3.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
            [label addSubview:self.tipNumView3];
            self.tipNumView3.frame = CGRectMake(0, 0, 14, 14);
            [self.tipNumView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 14));
                }else{
                    make.size.mas_equalTo(CGSizeMake(14, 14));
                }
                if (SCREEN_HEIGHT<667.0) {
                    make.right.mas_equalTo(label.mas_right).with.offset(-5);
                }else{
                    make.right.mas_equalTo(label.mas_right).with.offset(-10);
                }
                make.top.mas_equalTo(label.mas_top).with.offset(5);
            }];
        }
        
        //待收货
        if ([_counterModel.order_sended_goods intValue] == 0) {
            //不显示
            [self.tipNumView4 removeFromSuperview];
        }else{
            //显示
            UILabel *label = self.segmentedControl.allTitleLabel[3];
            self.tipNumView4.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_sended_goods];
            CGSize size = [self.tipNumView4.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
            [label addSubview:self.tipNumView4];
            [self.tipNumView4 mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 14));
                }else{
                    make.size.mas_equalTo(CGSizeMake(14, 14));
                }
                if (SCREEN_HEIGHT<667.0) {
                    make.right.mas_equalTo(label.mas_right).with.offset(-5);
                }else{
                    make.right.mas_equalTo(label.mas_right).with.offset(-10);
                }
                make.top.mas_equalTo(label.mas_top).with.offset(5);
            }];
        }
        
        //待评价
        if ([_counterModel.order_evaluate intValue] == 0) {
            //不显示
            [self.tipNumView5 removeFromSuperview];
        }else{
            //显示
            UILabel *label = self.segmentedControl.allTitleLabel[4];
            self.tipNumView5.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_evaluate];
            CGSize size = [self.tipNumView5.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
            [label addSubview:self.tipNumView5];
            [self.tipNumView5 mas_makeConstraints:^(MASConstraintMaker *make) {
                if ((size.width+9) > 15) {
                    make.size.mas_equalTo(CGSizeMake(size.width+9, 14));
                }else{
                    make.size.mas_equalTo(CGSizeMake(14, 14));
                }
                if (SCREEN_HEIGHT<667.0) {
                    make.right.mas_equalTo(label.mas_right).with.offset(-5);
                }else{
                    make.right.mas_equalTo(label.mas_right).with.offset(-10);
                }
                make.top.mas_equalTo(label.mas_top).with.offset(5);
            }];
        }
        
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
    
    self.delegate = self;
    self.navViewTitle.text = @"我的订单";
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    // 下拉刷新
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageNumber = 0;
        [self.orderListAry removeAllObjects];
        [self.myTableView.mj_footer endRefreshing];
        [self thn_networkOrderListData:self.type];
    }];
    
    //上拉加载更多
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentPageNumber < _totalPageNumber) {
            [self.myTableView.mj_header endRefreshing];
            [self thn_networkOrderListData:self.type];
        } else {
            [self.myTableView.mj_footer endRefreshing];
        }
    }];

}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    self.type = [NSNumber numberWithInteger:index];
    if (index == 5) {
        self.type = [NSNumber numberWithInteger:8];
    }
    [self.orderListAry removeAllObjects];
    [self requestDataForOderList];
}


-(TipNumberView *)tipNumView2{
    if (!_tipNumView2) {
        _tipNumView2 = [TipNumberView getTipNumView];
        _tipNumView2.layer.masksToBounds = YES;
        _tipNumView2.layer.cornerRadius = 14 * 0.5;
    }
    return _tipNumView2;
}

-(TipNumberView *)tipNumView3{
    if (!_tipNumView3) {
        _tipNumView3 = [TipNumberView getTipNumView];
        _tipNumView3.layer.masksToBounds = YES;
        _tipNumView3.layer.cornerRadius = 14 * 0.5;
    }
    return _tipNumView3;
}

-(TipNumberView *)tipNumView4{
    if (!_tipNumView4) {
        _tipNumView4 = [TipNumberView getTipNumView];
        _tipNumView4.layer.masksToBounds = YES;
        _tipNumView4.layer.cornerRadius = 14 * 0.5;
    }
    return _tipNumView4;
}

-(TipNumberView *)tipNumView5{
    if (!_tipNumView5) {
        _tipNumView5 = [TipNumberView getTipNumView];
        _tipNumView5.layer.masksToBounds = YES;
        _tipNumView5.layer.cornerRadius = 14 * 0.5;
    }
    return _tipNumView5;
}


//请求不同状态订单列表
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    self.type = [NSNumber numberWithInteger:segmentedControl.selectedSegmentIndex];
    if (segmentedControl.selectedSegmentIndex == 5) {
        self.type = [NSNumber numberWithInteger:8];
    }
    [self requestDataForOderList];
}

//上拉下拉分页请求订单列表
- (void)requestDataForOderListOperationWith:(NSNumber *)type withURL:(NSString *)URL
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(_currentPageNumber + 1) forKey:@"page"];
    [params setObject:@10 forKey:@"size"];
    
    if (![type isEqualToNumber:@8]) {
        [params setObject:type forKey:@"status"];
    }
    
    FBRequest * request = [FBAPI postWithUrlString:URL requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if ([result[@"data"][@"current_page"] integerValue] == 1) {
            [self.orderListAry removeAllObjects];
        }
        NSDictionary * dataDic = [result objectForKey:@"data"];
        NSArray * rowsAry = [dataDic objectForKey:@"rows"];
        
        for (NSDictionary * orderInfoDic in rowsAry) {
            if ([type isEqualToNumber:@8]) {
                RefundGoodsModel *model = [[RefundGoodsModel alloc] initWithDictionary:orderInfoDic];
                [self.orderListAry addObject:model];
                
            } else {
                OrderInfoModel * orderInfo = [[OrderInfoModel alloc] initWithDictionary:orderInfoDic];
                [self.orderListAry addObject:orderInfo];
            }
        }
        [self.myTableView reloadData];
        
        _currentPageNumber = [dataDic[@"current_page"] integerValue];
        _totalPageNumber = [dataDic[@"total_page"] integerValue];
        
        BOOL isLastPage = (_currentPageNumber == _totalPageNumber);
        
        if (!isLastPage) {
            if (_myTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [_myTableView.mj_footer resetNoMoreData];
            }
        }
        if (_currentPageNumber == _totalPageNumber == 1) {
            _myTableView.mj_footer.state = MJRefreshStateNoMoreData;
            _myTableView.mj_footer.hidden = true;
        }
        
        if ([_myTableView.mj_header isRefreshing]) {
            [_myTableView.mj_header endRefreshing];
        }
        if ([_myTableView.mj_footer isRefreshing]) {
            if (isLastPage) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            } else  {
                [_myTableView.mj_footer endRefreshing];
            }
        }
        
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}

-(NSMutableArray *)orderListAry{
    if (!_orderListAry) {
        _orderListAry = [NSMutableArray array];
    }
    return _orderListAry;
}

#pragma mark - Network
//请求不同状态订单列表
- (void)requestDataForOderList
{
    _currentPageNumber = 0;
    [self.orderListAry removeAllObjects];
    [self.myTableView.mj_header beginRefreshing];
    [self thn_networkOrderListData:self.type];
}

- (void)thn_networkOrderListData:(NSNumber *)type {
    if ([type isEqualToNumber:@8]) {
        [self requestDataForOderListOperationWith:type withURL:URLRefundList];
    } else {
        [self requestDataForOderListOperationWith:type withURL:OrderListURL];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderListAry.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderInfoCell * orderInfoCell = [tableView dequeueReusableCellWithIdentifier:OrderInfoCellIdentifier forIndexPath:indexPath];
    if (![orderInfoCell.delegate isEqual:self]) {
        orderInfoCell.delegate = self;
    }
    if (self.orderListAry.count) {
        if ([self.type isEqualToNumber:@8]) {
            [orderInfoCell thn_setRefundGoodsListData:self.orderListAry[indexPath.row]];
        } else {
            orderInfoCell.orderInfo = self.orderListAry[indexPath.row];
        }
    }
    return orderInfoCell;
}

#pragma mark - OrderInfoCellDelegate
- (void)tapProductViewWithOrderInfoCell:(OrderInfoCell *)orderInfoCell orderId:(NSString *)orderId type:(NSInteger)type
{
    if (type == 1) {
        //  订单详情(Fynn)
        THNOrderInfoViewController *orderInfoVC = [[THNOrderInfoViewController alloc] init];
        orderInfoVC.orderId = orderId;
        [self.navigationController pushViewController:orderInfoVC animated:YES];
    
    } else if (type == 2) {
        THNRefundInfoViewController *refundVC = [[THNRefundInfoViewController alloc] init];
        refundVC.refundId = orderId;
        [self.navigationController pushViewController:refundVC animated:YES];
    }
}

- (void)operation1stBtnAction:(UIButton *)button withOrderInfoCell:(OrderInfoCell *)orderInfoCell
{
    switch (orderInfoCell.orderInfo.status) {
        case OrderInfoStateExpired:
        case OrderInfoStateCancled:
        case OrderInfoStateRefunded:
        case OrderInfoStateCompleted:
        {
            [self deleteOrderWithCell:orderInfoCell];
        }
            break;
        case OrderInfoStateWaitPayment://立即支付
        {
            FBPayTheWayViewController * payWayVC = [[FBPayTheWayViewController alloc] init];
            payWayVC.orderInfo = orderInfoCell.orderInfo;
            [self.navigationController pushViewController:payWayVC animated:YES];
        }
            break;
        case OrderInfoStateWaitDelivery://待发货
        {
            FBRequest *request = [FBAPI postWithUrlString:@"/shopping/alert_send_goods" requestDictionary:@{
                                                                                                            @"rid":orderInfoCell.orderInfo.rid
                                                                                                                } delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                //提醒发货
                [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"message"]];
                
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        }
            break;
        case OrderInfoStateWaitReceive://确认收货
        {
            [self confirmReceiptWithCell:orderInfoCell];
            
        }
            break;
        case OrderInfoStateWaitComment://去评价
        {
            CommenttwoViewController * commentVC = [[CommenttwoViewController alloc] initWithNibName:@"CommenttwoViewController" bundle:nil];
            commentVC.orderInfoModel = orderInfoCell.orderInfo;
            [self.navigationController pushViewController:commentVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)operation2ndBtnAction:(UIButton *)button withOrderInfoCell:(OrderInfoCell *)orderInfoCell
{
    switch (orderInfoCell.orderInfo.status) {
        case OrderInfoStateWaitPayment:
        {
            [self cancleOrderWithCell:orderInfoCell];
        }
            break;
        case OrderInfoStateWaitComment:
        {
            [self deleteOrderWithCell:orderInfoCell];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 订单操作
//请求删除订单
- (void)deleteOrderWithCell:(OrderInfoCell *)cell
{
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"确认删除订单？" message:nil];
    alertView.layer.cornerRadius = 10;
    alertView.buttonDefaultBgColor = [UIColor colorWithHexString:fineixColor];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#999999"];
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:nil];
    TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
        FBRequest * request = [FBAPI postWithUrlString:@"/my/delete_order" requestDictionary:@{@"rid": cell.orderInfo.rid} delegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [self operationActionWithCell:cell];
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];

        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    }];
    [alertView addAction:cancel];
    [alertView addAction:confirm];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
}

- (void)cancleOrderWithCell:(OrderInfoCell *)cell
{
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"确认取消订单？" message:nil];
    alertView.layer.cornerRadius = 10;
    alertView.buttonDefaultBgColor = [UIColor colorWithHexString:fineixColor];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#999999"];
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:nil];
    TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
        FBRequest * request = [FBAPI postWithUrlString:@"/my/cancel_order" requestDictionary:@{@"rid": cell.orderInfo.rid} delegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [self operationActionWithCell:cell];
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            int n = [self.tipNumView2.tipNumLabel.text intValue];
            n --;
            if (n == 0) {
                [self.tipNumView2 removeFromSuperview];
            }else{
                self.tipNumView2.tipNumLabel.text = [NSString stringWithFormat:@"%d",n];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    }];
    [alertView addAction:cancel];
    [alertView addAction:confirm];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
}

//请求确认收货
- (void)confirmReceiptWithCell:(OrderInfoCell *)cell
{
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"确认收货？" message:nil];
    alertView.layer.cornerRadius = 10;
    alertView.buttonDefaultBgColor = [UIColor colorWithHexString:fineixColor];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#999999"];
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:nil];
    TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
        FBRequest * request = [FBAPI postWithUrlString:@"/shopping/take_delivery" requestDictionary:@{@"rid": cell.orderInfo.rid} delegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [self operationActionWithCell:cell];
            [SVProgressHUD showSuccessWithStatus:@"确认收货成功"];
            int n = [self.tipNumView4.tipNumLabel.text intValue];
            n --;
            if (n == 0) {
                [self.tipNumView4 removeFromSuperview];
            }else{
                self.tipNumView4.tipNumLabel.text = [NSString stringWithFormat:@"%d",n];
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    }];
    [alertView addAction:cancel];
    [alertView addAction:confirm];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
}

#pragma mark - OrderInfoDetailVCDelegate
- (void)operationActionWithCell:(OrderInfoCell *)cell
{
    NSIndexPath * indexPath = [self.myTableView indexPathForCell:cell];
    [self.orderListAry removeObjectAtIndex:indexPath.row];
    [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



@end
