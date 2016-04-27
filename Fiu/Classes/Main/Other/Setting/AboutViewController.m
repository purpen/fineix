//
//  AboutViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AboutViewController.h"
#import  <SVProgressHUD.h>

@interface AboutViewController ()<FBNavigationBarItemsDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *aboutWebView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationController.navigationBarHidden = NO;
    self.navViewTitle.text = @"关于太火鸟";
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    
    //地址
    NSURL *url = [NSURL URLWithString:@"http://m.taihuoniao.com/guide/app_about"];
    //在网页上加载
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.aboutWebView loadRequest:request];
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
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
