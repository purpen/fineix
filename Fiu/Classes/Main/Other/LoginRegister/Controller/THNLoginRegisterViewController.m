//
//  THNLoginRegisterViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNLoginRegisterViewController.h"
#import "THNSignUpViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "THNInformationViewController.h"
#import "THNLoginViewController.h"
#import "THNBingViewController.h"
#import "THNRedEnvelopeView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UIView+TYAlertView.h"

@interface THNLoginRegisterViewController ()<FBRequestDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdTipBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

@end

static NSString *const thirdRegister = @"/auth/third_sign";//第三方登录接口

@implementation THNLoginRegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 3;
    
    self.signUpBtn.layer.masksToBounds = YES;
    self.signUpBtn.layer.cornerRadius = 3;
    
    //判断手机是否安装了相应的客户端
    [self judge];
}

#pragma mark -判断手机是否安装了相应的客户端
-(void)judge{
    //隐藏未安装的第三方登录平台
    if (![WXApi isWXAppInstalled] && ![WeiboSDK isWeiboAppInstalled] && ![QQApiInterface isQQInstalled]) {
        self.thirdView.hidden = true;
    }
    if ([WXApi isWXAppInstalled] == FALSE) {
        self.wechatBtn.hidden = true;
    }
    if ([WeiboSDK isWeiboAppInstalled] == FALSE) {
        self.sinaBtn.hidden = true;
    }
    if ([QQApiInterface isQQInstalled] == FALSE) {
        self.qqBtn.hidden = true;
    }
}

- (IBAction)cancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginClick:(id)sender {
    THNLoginViewController *vc = [[THNLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)signUpClick:(id)sender {
    THNSignUpViewController *vc = [[THNSignUpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)wechat:(id)sender {
    //微信登录
    [self thn_chooseUmengLogin:(UMSocialPlatformType_WechatSession) type:@1];
}

- (IBAction)sina:(id)sender {
    //微博登录
    [self thn_chooseUmengLogin:(UMSocialPlatformType_Sina) type:@2];
}

- (IBAction)qq:(id)sender {
    //QQ登录
    [self thn_chooseUmengLogin:(UMSocialPlatformType_QQ) type:@3];
}

#pragma mark - 选择第三方的类型
- (void)thn_chooseUmengLogin:(UMSocialPlatformType)platformType type:(NSNumber *)type {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];//错误原因
        } else {
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:resp type:type];
        }
    }];
}

#pragma mark -第三方登录成功后取到用户信息
-(void)afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:(UMSocialUserInfoResponse *)snsAccount type:(NSNumber *)type{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSDictionary *params = @{
                             @"oid":snsAccount.uid,
                             @"access_token":snsAccount.accessToken,
                             @"type":type,
                             @"from_to":@1
                             };
    FBRequest *request = [FBAPI postWithUrlString:thirdRegister requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        //如果请求成功
        [SVProgressHUD dismiss];
        NSDictionary *dataDic = [result objectForKey:@"data"];
        if ([[dataDic objectForKey:@"has_user"] isEqualToNumber:@1]){
            //用户存在，更新当前用户的信息
            UserInfo *userinfo = [UserInfo mj_objectWithKeyValues:[dataDic objectForKey:@"user"]];
            [userinfo saveOrUpdate];
            [userinfo updateUserInfoEntity];
            
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            NSString *str = dataDic[@"user"][@"identify"][@"is_scene_subscribe"];
            if ([str integerValue] == 0){
                //完善个人信息
                THNInformationViewController *vc = [[THNInformationViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:^{
                    if (entity.is_bonus == 1) {
                        THNRedEnvelopeView *alartView = [[THNRedEnvelopeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                        [alartView thn_showRedEnvelopeViewOnWindowWithText:NSLocalizedString(@"SendOldRed", nil)];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSceneData" object:nil];
                }];
            }
        }else{
            
            //跳转到绑定手机号界面
            THNBingViewController *bing = [[THNBingViewController alloc] init];
            bing.snsAccount = snsAccount;
            bing.type = type;
            [self.navigationController pushViewController:bing animated:YES];
            //如果用户不存在,提示用户是否进行绑定
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

@end
