//
//  FBPayTheWayViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPayTheWayViewController.h"
#import "Fiu.h"
#import "TYAlertView.h"
#import "UIView+TYAlertView.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import "OrderInfoModel.h"
#import "SVProgressHUD.h"
#import "WXSignParams.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GoodsCarViewController.h"
#import "PaySuccessViewController.h"
#import "JDPayViewController.h"

#define wayBtnTag 55
#define chooseBtnTag 66

@interface FBPayTheWayViewController ()<FBNavigationBarItemsDelegate,WXApiDelegate, AlipayDelegate>
@property (nonatomic, assign) NSInteger paymentWay;
@end

@implementation FBPayTheWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navViewTitle.text = @"支付方式";
    [self addBarItemLeftBarButton:nil image:@"icon_back" isTransparent:NO];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1" alpha:1];
    
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.wxDelegate = self;
    appDelegate.aliDelegate = self;
    
    [self loadingPayWayView];

    // Do any additional setup after loading the view from its nib.
}

- (void)loadingPayWayView {
    [self.view addSubview:self.payTheWayView];
    
    NSArray * payTitleArr = [NSArray arrayWithObjects:@"支付宝",@"微信支付",@"京东支付", nil];
    NSArray * payImgArr = [NSArray arrayWithObjects:@"zhifubao",@"weixinpay",@"jingDong", nil];
    for (NSInteger idx = 0; idx < payTitleArr.count; idx++) {
        UIButton * wayBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 70+ 60*idx, SCREEN_WIDTH, 50)];
        wayBtn.backgroundColor = [UIColor whiteColor];
        wayBtn.tag = idx + wayBtnTag;
        if (wayBtn.tag == wayBtnTag) {
            wayBtn.selected = YES;
            self.wayBtnSelected = wayBtn;
        }
        [wayBtn addTarget:self action:@selector(wayBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.payTheWayView addSubview:wayBtn];
        
        UIButton * chooseBtn = [[UIButton alloc] init];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"Check"] forState:(UIControlStateNormal)];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"Check_red"] forState:(UIControlStateSelected)];
        chooseBtn.userInteractionEnabled = NO;
        chooseBtn.tag = idx + chooseBtnTag;
        if (chooseBtn.tag == chooseBtnTag) {
            self.chooseAliPayBtn = chooseBtn;
        } else if (chooseBtn.tag == chooseBtnTag + 1) {
            self.chooseWeChatBtn = chooseBtn;
        }else if (chooseBtn.tag == chooseBtnTag + 2){
            self.chooseJDPayBtn = chooseBtn;
        }
        
        [wayBtn addSubview:chooseBtn];
        [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(18.5, 18.5));
            make.centerY.equalTo(wayBtn);
            make.left.equalTo(wayBtn.mas_left).with.offset(15);
        }];
        
        UIImageView * wayIconImg = [[UIImageView alloc] init];
        wayIconImg.image = [UIImage imageNamed:payImgArr[idx]];
        [wayBtn addSubview:wayIconImg];
        [wayIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
            make.centerY.equalTo(wayBtn);
            make.left.equalTo(wayBtn.mas_left).with.offset(50);
        }];
        
        UILabel * wayTitleLab = [[UILabel alloc] init];
        wayTitleLab.text = payTitleArr[idx];
        if (IS_iOS9) {
            wayTitleLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            wayTitleLab.font = [UIFont systemFontOfSize:13];
        }
        [wayBtn addSubview:wayTitleLab];
        [wayTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 14));
            make.centerY.equalTo(wayIconImg);
            make.left.equalTo(wayIconImg.mas_right).with.offset(10);
        }];
    }
}

