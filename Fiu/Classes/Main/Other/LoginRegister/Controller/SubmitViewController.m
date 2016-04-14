//
//  SubmitViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SubmitViewController.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#include "UserInfoEntity.h"
#import "HomeViewController.h"
#import "PhoneToLogInViewController.h"


@interface SubmitViewController ()<FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;//验证码
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;//发送验证码按钮
@property (weak, nonatomic) IBOutlet UILabel *verCodeLabel;//验证码水印

@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;//设置新密码水印
@property (weak, nonatomic) IBOutlet UITextField *setPwdTF;//设置新密码

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录按钮

@end

static NSString *const VerifyCodeURL = @"/auth/verify_code";//发送验证码接口
static NSString *const FindPwdURL = @"/auth/find_pwd";//忘记密码接口
@implementation SubmitViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    //如果手机号正确，发送短信
    NSDictionary *params = @{
                             @"mobile":self.phoneNumStr
                             };
    FBRequest *request = [FBAPI postWithUrlString:VerifyCodeURL requestDictionary:params delegate:self];
    request.flag = VerifyCodeURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    //开始倒计时，发送验证码
    [self startTime];
    //登录按钮变圆润
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 3;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark -FBRequestDelegate
-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:VerifyCodeURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }else{
            NSString *message = result[@"message"];
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    if ([request.flag isEqualToString:FindPwdURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            //设置完新密码后更新用户信息
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [userInfo saveOrUpdate];
            [userInfo updateUserInfoEntity];
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            //跳转到手机号登录界面
            UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:nil];
            PhoneToLogInViewController *phoneTolLoginVC = [loginStory instantiateViewControllerWithIdentifier:@"PhoneToLogInViewController"];
            [self.navigationController pushViewController:phoneTolLoginVC animated:YES];
        }else{
            NSString *message = result[@"message"];
            [SVProgressHUD showErrorWithStatus:message];
        }
    }
}

//点击验证码TextFeild
- (IBAction)clickVerCodeTextFeild:(UIButton *)sender {
    //水印消失
    self.verCodeLabel.hidden = YES;
    //判断密码是否为空
    if (self.setPwdTF.text.length == 0) {
        //如果是空的，水印显示
        self.pwdLabel.hidden = NO;
    }
    
    //如果不是空的，水印消失
    else{
        self.pwdLabel.hidden = YES;
    }
    //成为第一响应者
    [self.verificationCodeTF becomeFirstResponder];

}

//点击新密码TextFeild
- (IBAction)clickPwdTextfeild:(UIButton *)sender {
    //水印消失
    self.pwdLabel.hidden = YES;
    //判断密码是否为空
    if (self.verificationCodeTF.text.length == 0) {
        //如果是空的，水印显示
        self.verCodeLabel.hidden = NO;
    }
    
    //如果不是空的，水印消失
    else{
        self.verCodeLabel.hidden = YES;
    }
    //成为第一响应者
    [self.setPwdTF becomeFirstResponder];
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
                [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.sendBtn.userInteractionEnabled = YES;
            });
        }//按钮显示剩余时间
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.sendBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.sendBtn.userInteractionEnabled = NO;
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
    
    
}

//发送验证码按钮
- (IBAction)sendVerificationCodeBtn:(UIButton *)sender {
    //开始倒计时
    [self startTime];
    //发送验证码
    NSDictionary *params = @{
                             @"mobile":self.phoneNumStr
                             };
    FBRequest *request = [FBAPI postWithUrlString:VerifyCodeURL requestDictionary:params delegate:self];
    request.flag = VerifyCodeURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//取消按钮,跳回到首页
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//提交按钮
- (IBAction)submitBtn:(UIButton *)sender {
    //判断验证码
    if (!self.verificationCodeTF.text.length) {
        //如果验证码不正确提示错误信息
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
    }//如果验证码正确重设密码
    else{
        //输入新密码
        //判断新密码
        if (self.setPwdTF.text.length < 6) {
            //如果密码错误，提示错误信息
            [SVProgressHUD showErrorWithStatus:@"密码不能少于6位"];
        }//如果新密码正确，发送请求设置新的密码
        else{
            NSDictionary *params = @{
                                     @"mobile" : self.phoneNumStr,
                                     @"password" : self.setPwdTF.text,
                                     @"verify_code" : self.verificationCodeTF.text
                                     };
            FBRequest *request = [FBAPI postWithUrlString:FindPwdURL requestDictionary:params delegate:self];
            request.flag = FindPwdURL;
            [request startRequest];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            
        }
        
        
        
    }

}
@end
