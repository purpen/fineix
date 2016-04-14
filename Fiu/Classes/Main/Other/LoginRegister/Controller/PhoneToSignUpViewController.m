//
//  PhoneToSignUpViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PhoneToSignUpViewController.h"
#import "MyViewController.h"
#import "SVProgressHUD.h"
#import "NSString+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "PhoneToLogInViewController.h"

@interface PhoneToSignUpViewController ()<FBRequestDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;//手机号
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationCodeBtn;//发送验证码按钮

@property (weak, nonatomic) IBOutlet UITextField *pwdTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;//验证码
@property (weak, nonatomic) IBOutlet UILabel *verificationCodeLabel;//验证码水印label

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;//手机号label
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;//注册按钮
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;//密码label

@end
static NSString *const RegisterCodeURL = @"/auth/register";//手机号注册
static NSString *const VerifyCodeURL = @"/auth/verify_code";//发送验证码借口

@implementation PhoneToSignUpViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    //注册按钮变圆润
    self.signUpBtn.layer.masksToBounds = YES;
    self.signUpBtn.layer.cornerRadius = 3;
}
//点击手机号textFeild
- (IBAction)clikcPhoneTF:(UIButton *)sender {
    //水印消失
    self.phoneNumLabel.hidden = YES;
    //判断其他是否为空，如果是空的就水印显示，否则水印消失
    if (self.pwdTF.text.length == 0) {
        self.pwdLabel.hidden = NO;
    }else{
        self.pwdLabel.hidden = YES;
    }
    if (self.verificationCodeTF.text.length == 0) {
        self.verificationCodeLabel.hidden = NO;
    }else{
        self.verificationCodeLabel.hidden = YES;
    }
    //成为第一响应者
    [self.phoneNumTF becomeFirstResponder];
}

//点击密码textFeild
- (IBAction)clickPwdTF:(UIButton *)sender {
    //水印消失
    self.pwdLabel.hidden = YES;
    //判断其他是否为空，如果是空的就水印显示，否则水印消失
    if (self.phoneNumTF.text.length == 0) {
        self.phoneNumLabel.hidden = NO;
    }else{
        self.phoneNumLabel.hidden = YES;
    }
    if (self.verificationCodeTF.text.length == 0) {
        self.verificationCodeLabel.hidden = NO;
    }else{
        self.verificationCodeLabel.hidden = YES;
    }
    //成为第一响应者
    [self.pwdTF becomeFirstResponder];
}

//点击验证码textfeild
- (IBAction)clickVerificationTF:(UIButton *)sender {
    //水印消失
    self.verificationCodeLabel.hidden = YES;
    //判断其他是否为空，如果是空的就水印显示，否则水印消失
    if (self.pwdTF.text.length == 0) {
        self.pwdLabel.hidden = NO;
    }else{
        self.pwdLabel.hidden = YES;
    }
    if (self.phoneNumTF.text.length == 0) {
        self.phoneNumLabel.hidden = NO;
    }else{
        self.phoneNumLabel.hidden = YES;
    }
    //成为第一响应者
    [self.verificationCodeTF becomeFirstResponder];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//取消按钮
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//注册按钮
- (IBAction)signUpBtn:(UIButton *)sender {
    if (![self.phoneNumTF.text checkTel]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"enterCorrectPhoneNumber", nil)];
        return;
    }
    if (!self.phoneNumTF.text.length) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"enterVerificationCode", nil)];
        return;
    }
    if (self.pwdTF.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不得少于6位"];
        return;
    }
    NSDictionary *params = @{
                             @"mobile": self.phoneNumTF.text,
                             @"password": self.pwdTF.text,
                             @"verify_code": self.phoneNumTF.text,
                             @"from_to" : @1
                             };
    FBRequest *request = [FBAPI postWithUrlString:RegisterCodeURL requestDictionary:params delegate:self];
    request.flag = RegisterCodeURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

}

//发送验证码
- (IBAction)sendVerificationCodeBtn:(UIButton *)sender {
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

#pragma mark - FBRequest Delegate
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
            PhoneToLogInViewController *phoneTolLoginVC = [loginStory instantiateViewControllerWithIdentifier:@"PhoneToLogInViewController"];
            [self.navigationController pushViewController:phoneTolLoginVC animated:YES];
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

@end
