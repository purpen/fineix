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
#import "MyPageViewController.h"
#import "PhoneNumLoginView.h"
#import "SubmitView.h"
#import "FBSignupViewController.h"
#import <TYAlertController.h>
#import <TYAlertView.h>
#import "BindIngViewController.h"
#import "SubscribeInterestedCollectionViewController.h"
#import "ImprovViewController.h"
#import "ForgetViewController.h"


@interface FBLoginViewController ()<UITextFieldDelegate,FBRequestDelegate>
{
    PhoneNumLoginView *_phoneNumLoginV;
    SubmitView *_submitView;
}

@property (nonatomic, assign) BOOL isPopup;//弹出状态

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *subBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_top;
@end

NSString *const LoginURL = @"/auth/login";//登录接口
NSString *const thirdLoginUrl = @"/auth/third_sign";//第三方登录接口
NSString *const logOut = @"/auth/logout";//退出登录接口
static NSString *const thirdRegister = @"/auth/third_sign";//第三方登录接口


@implementation FBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.accountField.delegate = self;
    self.accountField.keyboardAppearance = UIKeyboardAppearanceLight;
    self.accountField.keyboardType = UIKeyboardTypeASCIICapable;
    self.accountField.returnKeyType = UIReturnKeyNext;
    self.accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountField.tag = 1101;
    
    self.passwordField.delegate = self;
    self.passwordField.keyboardAppearance = UIKeyboardAppearanceLight;
    self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordField.returnKeyType = UIReturnKeyGo;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.tag = 1102;
    
    self.wechatBtn.layer.cornerRadius  = 2;
    self.wechatBtn.layer.masksToBounds = YES;
    self.weiboBtn.layer.cornerRadius  = 2;
    self.weiboBtn.layer.masksToBounds = YES;
    self.qqBtn.layer.cornerRadius  = 2;
    self.qqBtn.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius  = 2;
    self.loginButton.layer.masksToBounds = YES;
    
    
    //判断手机是否安装了相应的客户端
    [self judge];
}

#pragma mark -判断手机是否安装了相应的客户端
-(void)judge{
    //隐藏未安装的第三方登录平台
    if (![WXApi isWXAppInstalled] && ![WeiboSDK isWeiboAppInstalled] && ![QQApiInterface isQQInstalled]) {
        self.topLabel.hidden = true;
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

//忘记密码
-(void)clickforgetBtn:(UIButton*)sender{
    ForgetViewController *vc = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//键盘收回
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -fbrequestDElegate
-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:LoginURL]) {
        //如果成功，获取到用户的信息
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [userInfo saveOrUpdate];
            [userInfo updateUserInfoEntity];
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            NSDictionary *dataDic = result[@"data"];
            NSNumber *str = dataDic[@"identify"][@"is_scene_subscribe"];
            if ([str isEqualToNumber:@0]) {
                //跳转到推荐界面
                SubscribeInterestedCollectionViewController *subscribeVC = [[SubscribeInterestedCollectionViewController alloc] init];
                [self.navigationController pushViewController:subscribeVC animated:YES];
            }else{
                //跳回个人主页
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                //跳回个人主页
                [self dismissViewControllerAnimated:YES completion:nil];
            }

        }//如果失败，提示用户失败原因
        else{
            NSString *message = result[@"message"];
            [SVProgressHUD showErrorWithStatus:message];
        }
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.isPopup) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView_top.constant = -230;
            [self.view layoutIfNeeded];
            self.topView.alpha = 0;
            self.subBottomView.alpha = 1;
        }];
        self.isPopup = true;
    }
    
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:true];
}

//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    if (self.isPopup) {
        [self.accountField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView_top.constant = 0;
            [self.view layoutIfNeeded];
            self.topView.alpha = 1;
            self.subBottomView.alpha = 0;
        }];
        self.isPopup = false;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
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
            
            
            NSNumber *str = dataDic[@"user"][@"identify"][@"is_scene_subscribe"];
            if ([str isEqualToNumber:@0]) {
                //跳转到推荐界面
                SubscribeInterestedCollectionViewController *subscribeVC = [[SubscribeInterestedCollectionViewController alloc] init];
                [self.navigationController pushViewController:subscribeVC animated:YES];
            }else{
                //已经订阅过，直接个人中心
                //跳回个人主页
                //跳回个人主页
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

- (IBAction)forgetBtn:(UIButton *)sender {
    ForgetViewController *vc = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginBtn:(UIButton *)sender {
    if (![self.accountField.text checkTel]) {
        //手机号错误提示
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"enterCorrectPhoneNumber", nil)];
        return;
    }//密码格式错误提示
    else if(self.passwordField.text.length < 6){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"passwordDigits", nil)];
        return;
    }
    //将填写的信息提交服务器
    NSDictionary *params = @{
                             @"mobile":self.accountField.text,
                             @"password":self.passwordField.text,
                             @"from_to":@1
                             };
    FBRequest *request = [FBAPI postWithUrlString:LoginURL requestDictionary:params delegate:self];
    request.flag = LoginURL;
    [request startRequest];
    //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
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
