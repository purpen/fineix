//
//  FBLoginViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBLoginViewController.h"
#import "SVProgressHUD.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "Fiu.h"
#import "NSString+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "MyViewController.h"
#import "PhoneNumLoginView.h"
#import "SubmitView.h"
#import "FBSignupViewController.h"
#import <TYAlertController.h>
#import <TYAlertView.h>
#import "FBBindingMobilePhoneNumber.h"
#import "SubscribeInterestedCollectionViewController.h"


@interface FBLoginViewController ()<UITextFieldDelegate,FBRequestDelegate>
{
    PhoneNumLoginView *_phoneNumLoginV;
    SubmitView *_submitView;
}

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

NSString *const LoginURL = @"/auth/login";//登录接口
NSString *const thirdLoginUrl = @"/auth/third_sign";//第三方登录接口
NSString *const logOut = @"/auth/logout";//退出登录接口
static NSString *const VerifyCodeURL = @"/auth/verify_code";//发送验证码接口
static NSString *const FindPwdURL = @"/auth/find_pwd";//忘记密码接口
static NSString *const thirdRegister = @"/auth/third_sign";//第三方登录接口
static NSString *const thirdRegisteredNotBinding = @"/auth/third_register_without_phone";//第三方快捷注册(不绑定手机号)接口

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
    self.wechatBtn.layer.cornerRadius  = 3;
    self.wechatBtn.layer.masksToBounds = YES;
    self.weiboBtn.layer.cornerRadius  = 3;
    self.weiboBtn.layer.masksToBounds = YES;
    self.qqBtn.layer.cornerRadius  = 3;
    self.qqBtn.layer.masksToBounds = YES;
    //隐藏的view
    _phoneNumLoginV = [[PhoneNumLoginView alloc] init];
    
    CGRect frame = _phoneNumLoginV.frame;
    frame.origin.y = 1000;
    _phoneNumLoginV.frame = frame;
    _phoneNumLoginV.phoneTF.delegate = self;
    _phoneNumLoginV.pwdTF.delegate = self;
    [self.view addSubview:_phoneNumLoginV];
    //给登录连接方法
    [_phoneNumLoginV.loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    //快速注册
    [_phoneNumLoginV.soonBtn addTarget:self action:@selector(clickSoonBtn:) forControlEvents:UIControlEventTouchUpInside];
    //忘记密码
    [_phoneNumLoginV.forgetBtn addTarget:self action:@selector(clickforgetBtn:) forControlEvents:UIControlEventTouchUpInside];
    //提交view
    _submitView = [SubmitView getSubmitView];
    _submitView.phoneNumTF.delegate = self;
    _submitView.verificationCodeTF.delegate = self;
    _submitView.setANewPasswordTF.delegate = self;
    _submitView.frame = CGRectMake(0, 0, SCREEN_WIDTH,244/667.0*SCREEN_HEIGHT );
    CGRect submitViewframe = _submitView.frame;
    submitViewframe.origin.y = 50/667.0*SCREEN_HEIGHT;
    _submitView.hidden = YES;
    _submitView.frame = submitViewframe;
    [self.view addSubview:_submitView];
    //一开始重新发送view不存在
    _submitView.toResendV.hidden = YES;
    //点击发送验证码，判断手机号如果手机号正确发送验证码，并且重新发送view出现，并且开始跳字
    [_submitView.sendVerificationCodeBtn addTarget:self action:@selector(clikSendVerBtn:) forControlEvents:UIControlEventTouchUpInside];
    //如果手机号不正确提示用户
    //时间到了后重新发送view消失
    //点击提交按钮
    _submitView.submitBtn.userInteractionEnabled = YES;
    [_submitView.submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
}

//点击提交按钮
-(void)clickSubmitBtn:(UIButton*)sender{
    //判断验证码
    if (!_submitView.verificationCodeTF.text.length) {
        //如果验证码不正确提示错误信息
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
    }//如果验证码正确重设密码
    else{
        //输入新密码
        //判断新密码
        if (_submitView.setANewPasswordTF.text.length < 6) {
            //如果密码错误，提示错误信息
            [SVProgressHUD showErrorWithStatus:@"密码不能少于6位"];
        }//如果新密码正确，发送请求设置新的密码
        else{
            NSDictionary *params = @{
                                     @"mobile" : _submitView.phoneNumTF.text,
                                     @"password" : _submitView.setANewPasswordTF.text,
                                     @"verify_code" : _submitView.verificationCodeTF.text
                                     };
            FBRequest *request = [FBAPI postWithUrlString:FindPwdURL requestDictionary:params delegate:self];
            request.flag = FindPwdURL;
            [request startRequest];
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
            //提交view消失，手机号登录view出现
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = _submitView.frame;
                frame.origin.y = 100/667.0*SCREEN_HEIGHT;
                _submitView.frame = frame;
                _submitView.hidden = YES;
                _phoneNumLoginV.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
}

//点击发送验证码，判断手机号如果手机号正确发送验证码，并且重新发送view出现，并且开始跳字
-(void)clikSendVerBtn:(UIButton*)sender{
    if ([_submitView.phoneNumTF.text checkTel]) {
        //如果手机号正确，发送短信
        NSDictionary *params = @{
                                 @"mobile":_submitView.phoneNumTF.text
                                 };
        FBRequest *request = [FBAPI postWithUrlString:VerifyCodeURL requestDictionary:params delegate:self];
        request.flag = VerifyCodeURL;
        [request startRequest];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        _submitView.toResendV.hidden = NO;
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
                _submitView.toResendV.hidden = YES;
            });
        }//按钮显示剩余时间
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                _submitView.backToTheTimeL.text = strTime;
                [UIView commitAnimations];
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
    
    
}

//忘记密码
-(void)clickforgetBtn:(UIButton*)sender{
    //登录view消失，找回密码view出现
    [UIView animateWithDuration:0.5 animations:^{
        _phoneNumLoginV.hidden = YES;
        _submitView.hidden = NO;
        CGRect submitViewframe = _submitView.frame;
        submitViewframe.origin.y = 117.0/667.0*SCREEN_HEIGHT;
        _submitView.frame = submitViewframe;
    } completion:^(BOOL finished) {
        //成为第一响应者
        
    }];
    
}

//键盘收回
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

//快速注册
-(void)clickSoonBtn:(UIButton*)sender{
    //跳到注册界面
    UIStoryboard *signupStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:nil];
    FBSignupViewController *signupVC = [signupStory instantiateViewControllerWithIdentifier:@"FBSignupViewController"];
    [self.navigationController pushViewController:signupVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击登录按钮
-(void)clickLoginBtn:(UIButton*)sender{
    if (![_phoneNumLoginV.phoneTF.text checkTel]) {
        //手机号错误提示
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"enterCorrectPhoneNumber", nil)];
        return;
    }//密码格式错误提示
    else if(_phoneNumLoginV.pwdTF.text.length < 6){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"passwordDigits", nil)];
        return;
    }
    //将填写的信息提交服务器
    NSDictionary *params = @{
                             @"mobile":_phoneNumLoginV.phoneTF.text,
                             @"password":_phoneNumLoginV.pwdTF.text,
                             @"from_to":@1
                             };
    FBRequest *request = [FBAPI postWithUrlString:LoginURL requestDictionary:params delegate:self];
    request.flag = LoginURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

