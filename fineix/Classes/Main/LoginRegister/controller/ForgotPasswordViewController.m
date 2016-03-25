//
//  ForgotPasswordViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "SVProgressHUD.h"
#import "NSString+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "Fineix.h"
#import "UserInfo.h"
#include "UserInfoEntity.h"

@interface ForgotPasswordViewController ()<FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

static NSString *const VerifyCodeURL = @"/auth/verify_code";//发送验证码借口
static NSString *const FindPwdURL = @"/auth/find_pwd";
@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //输入手机号
    
    
    
    //填写验证码
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickSendBtn:(UIButton *)sender {
    //判断手机号
    if ([self.phoneNumTF.text checkTel]) {
       //如果手机号正确，发送短信
        NSDictionary *params = @{
                                 @"mobile":self.phoneNumTF.text
                                 };
        FBRequest *request = [FBAPI postWithUrlString:VerifyCodeURL requestDictionary:params delegate:self];
        request.flag = VerifyCodeURL;
        [request startRequest];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
    }//如果手机号错误，提示错误信息
    else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
    }
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
            [userInfo updateUserInfoEntity];
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [userInfo saveOrUpdate];
            });
            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        }else{
            NSString *message = result[@"message"];
            [SVProgressHUD showErrorWithStatus:message];
        }
    }
}


- (IBAction)clickResetBtn:(UIButton *)sender {
    //判断验证码
    if (!self.verificationCodeTF.text.length) {
        //如果验证码不正确提示错误信息
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
    }//如果验证码正确重设密码
    else{
        //输入新密码
        //判断新密码
        if (self.passwordTF.text.length < 6) {
            //如果密码错误，提示错误信息
            [SVProgressHUD showErrorWithStatus:@"密码不能少于6位"];
        }//如果新密码正确，发送请求设置新的密码
        else{
            NSDictionary *params = @{
                                     @"mobile" : self.phoneNumTF.text,
                                     @"password" : self.passwordTF.text,
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
