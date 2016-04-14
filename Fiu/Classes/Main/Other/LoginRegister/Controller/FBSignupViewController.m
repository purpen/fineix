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
#import "SignupView.h"
#import "FBLoginViewController.h"
#import "SubscribeInterestedCollectionViewController.h"


@interface FBSignupViewController ()<FBRequestDelegate,UITextFieldDelegate>
{
    SignupView *_signupView;
}
@property (weak, nonatomic) IBOutlet UIView *topView;//微信等按钮的view
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiBoBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@end
static NSString *const RegisterCodeURL = @"/auth/register";//手机号注册
static NSString *const VerifyCodeURL = @"/auth/verify_code";//发送验证码借口
static NSString *const thirdRegister = @"/auth/third_sign";//第三方登录接口
static NSString *const thirdRegisteredNotBinding = @"/auth/third_register_without_phone";//第三方快捷注册(不绑定手机号)接口
NSString *const LoginURL = @"/auth/login";//登录接口
@implementation FBSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _topView.hidden = NO;
    //隐藏的view
    _signupView = [SignupView getSignupView];
    _signupView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 244/667.0*SCREEN_HEIGHT);
    CGRect frame = _signupView.frame;
    frame.origin.y = 1000;
    _signupView.frame = frame;
    [self.view addSubview:_signupView];
    _signupView.phoneNumTF.delegate = self;
    //给注册连接方法
    [_signupView.signupBtn addTarget:self action:@selector(clicksignupBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_signupView.sendVerificationBtn addTarget:self action:@selector(clikSendVerBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    _signupView.toResendV.hidden = YES;
    //
    self.weChatBtn.layer.masksToBounds = YES;
    self.weChatBtn.layer.cornerRadius = 3;
    self.weiBoBtn.layer.masksToBounds = YES;
    self.weiBoBtn.layer.cornerRadius = 3;
    self.qqBtn.layer.masksToBounds = YES;
    self.qqBtn.layer.cornerRadius = 3;
}

//点击发送验证码，判断手机号如果手机号正确发送验证码，并且重新发送view出现，并且开始跳字
-(void)clikSendVerBtn:(UIButton*)sender{
    if ([_signupView.phoneNumTF.text checkTel]) {
        //如果手机号正确，发送短信
        NSDictionary *params = @{
                                 @"mobile":_signupView.phoneNumTF.text
                                 };
        FBRequest *request = [FBAPI postWithUrlString:VerifyCodeURL requestDictionary:params delegate:self];
        request.flag = VerifyCodeURL;
        [request startRequest];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        _signupView.toResendV.hidden = NO;
        [self startTime];
    }else{
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
                //时间到了后重新发送view消失
                _signupView.toResendV.hidden = YES;
            });
        }//按钮显示剩余时间
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                _signupView.backToTheTimeL.text = strTime;
                [UIView commitAnimations];
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
    
    
}

//点击手机号注册
- (IBAction)clickPhoneNumTF:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.topView.hidden = YES;
        CGRect frame = _signupView.frame;
        frame.origin.y = 117.0/667.0*SCREEN_HEIGHT;
        _signupView.frame = frame;
        
    } completion:^(BOOL finished) {
        //成为第一响应者
        [_signupView.phoneNumTF becomeFirstResponder];
    }];
    
}

//键盘收回
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击注册按钮
-(void)clicksignupBtn:(UIButton*)sender{
    if (![_signupView.phoneNumTF.text checkTel]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"enterCorrectPhoneNumber", nil)];
        return;
    }
    if (!_signupView.verificationTF.text.length) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"enterVerificationCode", nil)];
        return;
    }
    if (_signupView.setPwdTF.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不得少于6位"];
        return;
    }
    NSDictionary *params = @{
                             @"mobile": _signupView.phoneNumTF.text,
                             @"password": _signupView.setPwdTF.text,
                             @"verify_code": _signupView.verificationTF.text,
                             @"from_to" : @1
                             };
    FBRequest *request = [FBAPI postWithUrlString:RegisterCodeURL requestDictionary:params delegate:self];
    request.flag = RegisterCodeURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

}

#pragma mark -fbrequestDElegate
-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:RegisterCodeURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            UserInfo * userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [userInfo saveOrUpdate];
            [userInfo updateUserInfoEntity];
            UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
            userEntity.isLogin = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            //跳转到手机号登录界面
            UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:nil];
            FBLoginViewController *loginVC = [loginStory instantiateViewControllerWithIdentifier:@"FBLoginViewController"];
            //手机号登录按钮选中
            [loginVC clickPhoneNumTF:loginVC.phoneNumTFBtn];
            [self.navigationController pushViewController:loginVC animated:YES];
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
            [userinfo saveOrUpdate];
            [userinfo updateUserInfoEntity];
            
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            
            
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"registeredSuccessfully", nil)];
            //推荐感兴趣的情景
            NSDictionary *identifyDict = [[dataDic objectForKey:@"user"] objectForKey:@"identify"];
            if ([[identifyDict objectForKey:@"is_scene_subscribe"] isEqualToNumber:@0]) {
                //跳转到推荐界面
                SubscribeInterestedCollectionViewController *subscribeVC = [[SubscribeInterestedCollectionViewController alloc] init];
                [self.navigationController pushViewController:subscribeVC animated:YES];
            }else{
                //已经订阅过，直接个人中心
                //跳回个人主页
                //跳回个人主页
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.tabBarController setSelectedIndex:3];
                
            }

            

        }else{
            //如果用户不存在,提示用户是否进行绑定
            TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"是否进行用户绑定" message:nil];
            
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
                    
                    //推荐感兴趣的情景
                    NSDictionary *identifyDict = [dataDic objectForKey:@"identify"];
                    if ([[identifyDict objectForKey:@"is_scene_subscribe"] isEqualToNumber:@0]) {
                        //跳转到推荐界面
                        SubscribeInterestedCollectionViewController *subscribeVC = [[SubscribeInterestedCollectionViewController alloc] init];
                        [self.navigationController pushViewController:subscribeVC animated:YES];
                    }else{
                        //已经订阅过，直接个人中心
                        //跳回个人主页
                        //跳回个人主页
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [self.tabBarController setSelectedIndex:3];
                        
                    }
                    
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
    
    //如果topView消失，让他出现,另一个view消失
    if (self.topView.hidden == YES) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _signupView.frame;
            frame.origin.y = 1000;
            _signupView.frame = frame;
        } completion:^(BOOL finished) {
            self.topView.hidden = NO;
        }];
        
        
    }//如果topview没有消失，返回
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
