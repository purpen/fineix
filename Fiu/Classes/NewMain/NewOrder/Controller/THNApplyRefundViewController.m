//
//  THNApplyRefundViewController.m
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNApplyRefundViewController.h"

static NSString *const URLRefundInfo    = @"/shopping/check_refund";
static NSString *const URLApplyRefund   = @"/shopping/apply_product_refund";

@interface THNApplyRefundViewController ()

@end

@implementation THNApplyRefundViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.skuId.length && self.orderId.length) {
        [self post_networkRefundInfoData];
    }
}

- (void)post_networkRefundInfoData {
    [SVProgressHUD show];
    self.refundRequest = [FBAPI postWithUrlString:URLRefundInfo requestDictionary:@{@"rid":self.orderId, @"sku_id":self.skuId} delegate:nil];
    [self.refundRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"=========== 退款申请： %@", result);
        NSDictionary *data = [result valueForKey:@"data"];
        [self.applyView thn_setRefundInfoData:data];
        
        [self thn_setViewUI];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)thn_setViewUI {
    [self.view addSubview:self.applyView];
    [self.view addSubview:self.applyBtn];
}

- (THNApplyRefundView *)applyView {
    if (!_applyView) {
        _applyView = [[THNApplyRefundView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        [_applyView thn_setShowType:self.type];
    }
    return _applyView;
}

- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        _applyBtn.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        [_applyBtn setTitle:@"提交申请" forState:(UIControlStateNormal)];
        _applyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _applyBtn;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"退款";
}

@end
