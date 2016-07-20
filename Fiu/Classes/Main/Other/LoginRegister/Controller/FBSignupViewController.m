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
#import "BindIngViewController.h"
#import "MyPageViewController.h"
#import <TYAlertController.h>
#import <TYAlertView.h>
#import "SignupView.h"
#import "FBLoginViewController.h"
#import "SubscribeInterestedCollectionViewController.h"
#import "ImprovViewController.h"


@interface FBSignupViewController ()<FBRequestDelegate,UITextFieldDelegate>
{
    SignupView *_signupView;
}
@property (nonatomic, assign) BOOL isPopup;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UIView *subBottomView;
@property (weak, nonatomic) IBOutlet UITextField *verfyCodeField;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *thirdPartyTitleLbl;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_top;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView_top;
@property (weak, nonatomic) IBOutlet UIView *fetchCodeView;

@property (weak, nonatomic) IBOutlet UIView *submitButton;

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
    
    self.accountField.delegate = self;
    self.accountField.keyboardAppearance = UIKeyboardAppearanceLight;
    self.accountField.keyboardType = UIKeyboardTypeASCIICapable;
    self.accountField.returnKeyType = UIReturnKeyNext;
    self.accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.verfyCodeField.delegate = self;
    self.verfyCodeField.keyboardAppearance = UIKeyboardAppearanceLight;
    self.verfyCodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.verfyCodeField.returnKeyType = UIReturnKeyNext;
    
    self.passwordField.delegate = self;
    self.passwordField.keyboardAppearance = UIKeyboardAppearanceLight;
    self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordField.returnKeyType = UIReturnKeyGo;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.secureTextEntry = YES;
    
    self.wechatBtn.layer.cornerRadius  = 2;
    self.wechatBtn.layer.masksToBounds = YES;
    self.weiboBtn.layer.cornerRadius  = 2;
    self.weiboBtn.layer.masksToBounds = YES;
    self.qqBtn.layer.cornerRadius  = 2;
    self.qqBtn.layer.masksToBounds = YES;
    self.submitButton.layer.cornerRadius  = 2;
    self.submitButton.layer.masksToBounds = YES;
    
    [self judge];
}

- (IBAction)sendVerBtn:(UIButton *)sender {
    //    //如果手机号正确，发送短信
    //    NSDictionary *params = @{
    //                             @"mobile":_signupView.phoneNumTF.text
    //                             };
    //    FBRequest *request = [FBAPI postWithUrlString:VerifyCodeURL requestDictionary:params delegate:self];
    //    request.flag = VerifyCodeURL;
    //    [request startRequest];
    
    if ([_accountField.text checkTel]) {
        
        FBRequest *request1 = [FBAPI postWithUrlString:@"/auth/check_account" requestDictionary:@{@"account":_accountField.text} delegate:self];
        
        [request1 startRequestSuccess:^(FBRequest *request, id result) {
            if ([result objectForKey:@"success"]) {
                //如果手机号正确，发送短信
                NSDictionary *params = @{
                                         @"mobile":_accountField.text
                                         };
                FBRequest *request = [FBAPI postWithUrlString:VerifyCodeURL requestDictionary:params delegate:self];
                request.flag = VerifyCodeURL;
                [request startRequest];
                //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
                self.sendBtn.hidden = YES;
                [self startTime];
            }else{
                [SVProgressHUD showWithStatus:[result objectForKey:@"message"]];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号不正确"];
    }
}

- (IBAction)signupBtn:(UIButton *)sender {
    if (![_accountField.text checkTel]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"enterCorrectPhoneNumber", nil)];
        return;
    }
    if (!_verfyCodeField.text.length) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"enterVerificationCode", nil)];
        return;
    }
    if (_passwordField.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不得少于6位"];
        return;
    }
    NSDictionary *params = @{
                             @"mobile": _accountField.text,
                             @"password": _passwordField.text,
                             @"verify_code": _verfyCodeField.text,
                             @"from_to" : @1
                             };
    FBRequest *request = [FBAPI postWithUrlString:RegisterCodeURL requestDictionary:params delegate:self];
    request.flag = RegisterCodeURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

