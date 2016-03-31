//
//  FBSignupViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBSignupViewController.h"
#import "SVProgressHUD.h"
#import "NSString+Helper.h"
#import "Fiu.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "FBBindingMobilePhoneNumber.h"
#import "MyViewController.h"
#import <TYAlertController.h>
#import <TYAlertView.h>


@interface FBSignupViewController ()<FBRequestDelegate>


@end
static NSString *const RegisterCodeURL = @"/auth/register";//手机号注册
static NSString *const VerifyCodeURL = @"/auth/verify_code";//发送验证码借口
static NSString *const thirdRegister = @"/auth/third_sign";//第三方登录接口
static NSString *const thirdRegisteredNotBinding = @"/auth/third_register_without_phone";//第三方快捷注册(不绑定手机号)接口
@implementation FBSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//跳转到手机号注册界面
- (IBAction)phoneToSignUpBtn:(UIButton *)sender {
}


//第三方注册
//微信注册
//点击微信按钮
- (IBAction)clickWeChatBtn:(UIButton *)sender {
    //um获取微信用户信息
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
            NSLog(@"*****************%@************%@",snsAccount.usid,snsAccount.unionId);
            //如果成功，进行关联，并且更新当前用户信息
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@1];
        }//如果失败，提示失败信息
        else{
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    });
}
//微博注册
//点击微博按钮
- (IBAction)clickWeiBoBtn:(UIButton *)sender {
    //um获取微博用户信息
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
             NSLog(@"*****************%@",snsAccount.unionId);
            //如果成功，进行关联，并且更新当前用户信息
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@2];
        }//如果失败，提示失败信息
        else{
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    });
}

//QQ注册
//点击QQ按钮
- (IBAction)clickQQBtn:(UIButton *)sender {
    //um获取QQ用户信息
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            NSLog(@"*****************%@",snsAccount.usid);
            //如果成功，进行关联，并且更新当前用户信息
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@3];
        }//如果失败，提示失败信息
        else{
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    });
}

//如果成功，进行关联，并且更新当前用户信息
-(void)afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:(UMSocialAccountEntity *)snsAccount type:(NSNumber *)type{
    
    //发送注册请求
    NSDictionary *params = @{
                             @"oid":snsAccount.usid,
                             @"access_token":snsAccount.accessToken,
                             @"type":type,
                             @"from_to":@1
                             };
    FBRequest *request = [FBAPI postWithUrlString:thirdRegister requestDictionary:params delegate:self];
    NSLog(@"**************%@",request.urlString);
    [request startRequestSuccess:^(FBRequest *request, id result) {
        //如果请求成功
        NSDictionary *dataDic = [result objectForKey:@"data"];
        NSLog(@"***************************%@",dataDic);
        if ([[dataDic objectForKey:@"has_user"] isEqualToNumber:@1]) {
            //用户存在，更新当前用户的信息
            UserInfo *userinfo = [UserInfo mj_objectWithKeyValues:[dataDic objectForKey:@"user"]];
            [userinfo saveOrUpdate];
            [userinfo updateUserInfoEntity];
            
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            
            
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"registeredSuccessfully", nil)];
            //跳回个人主页
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.tabBarController setSelectedIndex:3];

        }else{
            //如果用户不存在,提示用户是否进行绑定
            TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"TYAlertView" message:@"This is a message, the alert view containt text and textfiled. "];
            
            [alertView addAction:[TYAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
                //发送请求来存储用户信息
                NSDictionary *params;
                if ([type isEqualToNumber:@1]) {
                    //如果是微信需要snsAccount.unionId
                    params = @{
                               @"third_source":type,
                               @"oid":snsAccount.usid,
                               @"union_id":snsAccount.unionId,
                               @"access_token":snsAccount.accessToken,
                               @"nickname":snsAccount.userName,
                               @"avatar_url":snsAccount.iconURL,
                               @"from_to":@1
                               };
                    
                }
                //如果不是微信不需要snsAccount.unionId
                else{
                    params = @{
                               @"third_source":type,
                               @"oid":snsAccount.usid,
                               //@"union_id":snsAccount.unionId,
                               @"access_token":snsAccount.accessToken,
                               @"nickname":snsAccount.userName,
                               @"avatar_url":snsAccount.iconURL,
                               @"from_to":@1
                               };
                    
                }
                FBRequest *request = [FBAPI postWithUrlString:thirdRegisteredNotBinding requestDictionary:params delegate:self];
                [request startRequestSuccess:^(FBRequest *request, id result) {
                    //如果请求成功，并获取用户信息来更新当前用户信息
                    NSDictionary *dataDic = [result objectForKey:@"data"];
                    UserInfo *info = [UserInfo mj_objectWithKeyValues:dataDic];
                    [info saveOrUpdate];
                    [info updateUserInfoEntity];
                    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
                    entity.isLogin = YES;
                    
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"registeredSuccessfully", nil)];
                    //跳回个人主页
                    //跳回个人主页
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.tabBarController setSelectedIndex:3];
                    
                    
                } failure:^(FBRequest *request, NSError *error) {
                    //如果请求失败提示失败信息
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                }];

            }]];
            
            [alertView addAction:[TYAlertAction actionWithTitle:NSLocalizedString(@"determine", nil) style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                //跳转到绑定手机号界面
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:[NSBundle mainBundle]];
                FBBindingMobilePhoneNumber *bing = [story instantiateViewControllerWithIdentifier:@"LoginRegisterController"];
                bing.snsAccount = snsAccount;
                bing.type = type;
                [self.navigationController pushViewController:bing animated:YES];
            }]];
            
            
            
            // first way to show
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
            //alertController.alertViewOriginY = 60;
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            
            
           
        }
    } failure:^(FBRequest *request, NSError *error) {
        //如果请求失败，提示错误信息
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
    
    
}
//取消按钮,返回首页
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
