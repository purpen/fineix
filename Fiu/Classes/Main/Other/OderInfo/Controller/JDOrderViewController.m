//
//  JDOrderViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "JDOrderViewController.h"
#import "SVProgressHUD.h"

@interface JDOrderViewController ()<FBNavigationBarItemsDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *jDWebView;
@end

@implementation JDOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"京东订单";
    self.jDWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"https://plogin.m.jd.com/user/login.action?appid=100&returnurl=http%3A%2F%2Fhome.m.jd.com%2FmyJd%2Fhome.action%3Fsid%3D2f52c20a5629dbfe46688e73cf2192d6"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.jDWebView loadRequest:request];
}

//UIWebViewDelegate
//网页开始加载时出现进度条
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
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
