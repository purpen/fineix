//
//  ShareViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ShareViewController.h"
#import "Fiu.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "SVProgressHUD.h"

@interface ShareViewController ()
{
    BOOL _flag;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnBottomSpace;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (SCREEN_HEIGHT == 812) {
        self.cancelBtnBottomSpace.constant += 20;
    }
    
    _flag = NO;
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


- (IBAction)weChatBtn:(UIButton *)sender {

}

- (IBAction)timeLineBtn:(UIButton *)sender {

}
- (IBAction)sinaBtn:(UIButton *)sender {

}
- (IBAction)qqBtn:(UIButton *)sender {

}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
