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
#import "Fineix.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "FBBindingMobilePhoneNumber.h"


@interface FBSignupViewController ()<FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationCodeBtn;//发送验证码按钮
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

- (IBAction)clickSignUpBtn:(UIButton *)sender {
    if (![self.phoneNumTF.text checkTel]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    if (!self.verificationCode.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    if (self.pwdTF.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不得少于6位"];
        return;
    }
    NSDictionary *params = @{
                             @"mobile": self.phoneNumTF.text,
                             @"password": self.pwdTF.text,
                             @"verify_code": self.verificationCode.text,
                             @"from_to" : @1
                             };
    FBRequest *request = [FBAPI postWithUrlString:RegisterCodeURL requestDictionary:params delegate:self];
    request.flag = RegisterCodeURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
}

#pragma mark -点击发送验证码按钮
- (IBAction)clickSendVerificationCodeBtn:(UIButton *)sender {
    
    
    
    
    if ([self.phoneNumTF.text checkTel]) {
        //手机号正确发送验证码
        NSDictionary *params = @{
                                 @"mobile":self.phoneNumTF.text
                                 };
        FBRequest *request = [FBAPI postWithUrlString:VerifyCodeURL requestDictionary:params delegate:self];
        request.flag = VerifyCodeURL;
        [request startRequest];
        //开始倒计时准备重新发送
        [self startTime];
    }else{
       //手机号不正确提示信息
        [SVProgressHUD showErrorWithStatus:@"手机号不正确"];
    }
}

//开始倒计时准备重新发送
-(void)startTime{
    __block int timeout = 30;//倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //文字变为原来
                [self.sendVerificationCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.sendVerificationCodeBtn.userInteractionEnabled = YES;
            });
        }//按钮显示剩余时间
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.sendVerificationCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.sendVerificationCodeBtn.userInteractionEnabled = NO;
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
    
    
}


#pragma mark - FBRequest Delegate
-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:RegisterCodeURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            UserInfo * userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [userInfo updateUserInfoEntity];
            UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
            userEntity.isLogin = YES;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [userInfo saveOrUpdate];
            });
            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        } else {
            NSString * message = result[@"message"];
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    //发送验证码请求
    if ([request.flag isEqualToString:VerifyCodeURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        } else {
            NSString * message = result[@"message"];
            [SVProgressHUD showInfoWithStatus:message];
        }
    }

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
            [userinfo updateUserInfoEntity];
            NSLog(@"******************************%@",userinfo);
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            [userinfo saveOrUpdate];
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        }else{
            //如果用户不存在,提示用户是否进行绑定
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否进行手机绑定" preferredStyle:UIAlertControllerStyleAlert];
            //确定按钮
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //跳转到绑定手机号界面
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:[NSBundle mainBundle]];
                FBBindingMobilePhoneNumber *bing = [story instantiateViewControllerWithIdentifier:@"LoginRegisterController"];
                bing.snsAccount = snsAccount;
                bing.type = type;
                [self.navigationController pushViewController:bing animated:YES];
            }];
            //取消按钮
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
                    [info updateUserInfoEntity];
                    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
                    entity.isLogin = YES;
                    [info saveOrUpdate];
                    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                } failure:^(FBRequest *request, NSError *error) {
                    //如果请求失败提示失败信息
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                }];
            }];
            //添加按钮
            [alertC addAction:okAction];
            [alertC addAction:cancelAction];
            //显示提示框
            [self presentViewController:alertC animated:YES completion:nil];
        }
    } failure:^(FBRequest *request, NSError *error) {
        //如果请求失败，提示错误信息
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
    
    
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
