//
//  FBLoginViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBLoginViewController.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "Fineix.h"

@interface FBLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isPopup;//弹出状态
@property (weak, nonatomic) IBOutlet UILabel *thirdPartyTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@property (strong, nonatomic) IBOutlet UITextField *accountField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *subBottomView;
@end

@implementation FBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏未安装的第三方登录平台
//    if (![WXApi isWXAppInstalled] && ![WeiboSDK isWeiboAppInstalled] && ![QQApiInterface isQQInstalled]) {
//        self.thirdPartyTitleLbl.hidden = true;
//    }
//    if ([WXApi isWXAppInstalled] == FALSE) {
//        self.wechatBtn.hidden = true;
//    }
//    if ([WeiboSDK isWeiboAppInstalled] == FALSE) {
//        self.weiboBtn.hidden = true;
//    }
//    if ([QQApiInterface isQQInstalled] == FALSE) {
//        self.qqBtn.hidden = true;
//    }
    //设置按钮显示椭圆
    self.wechatBtn.layer.cornerRadius  = 2;
    self.wechatBtn.layer.masksToBounds = YES;
    self.weiboBtn.layer.cornerRadius  = 2;
    self.weiboBtn.layer.masksToBounds = YES;
    self.qqBtn.layer.cornerRadius  = 2;
    self.qqBtn.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius  = 2;
    self.loginButton.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:true];
}

- (IBAction)clickWeChatBtn:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            //UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
            
            //[self requestDataForThirdPartyLoginWithSnsAccount:snsAccount type:@1];
            
            //得到的数据在回调Block对象形参respone的data属性
                        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *response){
                            NSLog(@"SnsInformation is %@", response.data);
                        }];
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];//错误原因
        }
    });

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
