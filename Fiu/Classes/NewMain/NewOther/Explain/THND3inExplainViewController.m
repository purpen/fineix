//
//  THND3inExplainViewController.m
//  Fiu
//
//  Created by FLYang on 2017/2/23.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THND3inExplainViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "THNShareActionView.h"

static NSString *const URLPlan = @"https://m.taihuoniao.com/storage/plan?from=app";

@interface THND3inExplainViewController ()

@end

@implementation THND3inExplainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
}

- (UIWebView *)webView {
    if (!_webView) {
        CGFloat navTopHeight = Is_iPhoneX ? 88 : 64;
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - navTopHeight)];
        _webView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLPlan]]];
    }
    return _webView;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}
#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.delegate = self;
    [self thn_addBarItemLeftBarButton:@"" image:@"icon_cancel"];
    [self thn_addBarItemRightBarButton:@"" image:@"shouye_share_white"];
    self.navViewTitle.text = @"D3IN合伙人招募计划";
}

- (void)thn_rightBarItemSelected {
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

- (void)thn_leftBarItemSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
