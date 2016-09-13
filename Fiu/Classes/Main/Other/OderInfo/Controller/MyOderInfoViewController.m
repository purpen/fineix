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
#import "OrderInfoDetailViewController.h"
#import "RefundmentViewController.h"
#import "CommenttwoViewController.h"
#import "FBPayTheWayViewController.h"
#import "HMSegmentedControl.h"
#import "CounterModel.h"

@interface MyOderInfoViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate,OrderInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;
@property (nonatomic,strong) NSMutableArray *orderListAry;
@property(nonatomic,strong) TipNumberView *tipNumView2;
@property(nonatomic,strong) TipNumberView *tipNumView3;
@property(nonatomic,strong) TipNumberView *tipNumView4;
@property(nonatomic,strong) TipNumberView *tipNumView5;

@end

static NSString *const OrderListURL = @"/shopping/orders";
static NSString *const OrderInfoCellIdentifier = @"orderInfoCell";

@implementation MyOderInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navViewTitle.text = @"我的订单";
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    //tableView每个row的高度
    self.myTableView.rowHeight = 222;

    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"待付款", @"待发货", @"待收货", @"待评价",@"退货/售后"]];

    segmentedControl.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);//
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(5, 5, 5, 5);
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorHeight = 2.0f;
    segmentedControl.selectionIndicatorColor = [UIColor colorWithHexString:fineixColor];
    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        if (selected) {
            NSAttributedString *seletedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:fineixColor], NSFontAttributeName: [UIFont systemFontOfSize:14]}];
            return seletedTitle;
        }
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#222222"], NSFontAttributeName: [UIFont systemFontOfSize:14]}];
        return attString;
    }];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];

    if ([self.type isEqualToNumber:@0]) {
       [segmentedControl setSelectedSegmentIndex:0];
    }else if ([self.type isEqualToNumber:@1]){
        [segmentedControl setSelectedSegmentIndex:1];
    }else if ([self.type isEqualToNumber:@2]){
        [segmentedControl setSelectedSegmentIndex:2];
    }else if ([self.type isEqualToNumber:@3]){
        [segmentedControl setSelectedSegmentIndex:3];
    }else if ([self.type isEqualToNumber:@4]){
        [segmentedControl setSelectedSegmentIndex:4];
    }else if ([self.type isEqualToNumber:@5]){
        [segmentedControl setSelectedSegmentIndex:5];
    }
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderInfoCell" bundle:nil] forCellReuseIdentifier:OrderInfoCellIdentifier];
    _myTableView.estimatedRowHeight = 212.f;
    _myTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    //待付款
    if ([_counterModel.order_wait_payment intValue] == 0) {
        //不显示
        [self.tipNumView2 removeFromSuperview];
    }else{
        //显示
        
        self.tipNumView2.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_wait_payment];
        CGSize size = [self.tipNumView2.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        [segmentedControl addSubview:self.tipNumView2];
        [self.tipNumView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            if ((size.width+9) > 15) {
                make.size.mas_equalTo(CGSizeMake(size.width+9, 14));
            }else{
                make.size.mas_equalTo(CGSizeMake(14, 14));
            }
            make.left.mas_equalTo(segmentedControl.mas_left).with.offset((SCREEN_WIDTH / 5) * 2 - 25 / 667.0 * SCREEN_HEIGHT);
            make.top.mas_equalTo(segmentedControl.mas_top).with.offset(7/667.0*SCREEN_HEIGHT);
        }];
    }
    
    //待发货
    if ([_counterModel.order_ready_goods intValue] == 0) {
        //不显示
        [self.tipNumView3 removeFromSuperview];
    }else{
        //显示
        
        self.tipNumView3.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_ready_goods];
        CGSize size = [self.tipNumView3.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        [segmentedControl addSubview:self.tipNumView3];
        [self.tipNumView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            if ((size.width+9) > 15) {
                make.size.mas_equalTo(CGSizeMake(size.width+9, 14));
            }else{
                make.size.mas_equalTo(CGSizeMake(14, 14));
            }
            make.left.mas_equalTo(segmentedControl.mas_left).with.offset((SCREEN_WIDTH / 5) * 3 - 25 / 667.0 * SCREEN_HEIGHT);
            make.top.mas_equalTo(segmentedControl.mas_top).with.offset(7/667.0*SCREEN_HEIGHT);
        }];
    }
    
    //待收货
    if ([_counterModel.order_sended_goods intValue] == 0) {
        //不显示
        [self.tipNumView4 removeFromSuperview];
    }else{
        //显示
        
        self.tipNumView4.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_sended_goods];
        CGSize size = [self.tipNumView4.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        [segmentedControl addSubview:self.tipNumView4];
        [self.tipNumView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            if ((size.width+9) > 15) {
                make.size.mas_equalTo(CGSizeMake(size.width+9, 14));
            }else{
                make.size.mas_equalTo(CGSizeMake(14, 14));
            }
            make.left.mas_equalTo(segmentedControl.mas_left).with.offset((SCREEN_WIDTH / 5) * 4 - 25 / 667.0 * SCREEN_HEIGHT);
            make.top.mas_equalTo(segmentedControl.mas_top).with.offset(7/667.0*SCREEN_HEIGHT);
        }];
    }
    
    //待评价
    if ([_counterModel.order_evaluate intValue] == 0) {
        //不显示
        [self.tipNumView5 removeFromSuperview];
    }else{
        //显示
        
        self.tipNumView5.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_evaluate];
        CGSize size = [self.tipNumView5.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        [segmentedControl addSubview:self.tipNumView5];
        [self.tipNumView5 mas_makeConstraints:^(MASConstraintMaker *make) {
            if ((size.width+9) > 15) {
                make.size.mas_equalTo(CGSizeMake(size.width+9, 14));
            }else{
                make.size.mas_equalTo(CGSizeMake(14, 14));
            }
            make.left.mas_equalTo(segmentedControl.mas_left).with.offset((SCREEN_WIDTH / 5) * 5 - 25 / 667.0 * SCREEN_HEIGHT);
            make.top.mas_equalTo(segmentedControl.mas_top).with.offset(7/667.0*SCREEN_HEIGHT);
        }];
    }
    
    
    // 下拉刷新
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageNumber = 0;
        [self.orderListAry removeAllObjects];
        [self requestDataForOderListOperationWith:self.type];
    }];
    
    //上拉加载更多
    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentPageNumber < _totalPageNumber) {
            [self requestDataForOderListOperationWith:self.type];
        } else {
            [self.myTableView.mj_footer endRefreshing];
        }
    }];

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDataForOderList];
}

