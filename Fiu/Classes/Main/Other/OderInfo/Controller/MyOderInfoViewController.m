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

@interface MyOderInfoViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate,OrderInfoCellDelegate>
{
    //创建金色小条
    UIView *_linView;
    NSMutableArray *_modelAry;
    int _page;
    int _totalePage;
}
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendGoodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *chanelView;

@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;
@property (nonatomic,strong) NSMutableArray *orderListAry;
@end

static NSString *const OrderListURL = @"/shopping/orders";
static NSString *const OrderInfoCellIdentifier = @"orderInfoCell";

@implementation MyOderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelAry = [NSMutableArray array];
    _page = 1;
    self.delegate = self;
    self.navViewTitle.text = @"我的订单";
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    //tableView每个row的高度
    self.myTableView.rowHeight = 222;
    //创建金色小条
    _linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 3)];
    _linView.backgroundColor = [UIColor colorWithHexString:fineixColor];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.type isEqualToNumber:@0]) {
       [self allBtn:self.allBtn];
    }else if ([self.type isEqualToNumber:@1]){
        [self payMentBtn:self.paymentBtn];
    }else if ([self.type isEqualToNumber:@2]){
        [self sendGoodsBtn:self.sendGoodsBtn];
    }else if ([self.type isEqualToNumber:@3]){
        [self goodsBtn:self.goodsBtn];
    }else if ([self.type isEqualToNumber:@4]){
        [self evaluateBtn:self.evaluateBtn];
    }
    
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderInfoCell" bundle:nil] forCellReuseIdentifier:OrderInfoCellIdentifier];
    _myTableView.estimatedRowHeight = 212.f;
    _myTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self requestDataForOderList];
    
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

//上拉下拉分页请求订单列表
- (void)requestDataForOderListOperationWith:(NSNumber *)type
{
    NSDictionary * params = @{@"page": [NSNumber numberWithInteger:(_currentPageNumber + 1)], @"size": @10, @"status": type};
    
    FBRequest * request = [FBAPI postWithUrlString:OrderListURL requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary * dataDic = [result objectForKey:@"data"];
        NSArray * rowsAry = [dataDic objectForKey:@"rows"];
        
        NSLog(@"订单  %@",result);
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


- (IBAction)allBtn:(UIButton *)sender {
    self.allBtn.selected = YES;
    self.paymentBtn.selected = NO;
    self.sendGoodsBtn.selected = NO;
    self.goodsBtn.selected = NO;
    self.evaluateBtn.selected = NO;
    CGRect frame = _linView.frame;
    frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 1;
    frame.origin.x = sender.frame.origin.x+9;
    frame.size.width = sender.frame.size.width-18;
    _linView.frame = frame;
    [self.chanelView addSubview:_linView];
    self.type = @0;
    [self requestDataForOderList];

}
- (IBAction)payMentBtn:(UIButton *)sender {
    self.allBtn.selected = NO;
    self.paymentBtn.selected = YES;
    self.sendGoodsBtn.selected = NO;
    self.goodsBtn.selected = NO;
    self.evaluateBtn.selected = NO;
    CGRect frame = _linView.frame;
    frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 1;
    frame.origin.x = sender.frame.origin.x+9;
    frame.size.width = sender.frame.size.width-18;
    _linView.frame = frame;
    [self.chanelView addSubview:_linView];
    self.type = @1;
    [self requestDataForOderList];

}
- (IBAction)sendGoodsBtn:(UIButton *)sender {
    self.allBtn.selected = NO;
    self.paymentBtn.selected = NO;
    self.sendGoodsBtn.selected = YES;
    self.goodsBtn.selected = NO;
    self.evaluateBtn.selected = NO;
    CGRect frame = _linView.frame;
    frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 1;
    frame.origin.x = sender.frame.origin.x+9;
    frame.size.width = sender.frame.size.width-18;
    _linView.frame = frame;
    [self.chanelView addSubview:_linView];
    self.type = @2;
    [self requestDataForOderList];

}
- (IBAction)goodsBtn:(UIButton *)sender {
    self.allBtn.selected = NO;
    self.paymentBtn.selected = NO;
    self.sendGoodsBtn.selected = NO;
    self.goodsBtn.selected = YES;
    self.evaluateBtn.selected = NO;
    CGRect frame = _linView.frame;
    frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 1;
    frame.origin.x = sender.frame.origin.x+9;
    frame.size.width = sender.frame.size.width-18;
    _linView.frame = frame;
    [self.chanelView addSubview:_linView];
    self.type = @3;
    [self requestDataForOderList];

}
- (IBAction)evaluateBtn:(UIButton *)sender {
    self.allBtn.selected = NO;
    self.paymentBtn.selected = NO;
    self.sendGoodsBtn.selected = NO;
    self.goodsBtn.selected = NO;
    self.evaluateBtn.selected = YES;
    CGRect frame = _linView.frame;
    frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 1;
    frame.origin.x = sender.frame.origin.x+9;
    frame.size.width = sender.frame.size.width-18;
    _linView.frame = frame;
    [self.chanelView addSubview:_linView];
    self.type = @4;
    [self requestDataForOderList];
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
//    OrderInfoDetailViewController * orderInfoDetailVC = [[OrderInfoDetailViewController alloc] initWithNibName:@"OrderInfoDetailViewController" bundle:nil];
//    orderInfoDetailVC.orderInfoCell = orderInfoCell;
//    orderInfoDetailVC.delegate = self;
//    [self.navigationController pushViewController:orderInfoDetailVC animated:YES];
    //订单详情
    NSLog(@"订单详情");
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
//            FBPayTheWayViewController * payWayVC = [[FBPayTheWayViewController alloc] init];
//            payWayVC.orderInfo = orderInfoCell.orderInfo;
//            [self.navigationController pushViewController:payWayVC animated:YES];
            NSLog(@"立即支付");
        }
            break;
        case OrderInfoStateWaitDelivery://申请退款
        {
//            RefundmentViewController * refundmentVC = [[RefundmentViewController alloc] initWithNibName:@"RefundmentViewController" bundle:nil];
//            refundmentVC.orderInfoCell = orderInfoCell;
//            refundmentVC.delegate = self;
//            [self.navigationController pushViewController:refundmentVC animated:YES];
            NSLog(@"申请退款");
        }
            break;
        case OrderInfoStateWaitReceive://确认收货
        {
            [self confirmReceiptWithCell:orderInfoCell];
        }
            break;
        case OrderInfoStateWaitComment://去评价
        {
//            CommentViewController * commentVC = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
//            commentVC.orderInfoCell = orderInfoCell;
//            commentVC.delegate = self;
//            [self.navigationController pushViewController:commentVC animated:YES];
            NSLog(@"去评价");
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
