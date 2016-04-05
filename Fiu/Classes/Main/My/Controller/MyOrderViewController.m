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

@interface MyOrderViewController ()<FBRequestDelegate,UITableViewDelegate,UITableViewDataSource>
{
    //数据源数组
    NSMutableArray *_dataAry;
}
@property (weak, nonatomic) IBOutlet UIButton *allBtn;//全部按钮
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;//待付款按钮
@property (weak, nonatomic) IBOutlet UIButton *sendGoodsBtn;//待发货按钮
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;//待收货按钮
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;//待评价按钮
@property (weak, nonatomic) IBOutlet UITableView *ordertableV;//展示内容的

@end

static NSString *const OrderListURL = @"/shopping/orders";

@implementation MyOrderViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.ordertableV.delegate = self;
    self.ordertableV.dataSource = self;
    _dataAry = [NSMutableArray array];
    [self.allBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateSelected];
    //创建金色小条
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 3)];
    linView.backgroundColor = [UIColor colorWithHexString:fineixColor];
    //设置导航条上的文字
    self.navigationItem.title = @"我的订单";
    //全部按钮被选中颜色变为金色，滑动条滑到全部下面
    self.allBtn.selected = !self.allBtn.selected;
    if (self.allBtn.selected) {
        CGRect frame = linView.frame;
        frame.origin.y = self.allBtn.frame.origin.y + self.allBtn.frame.size.height + 1;
        frame.origin.x = self.allBtn.frame.origin.x;
        frame.size.width = self.allBtn.frame.size.width;
        linView.frame = frame;
        [self.view addSubview:linView];
    }
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
        for (NSDictionary *orderInfoDic in rowsAry) {
            OrderListModel *orderInfo = [[OrderListModel alloc] initWithDictionary:orderInfoDic];
            [_dataAry addObject:orderInfo];
        }
        //tableView数据刷新
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    //当点击待付款按钮时颜色变为金色，滑动条滑到待付款下面
    //进行待付款的网络请求然后进行数据展示
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataAry.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderInfoCell *orderInfoCell = [tableView dequeueReusableCellWithIdentifier:[OrderInfoCell getIdentifer]];
    if (orderInfoCell == nil) {
        orderInfoCell = [OrderInfoCell getOrderInfoCell];
    }
    
    return orderInfoCell;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
