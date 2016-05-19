//
//  TaoBaoOrderViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "TaoBaoOrderViewController.h"
#import "SVProgressHUD.h"

@interface TaoBaoOrderViewController ()<FBNavigationBarItemsDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *taoBaoWebView;

@end

@implementation TaoBaoOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"淘宝订单";
    NSURL *url = [NSURL URLWithString:@"https://h5.m.taobao.com/mlapp/mytaobao.html#mlapp-mytaobao"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.taoBaoWebView loadRequest:request];
    self.taoBaoWebView.delegate = self;
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
