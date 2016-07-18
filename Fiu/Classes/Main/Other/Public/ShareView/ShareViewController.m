//
//  ShareViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ShareViewController.h"
#import "Fiu.h"
#import "WXApi.h"
#import "UMSocial.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "SVProgressHUD.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    
    /**
     *  判断用户有没有安装第三方应用
     *  设置分享面板
     */
    
    if ([WXApi isWXAppInstalled]) {
        self.wechatView.hidden = NO;
        self.friendView.hidden = NO;
    } else {
        self.wechatView.hidden = YES;
        self.friendView.hidden = YES;
    }
    
    if ([QQApiInterface isQQInstalled]) {
        self.qqView.hidden = NO;
    } else {
        self.qqView.hidden = YES;
    }
    
    if ([WeiboSDK isWeiboAppInstalled]) {
        self.weiBoView.hidden = NO;
    } else {
        self.weiBoView.hidden = YES;
    }
    
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.otherBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
}



- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
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
