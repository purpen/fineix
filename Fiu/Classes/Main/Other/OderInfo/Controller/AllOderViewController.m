//
//  AllOderViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AllOderViewController.h"
#import "MyOderInfoViewController.h"

@interface AllOderViewController ()<FBNavigationBarItemsDelegate>

@property (weak, nonatomic) IBOutlet UIButton *allOderBtn;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
@property (weak, nonatomic) IBOutlet UIButton *deliveryBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *evaluationBtn;
@property (weak, nonatomic) IBOutlet UIButton *JDBtn;
@property (weak, nonatomic) IBOutlet UIButton *taoBaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *tMBtn;
@property (weak, nonatomic) IBOutlet UIButton *yZBtn;
@property (weak, nonatomic) IBOutlet UIButton *returnGoodsBtn;
@end

@implementation AllOderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"全部订单";
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
    MyOderInfoViewController *vc = [[MyOderInfoViewController alloc] init];
    vc.type = @5;
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
