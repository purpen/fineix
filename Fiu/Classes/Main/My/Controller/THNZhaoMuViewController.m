//
//  THNZhaoMuViewController.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNZhaoMuViewController.h"
#import "SVProgressHUD.h"

@interface THNZhaoMuViewController () <FBNavigationBarItemsDelegate,UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation THNZhaoMuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_webView];
    
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = @"D³IN合伙招募计划";
    //地址
    NSURL *url = [NSURL URLWithString:@"https://m.taihuoniao.com/storage/plan?from=app"];
    //在网页上加载
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    _webView.delegate = self;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
