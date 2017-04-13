//
//  THNWelfareViewController.m
//  Fiu
//
//  Created by dong on 2017/4/13.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNWelfareViewController.h"
#import "BonusViewController.h"

@interface THNWelfareViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *contentWebView;

@end

@implementation THNWelfareViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(UIWebView *)contentWebView{
    if (!_contentWebView) {
        _contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    return _contentWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.contentWebView];
    self.navViewTitle.text = @"新人福利";
    NSURL *url = [NSURL URLWithString:@"https://m.taihuoniao.com/app/wap/index/d3in_newer"];
    //在网页上加载
    NSURLRequest *webRequest = [NSURLRequest requestWithURL:url];
    [self.contentWebView loadRequest:webRequest];
    self.contentWebView.delegate = self;
    self.contentWebView.scalesPageToFit = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

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

#pragma mark - 截取网页点击事件，获取url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        NSString *str = [url absoluteString];
        if([str rangeOfString:@"taihuoniao.com"].location == NSNotFound && [str rangeOfString:@"infoType"].location == NSNotFound){
            //打开浏览器
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else if ([str rangeOfString:@"taihuoniao.com"].location != NSNotFound && [str rangeOfString:@"infoType"].location != NSNotFound && [str rangeOfString:@"infoId"].location != NSNotFound){
            NSArray *oneAry = [str componentsSeparatedByString:@"?"];
            NSString *infoStr = oneAry[1];
            NSArray *twoAry = [infoStr componentsSeparatedByString:@"&"];
            NSString *infoType;
            if (((NSString*)twoAry[0]).length == 11) {
                infoType = [twoAry[0] substringWithRange:NSMakeRange(9, 2)];
            }else if(((NSString*)twoAry[0]).length == 10){
                infoType = [twoAry[0] substringWithRange:NSMakeRange(9, 1)];
            }
            NSInteger type = [infoType integerValue];
            NSString *infoId;
            NSArray *threeAry = [twoAry[1] componentsSeparatedByString:@"="];
            NSString *inforTag;
            if (type == 20) {
                NSArray *fourAry = [threeAry[1] componentsSeparatedByString:@"&"];
                infoId = fourAry[0];
                NSArray *fiveAry = [fourAry[1] componentsSeparatedByString:@"="];
                inforTag = fiveAry[1];
            }else{
                infoId = threeAry[1];
            }
            
            
            switch (type) {
                case 16:
                    //领取红包
                {
                    BonusViewController *vc = [[BonusViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
