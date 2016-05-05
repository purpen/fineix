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
#import "MyOderModel.h"

@interface MyOderInfoViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate>
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
@end


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
}

-(void)netGetDataWithType:(NSNumber*)type{
    [SVProgressHUD show];
    FBRequest *request = [FBAPI postWithUrlString:@"/shopping/orders" requestDictionary:@{@"page":@(_page),@"size":@15,@"status":type} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary * dataDic = [result objectForKey:@"data"];
        NSArray * rowsAry = [dataDic objectForKey:@"rows"];
        NSLog(@"orderInfoDic      %@",dataDic);
        for (NSDictionary * orderInfoDic in rowsAry) {
            MyOderModel * model = [[MyOderModel alloc] init];
            model.created_at = [orderInfoDic objectForKey:@"created_at"];
            
            [_modelAry addObject:orderInfo];
        }
        [self.orderTableView reloadData];
        [self.mytableView reloadData];
        _page = [[[result valueForKey:@"data"] valueForKey:@"current_page"] intValue];
        _totalePage = [[[result valueForKey:@"data"] valueForKey:@"total_page"] intValue];
        if (_totalePage > 1) {
            [self addMJRefresh:self.mytableView];
            [self requestIsLastData:self.mytableView currentPage:_page withTotalPage:_totalePage];
        }
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];

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
    
    [self netGetDataWithType:@0];

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
//    //进行全部的网络请求然后进行数据展示
//    int currentPageNum = 1;
//    NSDictionary *parameter = @{
//                                @"page":[NSNumber numberWithInteger:currentPageNum],
//                                @"size":@10,
//                                @"status":[NSNumber numberWithUnsignedInteger:1]
//                                };
//    FBRequest *request = [FBAPI postWithUrlString:OrderListURL requestDictionary:parameter delegate:self];
//    [request startRequestSuccess:^(FBRequest *request, id result) {
//        NSDictionary *dataDic = [result objectForKey:@"data"];
//        NSArray *rowsAry = [dataDic objectForKey:@"rows"];
//        [_dataAry removeAllObjects];
//        for (NSDictionary *orderInfoDic in rowsAry) {
//            OrderListModel *orderInfo = [[OrderListModel alloc] initWithDictionary:orderInfoDic];
//            if (orderInfo.orderStatus == 1) {
//                [_dataAry addObject:orderInfo];
//            }
//            
//        }
//        //tableView数据刷新
//        [self.ordertableV reloadData];
//    } failure:^(FBRequest *request, NSError *error) {
//        //提示错误信息
//        
//    }];

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
//    //进行全部的网络请求然后进行数据展示
//    int currentPageNum = 1;
//    NSDictionary *parameter = @{
//                                @"page":[NSNumber numberWithInteger:currentPageNum],
//                                @"size":@10,
//                                @"status":[NSNumber numberWithUnsignedInteger:1]
//                                };
//    FBRequest *request = [FBAPI postWithUrlString:OrderListURL requestDictionary:parameter delegate:self];
//    [request startRequestSuccess:^(FBRequest *request, id result) {
//        NSDictionary *dataDic = [result objectForKey:@"data"];
//        NSArray *rowsAry = [dataDic objectForKey:@"rows"];
//        [_dataAry removeAllObjects];
//        for (NSDictionary *orderInfoDic in rowsAry) {
//            OrderListModel *orderInfo = [[OrderListModel alloc] initWithDictionary:orderInfoDic];
//            if (orderInfo.orderStatus == 10) {
//                [_dataAry addObject:orderInfo];
//            }
//        }
//        //tableView数据刷新
//        [self.ordertableV reloadData];
//    } failure:^(FBRequest *request, NSError *error) {
//        //提示错误信息
//        
//    }];

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
//    //进行全部的网络请求然后进行数据展示
//    int currentPageNum = 1;
//    NSDictionary *parameter = @{
//                                @"page":[NSNumber numberWithInteger:currentPageNum],
//                                @"size":@10,
//                                @"status":[NSNumber numberWithUnsignedInteger:1]
//                                };
//    FBRequest *request = [FBAPI postWithUrlString:OrderListURL requestDictionary:parameter delegate:self];
//    [request startRequestSuccess:^(FBRequest *request, id result) {
//        NSDictionary *dataDic = [result objectForKey:@"data"];
//        NSArray *rowsAry = [dataDic objectForKey:@"rows"];
//        [_dataAry removeAllObjects];
//        for (NSDictionary *orderInfoDic in rowsAry) {
//            OrderListModel *orderInfo = [[OrderListModel alloc] initWithDictionary:orderInfoDic];
//            if (orderInfo.orderStatus == 15) {
//                [_dataAry addObject:orderInfo];
//            }
//        }
//        //tableView数据刷新
//        [self.ordertableV reloadData];
//    } failure:^(FBRequest *request, NSError *error) {
//        //提示错误信息
//        
//    }];

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
//    //进行全部的网络请求然后进行数据展示
//    int currentPageNum = 1;
//    NSDictionary *parameter = @{
//                                @"page":[NSNumber numberWithInteger:currentPageNum],
//                                @"size":@10,
//                                @"status":[NSNumber numberWithUnsignedInteger:1]
//                                };
//    FBRequest *request = [FBAPI postWithUrlString:OrderListURL requestDictionary:parameter delegate:self];
//    [request startRequestSuccess:^(FBRequest *request, id result) {
//        NSDictionary *dataDic = [result objectForKey:@"data"];
//        NSArray *rowsAry = [dataDic objectForKey:@"rows"];
//        [_dataAry removeAllObjects];
//        for (NSDictionary *orderInfoDic in rowsAry) {
//            OrderListModel *orderInfo = [[OrderListModel alloc] initWithDictionary:orderInfoDic];
//            if (orderInfo.orderStatus == 16) {
//                [_dataAry addObject:orderInfo];
//            }
//        }
//        //tableView数据刷新
//        [self.ordertableV reloadData];
//    } failure:^(FBRequest *request, NSError *error) {
//        //提示错误信息
//        
//    }];
//
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderInfoCell *orderInfoCell = [tableView dequeueReusableCellWithIdentifier:[OrderInfoCell getIdentifer]];
    if (orderInfoCell == nil) {
        orderInfoCell = [OrderInfoCell getOrderInfoCell];
    }
    return orderInfoCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
