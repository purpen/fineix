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

@interface MyOrderViewController ()<FBRequestDelegate>
{
    //数据源数组
    NSMutableArray *_dataAry;
}
@property (weak, nonatomic) IBOutlet UIButton *allBtn;//全部按钮
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;//待付款按钮
@property (weak, nonatomic) IBOutlet UIButton *sendGoodsBtn;//待发货按钮
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;//待收货按钮
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;//待评价按钮

@end

static NSString *const OrderListURL = @"/shopping/orders";

@implementation MyOrderViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _dataAry = [NSMutableArray array];
    //创建金色小条
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 3)];
    linView.backgroundColor = [UIColor colorWithRed:190 green:137 blue:20 alpha:1];
    //设置导航条上的文字
    self.navigationItem.title = @"我的订单";
    //全部按钮被选中颜色变为金色，滑动条滑到全部下面
    self.allBtn.selected = !self.allBtn.selected;
    if (self.allBtn.selected) {
        self.allBtn.backgroundColor = [UIColor colorWithRed:190 green:137 blue:20 alpha:1];
        CGRect frame = linView.frame;
        frame.origin.y = self.allBtn.frame.origin.y + self.allBtn.frame.size.height + 2;
        frame.origin.x = self.allBtn.frame.origin.x;
        frame.size.width = self.allBtn.frame.size.width;
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
            
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    //当点击待付款按钮时颜色变为金色，滑动条滑到待付款下面
    //进行待付款的网络请求然后进行数据展示
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
