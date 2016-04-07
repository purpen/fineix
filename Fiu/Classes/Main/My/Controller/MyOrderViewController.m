//
//  MyOrderViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyOrderViewController.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "OrderListModel.h"
#import "OrderInfoCell.h"
#import "Fiu.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyOrderViewController ()<FBRequestDelegate,UITableViewDelegate,UITableViewDataSource>
{
    //数据源数组
    NSMutableArray *_dataAry;
    //创建金色小条
    UIView *_linView;
}
@property (weak, nonatomic) IBOutlet UIButton *allBtn;//全部按钮
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;//待付款按钮
@property (weak, nonatomic) IBOutlet UIButton *sendGoodsBtn;//待发货按钮
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;//待收货按钮
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;//待评价按钮
@property (weak, nonatomic) IBOutlet UITableView *ordertableV;//展示内容的
@property (weak, nonatomic) IBOutlet UIView *chanelView;//上面的频道view

@end

static NSString *const OrderListURL = @"/shopping/orders";

@implementation MyOrderViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.ordertableV.delegate = self;
    self.ordertableV.dataSource = self;
    _dataAry = [NSMutableArray array];
    
    //tableView每个row的高度
    self.ordertableV.rowHeight = 222;
    

    //创建金色小条
    _linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 3)];
    _linView.backgroundColor = [UIColor colorWithHexString:fineixColor];
    //设置导航条上的文字
    self.navigationItem.title = @"我的订单";
    //设置按钮颜色
    [self.allBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateSelected];
    [self.paymentBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateSelected];
    [self.sendGoodsBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateSelected];
    [self.goodsBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateSelected];
    [self.evaluateBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateSelected];
    [self allBtn:self.allBtn];
    
}

//全部按钮
- (IBAction)allBtn:(UIButton *)sender {
    self.allBtn.selected = YES;
    self.paymentBtn.selected = NO;
    self.sendGoodsBtn.selected = NO;
    self.goodsBtn.selected = NO;
    self.evaluateBtn.selected = NO;
    CGRect frame = _linView.frame;
    frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 1;
    frame.origin.x = sender.frame.origin.x;
    frame.size.width = sender.frame.size.width;
    _linView.frame = frame;
    [self.chanelView addSubview:_linView];
    //进行全部的网络请求然后进行数据展示
    int currentPageNum = 1;
    NSDictionary *parameter = @{
                                @"page":[NSNumber numberWithInteger:currentPageNum],
                                @"size":@10,
                                @"status":[NSNumber numberWithUnsignedInteger:0]
                                };
    FBRequest *request = [FBAPI postWithUrlString:OrderListURL requestDictionary:parameter delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDic = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDic objectForKey:@"rows"];
        [_dataAry removeAllObjects];
        for (NSDictionary *orderInfoDic in rowsAry) {
            OrderListModel *orderInfo = [[OrderListModel alloc] initWithDictionary:orderInfoDic];
            [_dataAry addObject:orderInfo];
        }
        //tableView数据刷新
        [self.ordertableV reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        //提示错误信息
        
    }];

}

//待付款按钮
- (IBAction)paymentBtn:(UIButton *)sender {
    self.allBtn.selected = NO;
    self.paymentBtn.selected = YES;
    self.sendGoodsBtn.selected = NO;
    self.goodsBtn.selected = NO;
    self.evaluateBtn.selected = NO;
    CGRect frame = _linView.frame;
    frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 1;
    frame.origin.x = sender.frame.origin.x;
    frame.size.width = sender.frame.size.width;
    _linView.frame = frame;
    [self.chanelView addSubview:_linView];
    //进行全部的网络请求然后进行数据展示
    int currentPageNum = 1;
    NSDictionary *parameter = @{
                                @"page":[NSNumber numberWithInteger:currentPageNum],
                                @"size":@10,
                                @"status":[NSNumber numberWithUnsignedInteger:1]
                                };
    FBRequest *request = [FBAPI postWithUrlString:OrderListURL requestDictionary:parameter delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDic = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDic objectForKey:@"rows"];
        [_dataAry removeAllObjects];
        for (NSDictionary *orderInfoDic in rowsAry) {
            OrderListModel *orderInfo = [[OrderListModel alloc] initWithDictionary:orderInfoDic];
            if (orderInfo.orderStatus == 1) {
                [_dataAry addObject:orderInfo];
            }
            
        }
        //tableView数据刷新
        [self.ordertableV reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        //提示错误信息
        
    }];
}

//待发货按钮
- (IBAction)sendGoods:(UIButton *)sender {
    self.allBtn.selected = NO;
    self.paymentBtn.selected = NO;
    self.sendGoodsBtn.selected = YES;
    self.goodsBtn.selected = NO;
    self.evaluateBtn.selected = NO;
    CGRect frame = _linView.frame;
    frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 1;
    frame.origin.x = sender.frame.origin.x;
    frame.size.width = sender.frame.size.width;
    _linView.frame = frame;
    [self.chanelView addSubview:_linView];
    //进行全部的网络请求然后进行数据展示
    int currentPageNum = 1;
    NSDictionary *parameter = @{
                                @"page":[NSNumber numberWithInteger:currentPageNum],
                                @"size":@10,
                                @"status":[NSNumber numberWithUnsignedInteger:1]
                                };
    FBRequest *request = [FBAPI postWithUrlString:OrderListURL requestDictionary:parameter delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDic = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDic objectForKey:@"rows"];
        [_dataAry removeAllObjects];
        for (NSDictionary *orderInfoDic in rowsAry) {
            OrderListModel *orderInfo = [[OrderListModel alloc] initWithDictionary:orderInfoDic];
            if (orderInfo.orderStatus == 10) {
                [_dataAry addObject:orderInfo];
            }
        }
        //tableView数据刷新
        [self.ordertableV reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        //提示错误信息
        
    }];
}