#pragma mark -fbrequestDElegate
-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:VerifyCodeURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }else{
            NSString *message = result[@"message"];
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    
    if ([request.flag isEqualToString:LoginURL]) {
        //如果成功，获取到用户的信息
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [userInfo saveOrUpdate];
            [userInfo updateUserInfoEntity];
            NSLog(@"%@",userInfo);
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            
//            UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
//            MyViewController *myVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"MyViewController"];
//            [self.navigationController pushViewController:myVC animated:YES];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"loginSuccessful", nil)];
            //推荐感兴趣的情景
            NSDictionary *identifyDict = [[result objectForKey:@"data"] objectForKey:@"identify"];
            NSLog(@"是否订阅%@",[identifyDict objectForKey:@"is_scene_subscribe"]);
            if ([[identifyDict objectForKey:@"is_scene_subscribe"] isEqualToNumber:@0]) {
                //跳转到推荐界面
                SubscribeInterestedCollectionViewController *subscribeVC = [[SubscribeInterestedCollectionViewController alloc] init];
                [self.navigationController pushViewController:subscribeVC animated:YES];
                NSLog(@"跳转到推荐界面");
            }else{
                //已经订阅过，直接个人中心
                //跳回个人主页
                //跳回个人主页
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.tabBarController setSelectedIndex:3];
                
            }

        }//如果失败，提示用户失败原因
        else{
            NSString *message = result[@"message"];
            [SVProgressHUD showErrorWithStatus:message];
        }
    }
    
    
}