//请求不同状态订单列表
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    self.type = [NSNumber numberWithInteger:segmentedControl.selectedSegmentIndex];
    if (segmentedControl.selectedSegmentIndex == 5) {
        self.type = [NSNumber numberWithInteger:8];
    }
    [self.orderListAry removeAllObjects];
    [self requestDataForOderList];
}

//上拉下拉分页请求订单列表
- (void)requestDataForOderListOperationWith:(NSNumber *)type
{
    NSDictionary * params = @{@"page": [NSNumber numberWithInteger:(_currentPageNumber + 1)], @"size": @10, @"status": type};
    
    FBRequest * request = [FBAPI postWithUrlString:OrderListURL requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary * dataDic = [result objectForKey:@"data"];
        NSArray * rowsAry = [dataDic objectForKey:@"rows"];
        
        for (NSDictionary * orderInfoDic in rowsAry) {
            OrderInfoModel * orderInfo = [[OrderInfoModel alloc] initWithDictionary:orderInfoDic];
            [self.orderListAry addObject:orderInfo];
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
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self requestDataForOderListOperationWith:self.type];
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
        orderInfoCell.orderInfo = self.orderListAry[indexPath.row];
    }
    return orderInfoCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - OrderInfoCellDelegate
- (void)tapProductViewWithOrderInfoCell:(OrderInfoCell *)orderInfoCell
{
    OrderInfoDetailViewController * orderInfoDetailVC = [[OrderInfoDetailViewController alloc] initWithNibName:@"OrderInfoDetailViewController" bundle:nil];
    orderInfoDetailVC.orderInfoCell = orderInfoCell;
    orderInfoDetailVC.delegate = self;
    [self.navigationController pushViewController:orderInfoDetailVC animated:YES];
    //订单详情
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
//            RefundmentViewController * refundmentVC = [[RefundmentViewController alloc] initWithNibName:@"RefundmentViewController" bundle:nil];
//            refundmentVC.orderInfoCell = orderInfoCell;
//            refundmentVC.delegate = self;
//            [self.navigationController pushViewController:refundmentVC animated:YES];
//            NSLog(@"申请退款");
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
            commentVC.orderInfoCell = orderInfoCell;
            commentVC.delegate = self;
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
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:nil];
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
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:nil];
    TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
        FBRequest * request = [FBAPI postWithUrlString:@"/my/cancel_order" requestDictionary:@{@"rid": cell.orderInfo.rid} delegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [self operationActionWithCell:cell];
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
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
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:nil];
    TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
        FBRequest * request = [FBAPI postWithUrlString:@"/shopping/take_delivery" requestDictionary:@{@"rid": cell.orderInfo.rid} delegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [self operationActionWithCell:cell];
            [SVProgressHUD showSuccessWithStatus:@"确认收货成功"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
