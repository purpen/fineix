//
//  THNQiYeQingDingZhiViewController.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNQiYeQingDingZhiViewController.h"
#import "SVProgressHUD.h"

@interface THNQiYeQingDingZhiViewController () <FBNavigationBarItemsDelegate,UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation THNQiYeQingDingZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (SCREEN_HEIGHT == 812) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-88)];
    } else {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    [self.view addSubview:_webView];
    
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = @"企业轻订制";
    //地址
    NSURL *url = [NSURL URLWithString:@"https://m.taihuoniao.com/storage/custom?from=app"];
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
