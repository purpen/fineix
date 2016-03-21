//
//  AddUrlViewController.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddUrlViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface AddUrlViewController () <UIWebViewDelegate>

@end

@implementation AddUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(open) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];
}

- (void)open {
    UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT- 50)];
    web.delegate = self;
    [self.view addSubview:web];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.baidu.com"]]];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString * urlStr = webView.request.URL.absoluteString;
    [SVProgressHUD showInfoWithStatus:urlStr];
    NSString * theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"当前页面的链接：%@， 标题是：%@", urlStr, theTitle);
}

- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"添加链接"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelButton];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addLine];
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
