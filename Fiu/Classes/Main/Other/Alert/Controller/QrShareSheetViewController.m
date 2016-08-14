//
//  QrShareSheetViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "QrShareSheetViewController.h"
#import "Fiu.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface QrShareSheetViewController ()

@property (weak, nonatomic) IBOutlet UIView *wechatView;
@property (weak, nonatomic) IBOutlet UIView *friendView;
@property (weak, nonatomic) IBOutlet UIView *qqView;

@property (weak, nonatomic) IBOutlet UIView *weiBoView;
@end

@implementation QrShareSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
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
