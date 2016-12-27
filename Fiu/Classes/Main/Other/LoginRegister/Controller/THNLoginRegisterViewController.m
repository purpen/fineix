//
//  THNLoginRegisterViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNLoginRegisterViewController.h"
#import "THNSignUpViewController.h"
#import "UMSocial.h"
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

@interface THNLoginRegisterViewController ()<FBRequestDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdTipBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

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
    self.navView.hidden = YES;
    
    
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

- (IBAction)weixinClick:(id)sender {
    //微信登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        if (response.responseCode == UMSResponseCodeSuccess) {
            //如果微信登录成功，取到用户信息
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@1];
        }else {
            [SVProgressHUD showErrorWithStatus:response.message];//错误原因
        }
    });
}

#pragma mark -第三方登录成功后取到用户信息
-(void)afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:(UMSocialAccountEntity *)snsAccount type:(NSNumber *)type{
    NSString *oid;
    if ([type isEqualToNumber:@1]) {
        oid = snsAccount.unionId;
    }else{
        oid = snsAccount.usid;
    }
    NSDictionary *params = @{
                             @"oid":oid,
                             @"access_token":snsAccount.accessToken,
                             @"type":type,
                             @"from_to":@1
                             };
    FBRequest *request = [FBAPI postWithUrlString:thirdRegister requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD dismiss];
        //如果请求成功
        NSDictionary *dataDic = [result objectForKey:@"data"];
        if ([[dataDic objectForKey:@"has_user"] isEqualToNumber:@1]){
            //用户存在，更新当前用户的信息
            UserInfo *userinfo = [UserInfo mj_objectWithKeyValues:[dataDic objectForKey:@"user"]];
            [userinfo saveOrUpdate];
            [userinfo updateUserInfoEntity];
            
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            NSString *str = dataDic[@"user"][@"identify"][@"is_scene_subscribe"];
            
            if ([str intValue] == 0){
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

- (IBAction)sinaClick:(id)sender {
    //微博登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            //如果微博登录成功，取到用户信息
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@2];
            
            //得到的数据在回调Block对象形参respone的data属性
            //                        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *response){
            //                            NSLog(@"SnsInformation is %@", response.data);
            //                        }];
        } else {//如果微博登录失败，提示错误信息
            [SVProgressHUD showErrorWithStatus:response.message];//错误原因
        }
    });
}

- (IBAction)qqClick:(id)sender {
    //QQ登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        if (response.responseCode == UMSResponseCodeSuccess) {
            //如果QQ登录成功，取到用户信息
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@3];
            
            //得到的数据在回调Block对象形参respone的data属性
            //                        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *response){
            //                            NSLog(@"SnsInformation is %@", response.data);
            //                        }];
        } else {//如果QQ登录失败，提示错误信息
            [SVProgressHUD showErrorWithStatus:response.message];//错误原因
        }
    });
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

@end
