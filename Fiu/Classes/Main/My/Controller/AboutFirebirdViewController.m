//
//  AboutFirebirdViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AboutFirebirdViewController.h"
#import  <SVProgressHUD.h>

@interface AboutFirebirdViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView1;//展示的网页

@end

@implementation AboutFirebirdViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    //地址
    NSURL *url = [NSURL URLWithString:@"http://m.taihuoniao.com/guide/app_about"];
    //在网页上加载
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView1 loadRequest:request];
    
    
    
}

//将要进入界面时隐藏tabbar
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

//将要退出界面时显示tabbar
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
