//
//  THNZhaoMuViewController.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNZhaoMuViewController.h"
#import "SVProgressHUD.h"
#import "THNShareActionView.h"

static NSString *const URLPlan = @"https://m.taihuoniao.com/storage/plan?from=app";

@interface THNZhaoMuViewController () <FBNavigationBarItemsDelegate,UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation THNZhaoMuViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addBarItemRightBarButton:@"" image:@"shouye_share_white" isTransparent:NO];
}

-(void)rightBarItemSelected{
    [THNShareActionView showShare:self shareMessageObject:[self shareMessageObject] linkUrl:URLPlan oLinkUrl:URLPlan];
}

#pragma mark - 创建分享消息对象
- (UMSocialMessageObject *)shareMessageObject {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"D3IN合伙人招募计划"
                                                                             descr:@"分享有理，赚钱无罪。一键分享，轻松提现"
                                                                         thumImage:[UIImage imageNamed:@"D3IN_plan"]];
    shareObject.webpageUrl = URLPlan;
    messageObject.shareObject = shareObject;
    return messageObject;
}

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
