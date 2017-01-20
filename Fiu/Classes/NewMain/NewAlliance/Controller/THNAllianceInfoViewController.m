//
//  THNAllianceInfoViewController.m
//  Fiu
//
//  Created by FLYang on 2017/1/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNAllianceInfoViewController.h"

static NSString *const URLAllianceInfo = @"/alliance/info";

@interface THNAllianceInfoViewController ()

@end

@implementation THNAllianceInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_networkAllianceInfoData];
    [self.view addSubview:self.infoText];
}

- (void)thn_networkAllianceInfoData {
    self.infoRequest = [FBAPI postWithUrlString:URLAllianceInfo requestDictionary:@{} delegate:self];
    [self.infoRequest startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dict = [result valueForKey:@"data"];
        [self thn_setAllianceInfoText:dict[@"info"]];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)thn_setAllianceInfoText:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, text.length)];
    self.infoText.attributedText = attStr;
}

- (UITextView *)infoText {
    if (!_infoText) {
        _infoText = [[UITextView alloc] initWithFrame:CGRectMake(15, 64, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 64)];
        _infoText.font = [UIFont systemFontOfSize:14];
        _infoText.textColor = [UIColor colorWithHexString:@"#222222"];
        _infoText.editable = NO;
        _infoText.showsVerticalScrollIndicator = NO;
//        _infoLabel.text = @"可提现金额：是指当前帐户可以提现的金额，您可以随时申请提现。我的收益：交易记录里的佣金状态变为“已结算”状态后，该笔订单商品对应的“佣金”会计入帐户的“可提现金额”。已结算收入会持续累加，即累计您所有已结算的金额。已提现金额：帐户以往提现金额的总和。交易记录里佣金状态何时会变为“已结算”? 订单状态为“完成交易”（用户确认收货并发表评价）并且对产生佣金的订单无退款退货行为，佣金状态变更为“待结算”。系统会在第二天完成结算统计并生成相应的结算单，同时被结算的交易单更新为”已结算“。注：用户收货后无操作，系统默认自发货时间起至15日内完成交易。如何查看订单结算记录？你可以在结算记录里，查询结算交易的产品数量以及佣金，在结算明细里可以详细的看到佣金来源订单的商品。如何提现：您可以随时将可提现金额提现，每次提现须大于100元，提现需要1~2个工作日的人工审核，通过审核后，相应款项会打入您的提现账户。您可以在“提现记录”页面，查看每笔提现的状态。";
    }
    return _infoText;
}

//- (UIWebView *)infoWebView {
//    if (!_infoWebView) {
//        _infoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
//        _infoWebView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
//        _infoWebView.delegate = self;
//    }
//    return _infoWebView;
//}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [SVProgressHUD show];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [SVProgressHUD dismiss];
//}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"结算规则";
}


@end
