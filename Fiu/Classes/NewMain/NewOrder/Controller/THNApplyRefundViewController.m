//
//  THNApplyRefundViewController.m
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNApplyRefundViewController.h"
#import "THNRefundInfoViewController.h"

static NSString *const URLRefundInfo    = @"/shopping/check_refund";
static NSString *const URLApplyRefund   = @"/shopping/apply_product_refund";

@interface THNApplyRefundViewController () {
    NSString *_refundId;
}

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
        NSDictionary *data = [result valueForKey:@"data"];
        [self.applyView thn_setRefundInfoData:data];
        
        [self thn_setViewUI];
        
        [self thn_setApplyData:self.orderId forKey:@"rid"];
        [self thn_setApplyData:[data valueForKey:@"product_id"] forKey:@"sku_id"];
        [self thn_setApplyData:[data valueForKey:@"refund_price"] forKey:@"refund_price"];
        [self thn_setApplyData:[NSString stringWithFormat:@"%zi", self.type] forKey:@"refund_type"];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)post_networkApplyRefundData {
    self.applyRequest = [FBAPI postWithUrlString:URLApplyRefund requestDictionary:self.applyDict delegate:nil];
    [self.applyRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            _refundId = [[result valueForKey:@"data"] valueForKey:@"id"];
            THNRefundInfoViewController *refundInfoVC = [[THNRefundInfoViewController alloc] init];
            refundInfoVC.refundId = _refundId;
            refundInfoVC.type = self.type;
            [self.navigationController pushViewController:refundInfoVC animated:YES];
        }
    
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - 添加申请退款数据
- (void)thn_setApplyData:(NSString *)object forKey:(NSString *)key {
    object = [NSString stringWithFormat:@"%@", object];
    if (object.length > 0 && key.length > 0) {
        [self.applyDict setObject:object forKey:key];
    }
}

- (void)thn_setViewUI {
    [self.view addSubview:self.applyView];
    [self.view addSubview:self.applyBtn];
}

- (THNApplyRefundView *)applyView {
    if (!_applyView) {
        _applyView = [[THNApplyRefundView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        [_applyView thn_setShowType:self.type];
        _applyView.delegate = self;
    }
    return _applyView;
}

- (void)thn_beginChooseRefundReason {
    [_applyView thn_showRefundReasonTable:YES];
}

- (void)thn_doneChooseRefundReasonId:(NSInteger)reasonId {
    [self thn_setApplyData:[NSString stringWithFormat:@"%zi", reasonId] forKey:@"refund_reason"];
}

- (void)thn_finishWritingRefundReason:(NSString *)reason {
    [self thn_setApplyData:reason forKey:@"refund_content"];
}

- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        _applyBtn.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        [_applyBtn setTitle:@"提交申请" forState:(UIControlStateNormal)];
        _applyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_applyBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _applyBtn;
}

- (void)applyBtnClick:(UIButton *)button {
    [self post_networkApplyRefundData];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    if (self.type == 1) {
        self.navViewTitle.text = @"退款";
    } else if (self.type == 2) {
        self.navViewTitle.text = @"退货";
    }
}

#pragma mark - 
- (NSMutableDictionary *)applyDict {
    if (!_applyDict ) {
        _applyDict = [NSMutableDictionary dictionary];
    }
    return _applyDict;
}

@end
