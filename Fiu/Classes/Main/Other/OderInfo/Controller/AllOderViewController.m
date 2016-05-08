//
//  AllOderViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AllOderViewController.h"
#import "MyOderInfoViewController.h"
#import "TipNumberView.h"
#import "Fiu.h"
#import "CounterModel.h"
#import "ReturnViewController.h"

@interface AllOderViewController ()<FBNavigationBarItemsDelegate>

@property (weak, nonatomic) IBOutlet UIButton *allOderBtn;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
@property (weak, nonatomic) IBOutlet UIButton *deliveryBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *evaluationBtn;
@property (weak, nonatomic) IBOutlet UIButton *JDBtn;
@property (weak, nonatomic) IBOutlet UIButton *taoBaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *tMBtn;
@property (weak, nonatomic) IBOutlet UIButton *returnGoodsBtn;
@property (weak, nonatomic) IBOutlet UIView *chanelView;
@end

@implementation AllOderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"全部订单";
    
    if ([self.counterModel.order_wait_payment intValue] == 0) {
        //不显示
        
    }else{
        //显示
        TipNumberView *tipNumView = [TipNumberView getTipNumView];
        tipNumView.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_wait_payment];
        [self.paymentBtn addSubview:tipNumView];
        [tipNumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15/667.0*SCREEN_HEIGHT, 15/667.0*SCREEN_HEIGHT));
            make.right.mas_equalTo(self.paymentBtn.mas_right).with.offset(-7/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.paymentBtn.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
    }

    if ([self.counterModel.order_ready_goods intValue] == 0) {
        //不显示
        
    }else{
        //显示
        TipNumberView *tipNumView = [TipNumberView getTipNumView];
        tipNumView.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_ready_goods];
        [self.deliveryBtn addSubview:tipNumView];
        [tipNumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15/667.0*SCREEN_HEIGHT, 15/667.0*SCREEN_HEIGHT));
            make.right.mas_equalTo(self.deliveryBtn.mas_right).with.offset(-7/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.deliveryBtn.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
    }
    
    if ([self.counterModel.order_sended_goods intValue] == 0) {
        //不显示
        
    }else{
        //显示
        TipNumberView *tipNumView = [TipNumberView getTipNumView];
        tipNumView.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_sended_goods];
        [self.goodsBtn addSubview:tipNumView];
        [tipNumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15/667.0*SCREEN_HEIGHT, 15/667.0*SCREEN_HEIGHT));
            make.right.mas_equalTo(self.goodsBtn.mas_right).with.offset(-7/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.goodsBtn.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
    }
    
    
    
    if ([self.counterModel.order_evaluate intValue] == 0) {
        //不显示
        
    }else{
        //显示
        TipNumberView *tipNumView = [TipNumberView getTipNumView];
        tipNumView.tipNumLabel.text = [NSString stringWithFormat:@"%@",_counterModel.order_evaluate];
        [self.evaluationBtn addSubview:tipNumView];
        [tipNumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15/667.0*SCREEN_HEIGHT, 15/667.0*SCREEN_HEIGHT));
            make.right.mas_equalTo(self.evaluationBtn.mas_right).with.offset(-7/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.evaluationBtn.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
    }
    
}
- (IBAction)allOderBtn:(UIButton *)sender {
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @0;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)paymentBtn:(UIButton *)sender {
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @1;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)deliveryBtn:(UIButton *)sender {
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @2;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)goodsBtn:(UIButton *)sender {
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @3;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)evaluationBtn:(UIButton *)sender {
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @4;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)returnGoodsBtn:(UIButton *)sender {
    ReturnViewController *vc = [[ReturnViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
