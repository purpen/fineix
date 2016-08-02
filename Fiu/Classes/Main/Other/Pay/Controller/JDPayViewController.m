//
//  JDPayViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/1.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "JDPayViewController.h"
#import "SVProgressHUD.h"
#import "JDPayModel.h"
#import <MJExtension.h>
#import "PaySuccessViewController.h"
#import "OrderInfoModel.h"

@interface JDPayViewController ()<UIWebViewDelegate,FBNavigationBarItemsDelegate>

{
    BOOL _flag;
}

@property (weak, nonatomic) IBOutlet UIWebView *jdPayWenView;
/**  */
@property (nonatomic, strong) JDPayModel *model;
@end

static NSString * const JDPayUrl = @"/shopping/payed";

@implementation JDPayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _flag = NO;
    self.navViewTitle.text = @"京东支付";
    self.delegate = self;
    self.jdPayWenView.delegate = self;
    FBRequest *request = [FBAPI postWithUrlString:JDPayUrl requestDictionary:@{
                                                                            @"rid":self.orderInfo.rid,
                                                                            @"payaway":@"jdpay"
                                                                               } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"result %@",result);
        NSDictionary *params = result[@"data"][@"params"];
        JDPayModel *model = [JDPayModel mj_objectWithKeyValues:params];
        model.url = result[@"data"][@"url"];
        self.model = model;
        [self loadTheJDRequest];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
}

-(void)leftBarItemSelected{
    if (_flag) {
        [self checkOrderInfoForPayStatusWithPaymentWay:@"京东支付"];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)loadTheJDRequest{
    [SVProgressHUD showWithStatus:@"正在跳转请稍候"];
    NSMutableDictionary *formDic = [[NSMutableDictionary alloc] init];
    [formDic setObject:_model.callbackUrl ? _model.callbackUrl :@"" forKey:@"callbackUrl"];
    [formDic setObject:_model.tradeDesc ? _model.tradeDesc :@"" forKey:@"tradeDesc"];
    [formDic setObject:_model.tradeTime ? _model.tradeTime :@"" forKey:@"tradeTime"];
    [formDic setObject:_model.tradeNum ? _model.tradeNum :@"" forKey:@"tradeNum"];
    [formDic setObject:_model.version ? _model.version :@"" forKey:@"version"];
    [formDic setObject:_model.currency ? _model.currency :@"" forKey:@"currency"];
    [formDic setObject:_model.sign ? _model.sign :@"" forKey:@"sign"];
    [formDic setObject:_model.amount ? _model.amount :@"" forKey:@"amount"];
    [formDic setObject:_model.notifyUrl ? _model.notifyUrl :@"" forKey:@"notifyUrl"];
    [formDic setObject:_model.merchant ? _model.merchant :@"" forKey:@"merchant"];
    [formDic setObject:_model.device ? _model.device :@"" forKey:@"device"];
    [formDic setObject:_model.tradeName ? _model.tradeName :@"" forKey:@"tradeName"];
    [formDic setObject:_model.tradeDesc ? _model.tradeDesc :@"" forKey:@"tradeDesc"];
    [formDic setObject:_model.note ? _model.note :@"" forKey:@"note"];
    [formDic setObject:_model.ip ? _model.ip :@"" forKey:@"ip"];
    [formDic setObject:_model.userType ? _model.userType :@"" forKey:@"userType"];
    [formDic setObject:_model.userId ? _model.userId :@"" forKey:@"userId"];
    [formDic setObject:_model.expireTime ? _model.expireTime :@"" forKey:@"expireTime"];
    [formDic setObject:_model.orderType ? _model.orderType :@"" forKey:@"orderType"];
    [formDic setObject:_model.industryCategoryCode ? _model.industryCategoryCode :@"" forKey:@"industryCategoryCode"];
    [formDic setObject:_model.specCardNo ? _model.specCardNo :@"" forKey:@"specCardNo"];
    [formDic setObject:_model.specId ? _model.specId :@"" forKey:@"specId"];
    [formDic setObject:_model.specName ? _model.specName :@"" forKey:@"specName"];
    NSString *JDToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"JDTOKEN"];
    [formDic setObject:JDToken ? JDToken :@"" forKey:@"token"];
    
    
    //通过AFN提交参数
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:self.model.url parameters:formDic success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSString *htmlstring = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //将第二次请求出来的html字符串加载到webview
        [self.jdPayWenView loadHTMLString:htmlstring baseURL:[NSURL URLWithString:self.model.url]];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
    }];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"数据加载出错啦！"];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if (_flag == NO) {
        if ([request.URL.absoluteString rangeOfString:@"taihuoniao"].location !=NSNotFound) {
            
            [self checkOrderInfoForPayStatusWithPaymentWay:@"京东支付"];
            _flag = YES;
            
        }
    }
    
    return YES;
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
                [SVProgressHUD showErrorWithStatus:@"您的订单尚未支付成功，请刷新重试或者重新下单"];
                UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"支付失败" message:nil delegate:self cancelButtonTitle:@"稍后尝试" otherButtonTitles:@"再次提交",nil];
                alt.tag=1000;
                [alt show];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
    });
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag ==1000) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self loadTheJDRequest];
        }
    }
}



-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

@end
