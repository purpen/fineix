//
//  IntegralViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "IntegralViewController.h"
#import "SVProgressHUD.h"
#import "FBRequest.h"

@interface IntegralViewController ()<UIWebViewDelegate,FBRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *integralWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewTopSpace;

@end

@implementation IntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SCREEN_HEIGHT == 812) {
        self.webViewTopSpace.constant = 88;
    } else {
        self.webViewTopSpace.constant = 64;
    }
    // Do any additional setup after loading the view from its nib.
    self.navViewTitle.text = @"积分";
    FBRequest * request = [FBAPI postWithUrlString:@"/auth/check_login" requestDictionary:nil delegate:self];
    NSDictionary *dict = [request transformRequestDictionary];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.taihuoniao.com/app/api/view/fiu_point?uuid=%@&from_to=1&app_type=2",[dict objectForKey:@"uuid"]]];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url];
    [self.integralWebView loadRequest:request1];
    self.integralWebView.delegate = self;
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