-(void)clickPhoneNumTF:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        self.topView.hidden = YES;
        CGRect frame = _phoneNumLoginV.frame;
        frame.origin.y = 117.0/667.0*SCREEN_HEIGHT;
        _phoneNumLoginV.frame = frame;
    } completion:^(BOOL finished) {
        //成为第一响应者
        [_phoneNumLoginV.phoneTF becomeFirstResponder];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}
//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    //如果submitView存在，让另一个view出现
    if (_submitView.hidden == NO) {
        
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _submitView.frame;
            frame.origin.y = 100/667.0*SCREEN_HEIGHT;
            _submitView.frame = frame;
            _submitView.hidden = YES;
            _phoneNumLoginV.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    //如果topview存在，返回
    if (self.topView.hidden == NO) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    //如果另一个view存在让topview出现
    if (_phoneNumLoginV.hidden == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _phoneNumLoginV.frame;
            frame.origin.y = 1000;
            _phoneNumLoginV.frame = frame;
        } completion:^(BOOL finished) {
            self.topView.hidden = NO;
        }];
        return;
    }
    

}

//取消按钮，返回首页
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickWeChatBtn:(UIButton *)sender {
    //微信登录
    
    //如果微信登录失败，提示错误信息
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            //如果微信登录成功，取到用户信息
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@1];
            
            //得到的数据在回调Block对象形参respone的data属性
//                        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *response){
//                            NSLog(@"SnsInformation is %@", response.data);
//                        }];
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];//错误原因
        }
    });

}
- (IBAction)clickWeiBoBtn:(UIButton *)sender {
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

- (IBAction)clickQQBtn:(UIButton *)sender {
    //QQ登录
    
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        
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

#pragma mark -第三方登录成功后取到用户信息
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

//#pragma mark -点击登录按钮
//- (IBAction)clickLoginBtn:(UIButton *)sender {
//    
//    
//    
//    if (![self.accountField.text checkTel]) {
//        //手机号错误提示
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
//        return;
//    }//密码格式错误提示
//    else if(self.passwordField.text.length < 6){
//        [SVProgressHUD showErrorWithStatus:@"密码不得少于6位"];
//        return;
//    }
//    //将填写的信息提交服务器
//    NSDictionary *params = @{
//                             @"mobile":self.accountField.text,
//                             @"password":self.passwordField.text,
//                             @"from_to":@1
//                             };
//    FBRequest *request = [FBAPI postWithUrlString:LoginURL requestDictionary:params delegate:self];
//    request.flag = LoginURL;
//    [request startRequest];
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//    
//    
//}


//#pragma mark -fbrequestDElegate
//-(void)requestSucess:(FBRequest *)request result:(id)result{
//    if ([request.flag isEqualToString:LoginURL]) {
//        //如果成功，获取到用户的信息
//        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
//            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
//            [userInfo saveOrUpdate];
//            [userInfo updateUserInfoEntity];
//            NSLog(@"%@",userInfo);
//            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
//            entity.isLogin = YES;
//            
//            [self dismissViewControllerAnimated:YES completion:nil];
//            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//        }//如果失败，提示用户失败原因
//        else{
//            NSString *message = result[@"message"];
//            [SVProgressHUD showErrorWithStatus:message];
//        }
//    }
//    //退出登录操作
//    if ([request.flag isEqualToString:logOut]) {
//        //更新用户信息，并且登录状态改变
//        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
//        entity.isLogin = NO;
//        [entity clear];
//        [UserInfo clearTable];
//        [SVProgressHUD showSuccessWithStatus:@"登出成功"];
//    }
//    
//}

////退出登录
//- (IBAction)clickLogOutBtn:(UIButton *)sender {
//    //如果已经登录了开始发送网络请求
//    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
//    //if (entity.isLogin == YES) {
//        NSDictionary *params = @{
//                                 @"from_to":@1
//                                 };
//        FBRequest *request = [FBAPI postWithUrlString:logOut requestDictionary:params delegate:self];
//        request.flag = logOut;
//        [request startRequest];
//    //}
//    //如果还没有登录提示用户登录
////    else{
////        [SVProgressHUD showInfoWithStatus:@"请先登录"];
////    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
