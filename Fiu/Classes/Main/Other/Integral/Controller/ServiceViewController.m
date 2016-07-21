//
//  ServiceViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/6/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ServiceViewController.h"
#import "SVProgressHUD.h"
#import "FBRequest.h"

@interface ServiceViewController ()<UIWebViewDelegate,FBRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *serviceWebView;

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navViewTitle.text = @"服务条款";
    FBRequest * request = [FBAPI postWithUrlString:@"/auth/check_login" requestDictionary:nil delegate:self];
    NSDictionary *dict = [request transformRequestDictionary];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.taihuoniao.com/app/api/view/fiu_service_term?uuid=%@&from_to=1&app_type=2",[dict objectForKey:@"uuid"]]];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url];
    [self.serviceWebView loadRequest:request1];
    self.serviceWebView.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

//UIWebViewDelegate
//网页开始加载时出现进度条
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD show];
}
//网页加载完成进度条消失
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}
//网页加载失败，提示加载失败原因
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showInfoWithStatus:error.localizedDescription];
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