//待收货按钮
- (IBAction)forGoods:(UIButton *)sender {
    self.allBtn.selected = NO;
    self.paymentBtn.selected = NO;
    self.sendGoodsBtn.selected = NO;
    self.goodsBtn.selected = YES;
    self.evaluateBtn.selected = NO;
    CGRect frame = _linView.frame;
    frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 1;
    frame.origin.x = sender.frame.origin.x;
    frame.size.width = sender.frame.size.width;
    _linView.frame = frame;
    [self.chanelView addSubview:_linView];
    //进行全部的网络请求然后进行数据展示
    int currentPageNum = 1;
    NSDictionary *parameter = @{
                                @"page":[NSNumber numberWithInteger:currentPageNum],
                                @"size":@10,
                                @"status":[NSNumber numberWithUnsignedInteger:1]
                                };
    FBRequest *request = [FBAPI postWithUrlString:OrderListURL requestDictionary:parameter delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDic = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDic objectForKey:@"rows"];
        [_dataAry removeAllObjects];
        for (NSDictionary *orderInfoDic in rowsAry) {
            OrderListModel *orderInfo = [[OrderListModel alloc] initWithDictionary:orderInfoDic];
            if (orderInfo.orderStatus == 15) {
                [_dataAry addObject:orderInfo];
            }
        }
        //tableView数据刷新
        [self.ordertableV reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        //提示错误信息
        
    }];
}

//待评价按钮
- (IBAction)toEvaluate:(UIButton *)sender {
    self.allBtn.selected = NO;
    self.paymentBtn.selected = NO;
    self.sendGoodsBtn.selected = NO;
    self.goodsBtn.selected = NO;
    self.evaluateBtn.selected = YES;
    CGRect frame = _linView.frame;
    frame.origin.y = sender.frame.origin.y + sender.frame.size.height + 1;
    frame.origin.x = sender.frame.origin.x;
    frame.size.width = sender.frame.size.width;
    _linView.frame = frame;
    [self.chanelView addSubview:_linView];
    //进行全部的网络请求然后进行数据展示
    int currentPageNum = 1;
    NSDictionary *parameter = @{
                                @"page":[NSNumber numberWithInteger:currentPageNum],
                                @"size":@10,
                                @"status":[NSNumber numberWithUnsignedInteger:1]
                                };
    FBRequest *request = [FBAPI postWithUrlString:OrderListURL requestDictionary:parameter delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDic = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDic objectForKey:@"rows"];
        [_dataAry removeAllObjects];
        for (NSDictionary *orderInfoDic in rowsAry) {
            OrderListModel *orderInfo = [[OrderListModel alloc] initWithDictionary:orderInfoDic];
            if (orderInfo.orderStatus == 16) {
                [_dataAry addObject:orderInfo];
            }
        }
        //tableView数据刷新
        [self.ordertableV reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        //提示错误信息
        
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataAry.count+2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderInfoCell *orderInfoCell = [tableView dequeueReusableCellWithIdentifier:[OrderInfoCell getIdentifer]];
    if (orderInfoCell == nil) {
        orderInfoCell = [OrderInfoCell getOrderInfoCell];
    }
    if (_dataAry.count) {
        OrderListModel *orderInfo = _dataAry[indexPath.row];
        orderInfoCell.nameLabel.text = orderInfo.name;
        orderInfoCell.dateLabel.text = orderInfo.createdAt;
        orderInfoCell.transactionStatus.text = orderInfo.statusLabel;
        orderInfoCell.theFreightLabel.text = [NSString stringWithFormat:@"(含运费￥%.2f)",orderInfo.freight];
        orderInfoCell.theTotalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",orderInfo.totalMoney];
        orderInfoCell.theNumberLabel.text = [NSString stringWithFormat:@"共%ld件商品",(long)orderInfo.itemsCount];
        [orderInfoCell.coverImage sd_setImageWithURL:[NSURL URLWithString:orderInfo.coverUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        orderInfoCell.colorLabel.text = [NSString stringWithFormat:@"%@,",orderInfo.skuName];
        orderInfoCell.theNumLabelTwo.text = [NSString stringWithFormat:@"数量*%ld",(long)orderInfo.quantity];
        orderInfoCell.theUnitPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",orderInfo.salePrice];
        if (orderInfo.orderStatus == 20) {
            //订单完成
            [orderInfoCell.multiFunctionBtn setImage:[UIImage imageNamed:@"deleteTheOrder"] forState:UIControlStateNormal];
            [orderInfoCell.cancelTheOrderBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if (orderInfo.orderStatus == 1 || orderInfo.orderStatus == 10) {
            //待付款 待发货
            [orderInfoCell.multiFunctionBtn setImage:[UIImage imageNamed:@"immediatePayment"] forState:UIControlStateNormal];
            [orderInfoCell.cancelTheOrderBtn setImage:[UIImage imageNamed:@"cancelTheOrder"] forState:UIControlStateNormal];
        }
        if (orderInfo.orderStatus == 15) {
            //待收货
            [orderInfoCell.multiFunctionBtn setImage:[UIImage imageNamed:@"confirmTheGoods"] forState:UIControlStateNormal];
            [orderInfoCell.cancelTheOrderBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if (orderInfo.orderStatus == 16) {
            //待收货
            [orderInfoCell.multiFunctionBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
            [orderInfoCell.cancelTheOrderBtn setImage:[UIImage imageNamed:@"deleteTheOrder"] forState:UIControlStateNormal];
        }
    }
    return orderInfoCell;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