- (void)wayBtnClick:(UIButton *)button {
    if (button.tag == wayBtnTag) {
        self.chooseAliPayBtn.selected = YES;
        self.chooseWeChatBtn.selected = NO;
        self.chooseJDPayBtn.selected = NO;
        self.paymentWay = 1;
    } else if (button.tag == wayBtnTag +1) {
        self.chooseWeChatBtn.selected = YES;
        self.chooseAliPayBtn.selected = NO;
        self.chooseJDPayBtn.selected = NO;
        self.paymentWay = 2;
    }else if (button.tag == wayBtnTag + 2){
        self.chooseWeChatBtn.selected = NO;
        self.chooseAliPayBtn.selected = NO;
        self.chooseJDPayBtn.selected = YES;
        self.paymentWay = 3;
    }
}

#pragma mark 视图
- (UIView *)payTheWayView {
    if (!_payTheWayView) {
        _payTheWayView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _payTheWayView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1" alpha:1];
        [_payTheWayView addSubview:self.okPayBtn];
        [_okPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
            make.bottom.equalTo(_payTheWayView.mas_bottom).with.offset(0);
            make.centerX.equalTo(_payTheWayView);
        }];
        
        [_payTheWayView addSubview:self.payWayView];
    }
    return _payTheWayView;
}

- (UIView *)payWayView {
    if (!_payWayView) {
        _payWayView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
        _payWayView.backgroundColor = [UIColor whiteColor];
        
        self.payWayTitleView = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 50)];
        self.payWayTitleView.text = @"请选择支付方式";
        self.payWayTitleView.textColor = [UIColor colorWithHexString:@"#666666" alpha:1];
        if (IS_iOS9) {
            self.payWayTitleView.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            self.payWayTitleView.font = [UIFont systemFontOfSize:14];
        }
        [_payWayView addSubview:self.payWayTitleView];
        
        self.payPrice = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, SCREEN_WIDTH-170, 50)];
        self.payPrice.text = [NSString stringWithFormat:@"￥%.2f", [self.orderInfo.payMoney floatValue]];
        self.payPrice.textAlignment = NSTextAlignmentRight;
        self.payPrice.textColor = [UIColor colorWithHexString:fineixColor];
        if (IS_iOS9) {
            self.payPrice.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            self.payPrice.font = [UIFont systemFontOfSize:14];
        }
        [_payWayView addSubview:self.payPrice];
    }
    return _payWayView;
}

