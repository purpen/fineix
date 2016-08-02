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

@interface JDPayViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *jdPayWenView;
/**  */
@property (nonatomic, strong) JDPayModel *model;
@end

static NSString * const JDPayUrl = @"/shopping/payed";

@implementation JDPayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navViewTitle.text = @"京东支付";
    self.jdPayWenView.delegate = self;
    FBRequest *request = [FBAPI postWithUrlString:JDPayUrl requestDictionary:@{
                                                                            @"rid":self.rid,
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


-(void)loadTheJDRequest{
    [SVProgressHUD showInfoWithStatus:@"正在跳转请稍候"];
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

    NSLog(@"request     %@",request.URL);
    
    if ([request.URL.absoluteString rangeOfString:@"callbackUrl"].location !=NSNotFound) {
        if ([request.URL.absoluteString rangeOfString:@"token"].location !=NSNotFound) {
            
            NSString *token = [[request.URL.absoluteString componentsSeparatedByString:@"token="]lastObject];
            NSString *gettoken = [[token componentsSeparatedByString:@"&"]firstObject];

            
            [[NSUserDefaults standardUserDefaults] setObject:gettoken forKey:@"JDTOKEN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
        } else {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"支付失败" message:nil delegate:self cancelButtonTitle:@"稍后尝试" otherButtonTitles:@"再次提交",nil];
            alt.tag=1000;
            [alt show];
        }
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag ==1000) {
        if (buttonIndex == alertView.cancelButtonIndex) {
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