#pragma mark -判断手机是否安装了相应的客户端
-(void)judge{
    //隐藏未安装的第三方登录平台
    if (![WXApi isWXAppInstalled] && ![WeiboSDK isWeiboAppInstalled] && ![QQApiInterface isQQInstalled]) {
        self.thirdPartyTitleLbl.hidden = true;
    }
    if ([WXApi isWXAppInstalled] == FALSE) {
        self.wechatBtn.hidden = true;
    }
    if ([WeiboSDK isWeiboAppInstalled] == FALSE) {
        self.weiboBtn.hidden = true;
    }
    if ([QQApiInterface isQQInstalled] == FALSE) {
        self.qqBtn.hidden = true;
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
//                _signupView.toResendV.hidden = YES;
                self.sendBtn.hidden = NO;
            });
        }//按钮显示剩余时间
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2dS",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                _timeLabel.text = strTime;
                [UIView commitAnimations];
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.isPopup) {
        [UIView animateWithDuration:0.3 animations:^{
            self.topView_top.constant = -230+40;
            self.bottomView_top.constant = 0;
            [self.view layoutIfNeeded];
            self.topView.alpha = 0;
            self.subBottomView.alpha = 1;
        }];
        self.isPopup = true;
    }
    return YES;
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
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            //跳转到手机号登录界面
            UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:nil];
            FBLoginViewController *loginVC = [loginStory instantiateViewControllerWithIdentifier:@"FBLoginViewController"];
            //手机号登录按钮选中
//            [loginVC clickPhoneNumTF:loginVC.phoneNumTFBtn];
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
            //如果成功，进行关联，并且更新当前用户信息
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@3];
        }//如果失败，提示失败信息
        else{
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    });
}

#pragma mark -第三方登录成功后取到用户信息
//如果成功，进行关联，并且更新当前用户信息
-(void)afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:(UMSocialAccountEntity *)snsAccount type:(NSNumber *)type{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    UMSocialConfig *h = [[UMSocialConfig alloc] init];
    h.hiddenLoadingHUD = YES;
    //发送注册请求
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
        //如果请求成功
        NSDictionary *dataDic = [result objectForKey:@"data"];
        if ([[dataDic objectForKey:@"has_user"] isEqualToNumber:@1]) {
            //用户存在，更新当前用户的信息
            UserInfo *userinfo = [UserInfo mj_objectWithKeyValues:[dataDic objectForKey:@"user"]];
            [userinfo saveOrUpdate];
            [userinfo updateUserInfoEntity];
            
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            
            
            [SVProgressHUD showSuccessWithStatus:@"认证成功"];
            
            NSString *str = dataDic[@"user"][@"identify"][@"is_scene_subscribe"];
            if ([str integerValue] == 0) {
//                //跳转到推荐界面
//                SubscribeInterestedCollectionViewController *subscribeVC = [[SubscribeInterestedCollectionViewController alloc] init];
                ImprovViewController *vc = [[ImprovViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            [SVProgressHUD dismiss];
            //跳转到绑定手机号界面
            BindIngViewController *bing = [[BindIngViewController alloc] init];
            bing.snsAccount = snsAccount;
            bing.type = type;
            [self.navigationController pushViewController:bing animated:YES];
            //如果用户不存在,提示用户是否进行绑定
        }
    } failure:^(FBRequest *request, NSError *error) {
        //如果请求失败，提示错误信息
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:true];
}

//取消按钮,返回首页
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    if (self.isPopup) {
        [self.accountField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView_top.constant = 0;
            self.topView_top.constant = 40;
            [self.view layoutIfNeeded];
            self.topView.alpha = 1;
            self.subBottomView.alpha = 0;
        }];
        self.isPopup = false;
        return;
    }
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