#pragma mark 确认付款第三方支付
- (UIButton *)okPayBtn {
    if (!_okPayBtn) {
        _okPayBtn = [[UIButton alloc] init];
        _okPayBtn.backgroundColor = [UIColor colorWithHexString:fineixColor alpha:1];
        [_okPayBtn setTitle:@"立即支付" forState:(UIControlStateNormal)];
        [_okPayBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _okPayBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _okPayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [_okPayBtn addTarget:self action:@selector(okPayClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _okPayBtn;
}

- (void)okPayClick {
    if (self.chooseAliPayBtn.selected == NO && self.chooseWeChatBtn.selected == NO && self.chooseJDPayBtn.selected == NO) {
        [SVProgressHUD showInfoWithStatus:@"请选择支付方式"];
    } else {
        //跳转到第三方支付软件
        switch (self.paymentWay) {
            case 1: //支付宝
            {
                FBRequest * request = [FBAPI postWithUrlString:@"/shopping/payed" requestDictionary:@{@"rid": self.orderInfo.rid, @"payaway": @"alipay"} delegate:self];
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                
                [request startRequestSuccess:^(FBRequest *request, id result) {
                    
                    NSDictionary * dataDic = [result objectForKey:@"data"];
                    
                    [[AlipaySDK defaultService] payOrder:[dataDic objectForKey:@"str"] fromScheme:@"ali2016051201393610" callback:^(NSDictionary *resultDic) {
                        if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                            [self checkOrderInfoForPayStatusWithPaymentWay:@"支付宝"];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"您的订单尚未支付成功，请刷新重试或者点这里重新下单"];
                        }
                    }];
                    [SVProgressHUD dismiss];
                } failure:^(FBRequest *request, NSError *error) {
                    [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
                }];
            }
                break;
            case 2: //微信支付
            {
                if ([WXApi isWXAppInstalled] == false) {
                    [SVProgressHUD showInfoWithStatus:@"您没有安装微信，请选择其他支付方式"];
                    break;
                }
                FBRequest * request = [FBAPI postWithUrlString:@"/shopping/payed" requestDictionary:@{@"rid": self.orderInfo.rid, @"payaway": @"weichat"} delegate:self];
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                [request startRequestSuccess:^(FBRequest *request, id result) {
                    NSDictionary * dataDic = [result objectForKey:@"data"];
                    PayReq * payReq = [[PayReq alloc] init];
                    payReq.partnerId = [dataDic objectForKey:@"partner_id"];
                    payReq.prepayId= [dataDic objectForKey:@"prepay_id"];
                    payReq.package = @"Sign=WXPay";
                    payReq.nonceStr= [dataDic objectForKey:@"nonce_str"];
                    payReq.timeStamp= [[dataDic objectForKey:@"time_stamp"] intValue];
                    //之前签名是本地生成
                    //                    WXSignParams * signParam = [[WXSignParams alloc] initWithDictionary:dataDic];
                    //                    payReq.sign= [signParam sign];
                    payReq.sign = [dataDic objectForKey:@"new_sign"];
                    [WXApi sendReq:payReq];
                    [SVProgressHUD dismiss];
                } failure:^(FBRequest *request, NSError *error) {
                    [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
                }];
            }
                break;
                
            case 3: //京东支付
            {
                JDPayViewController *vc = [[JDPayViewController alloc] init];
                vc.rid = self.orderInfo.rid;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;

            default:
                break;
        }
    }
}


#pragma mark - WXApiDelegate
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
            {
                [self checkOrderInfoForPayStatusWithPaymentWay:@"微信支付"];
            }
                break;
            case WXErrCodeUserCancel:
            {
                [SVProgressHUD showInfoWithStatus:@"支付取消!"];
            }
                break;
            default:
            {
                [SVProgressHUD showErrorWithStatus:@"您的订单尚未支付成功，请刷新重试或者点这里重新下单"];
            }
                break;
        }
    }
}

-(void)onReq:(BaseReq *)req{
    
}



//请求订单状态以核实支付是否完成
- (void)checkOrderInfoForPayStatusWithPaymentWay:(NSString *)paymentWay
{
    FBRequest * request = [FBAPI postWithUrlString:@"/shopping/detail" requestDictionary:@{@"rid": self.orderInfo.rid} delegate:self];
    [SVProgressHUD showWithStatus:@"正在核实支付结果..." maskType:SVProgressHUDMaskTypeClear];
    //延迟2秒执行以保证服务端已获取支付通知
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        WEAKSELF
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary * dataDic = [result objectForKey:@"data"];
            if ([[dataDic objectForKey:@"status"] isEqualToNumber:@10]) {
                PaySuccessViewController * paySuccessVC = [[PaySuccessViewController alloc] initWithNibName:@"PaySuccessViewController" bundle:nil];
                paySuccessVC.orderInfo = weakSelf.orderInfo;
                paySuccessVC.paymentWay = paymentWay;
                [weakSelf.navigationController pushViewController:paySuccessVC animated:YES];
                
                [SVProgressHUD showSuccessWithStatus:@"您的订单已经支付成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"您的订单尚未支付成功，请刷新重试或者点这里重新下单"];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    });
}


#pragma mark - AlipayDelegate
- (void)standbyCallbackWithResultDic:(NSDictionary *)resultDic
{
    if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
        [self checkOrderInfoForPayStatusWithPaymentWay:@"支付宝"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"您的订单尚未支付成功，请刷新重试或者点这里重新下单"];
    }
}


-(void)leftBarItemSelected{
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"放弃当前付款?" message:nil];
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:nil];
    TYAlertAction * ok = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        
        
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GoodsCarViewController class])]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        [self.navigationController popToViewController:self.navigationController.childViewControllers[2] animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView addAction:cancel];
    [alertView addAction:ok];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
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
