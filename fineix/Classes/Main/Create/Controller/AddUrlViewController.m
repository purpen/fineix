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
    self.view.backgroundColor = [UIColor colorWithHexString:lineGrayColor alpha:1];
    
    [self setNavViewUI];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(open) forControlEvents:(UIControlEventTouchUpInside)];
    
//    [self.view addSubview:btn];
    
    [self setUI];
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

#pragma mark - 设置导航视图
- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"addUrl", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelButton];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addLine];
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 设置视图UI
- (void)setUI {
    [self.view addSubview:self.searchGoods];
    
    [self.view addSubview:self.addUrlView];
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchGoods {
    if (!_searchGoods) {
        _searchGoods = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 44)];
        _searchGoods.searchInputBox.placeholder = NSLocalizedString(@"searchGoods", nil);
        _searchGoods.delegate = self;
    }
    return _searchGoods;
}

#pragma mark - 搜索产品
- (void)beginSearch:(NSString *)searchKeyword {
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"搜索的产品关键字：%@", searchKeyword]];
}

#pragma mark - 购物网站按钮所在的视图
- (AddUrlView *)addUrlView {
    if (!_addUrlView) {
        _addUrlView = [[AddUrlView alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 100)];
        _addUrlView.delegate = self;
    }
    return _addUrlView;
}

- (void)webBtnSelectedSearchGoods:(NSInteger)index {
    NSLog(@"点击了第＝＝＝＝ %zi ＝＝＝＝＝", index);
}

@end
