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
#import "NSObject+MJKeyValue.h"
#import "SVProgressHUD.h"
#import "TaoBaoOrderViewController.h"
#import "JDOrderViewController.h"
#import "TianMaoOrderViewController.h"
#import "THNUserData.h"

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
@property(nonatomic,strong) TipNumberView *order_wait_paymentTipView;
@property(nonatomic,strong) TipNumberView *order_ready_goodsTipView;
@property(nonatomic,strong) TipNumberView *order_sended_goodsTipView;
@property(nonatomic,strong) TipNumberView *order_evaluateTipView;

@end

@implementation AllOderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self netGetData];
}

-(void)netGetData{
    THNUserData *userData = [[THNUserData findAll] lastObject];
    FBRequest *request = [FBAPI postWithUrlString:@"/user/user_info" requestDictionary:@{@"user_id":userData.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = result[@"data"];
        NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
        self.counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
        //-----------------------------------------------------
        [self addTipViewWithNum:[self.counterModel.order_wait_payment intValue] andTipView:self.order_wait_paymentTipView andBtn:self.paymentBtn];
        [self addTipViewWithNum:[self.counterModel.order_ready_goods intValue] andTipView:self.order_ready_goodsTipView andBtn:self.deliveryBtn];
        [self addTipViewWithNum:[self.counterModel.order_sended_goods intValue] andTipView:self.order_sended_goodsTipView andBtn:self.goodsBtn];
        [self addTipViewWithNum:[self.counterModel.order_evaluate intValue] andTipView:self.order_evaluateTipView andBtn:self.evaluationBtn];
        //------------------------------------------------------
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.navViewTitle.text = @"全部订单";
}

-(void)addTipViewWithNum:(NSInteger)num andTipView:(TipNumberView*)tipView andBtn:(UIButton*)btn{
    if (num == 0) {
        //不显示
        [tipView removeFromSuperview];
    }else{
        //显示
        tipView.tipNumLabel.text = [NSString stringWithFormat:@"%zi",num];
        CGSize size = [tipView.tipNumLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        [btn addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            if ((size.width+9) > 15) {
                make.size.mas_equalTo(CGSizeMake(size.width+9, 15));
            }else{
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }
            make.right.mas_equalTo(btn.mas_right).with.offset(-7/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(btn.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
        }];
    }
}

-(TipNumberView *)order_evaluateTipView{
    if (!_order_evaluateTipView) {
        _order_evaluateTipView = [TipNumberView getTipNumView];
    }
    return _order_evaluateTipView;
}

-(TipNumberView *)order_ready_goodsTipView{
    if (!_order_ready_goodsTipView) {
        _order_ready_goodsTipView = [TipNumberView getTipNumView];
    }
    return _order_ready_goodsTipView;
}

-(TipNumberView *)order_sended_goodsTipView{
    if (!_order_sended_goodsTipView) {
        _order_sended_goodsTipView = [TipNumberView getTipNumView];
    }
    return _order_sended_goodsTipView;
}

-(TipNumberView *)order_wait_paymentTipView{
    if (!_order_wait_paymentTipView) {
        _order_wait_paymentTipView = [TipNumberView getTipNumView];
    }
    return _order_wait_paymentTipView;
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


- (IBAction)jDOrderBtn:(UIButton *)sender {
    JDOrderViewController *vc = [[JDOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)taoBaoOrderBtn:(UIButton *)sender {
    TaoBaoOrderViewController *vc = [[TaoBaoOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)tianMaoOrderBtn:(UIButton *)sender {
    TianMaoOrderViewController *vc = [[TianMaoOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
