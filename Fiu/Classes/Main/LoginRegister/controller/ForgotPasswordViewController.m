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
#import "Fiu.h"
#import "UserInfo.h"
#include "UserInfoEntity.h"
#import "SubmitViewController.h"

@interface ForgotPasswordViewController ()<FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;//手机号水印

@end

static NSString *const VerifyCodeURL = @"/auth/verify_code";//发送验证码借口
static NSString *const FindPwdURL = @"/auth/find_pwd";
@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //输入手机号
    
    
    
    //填写验证码
    
    
    
    
}

//手机号
- (IBAction)phoneNumBtn:(UIButton *)sender {
    //点击水印消失
    self.phoneNumLabel.text = @"";
    //成为第一响应者
    [self.phoneNumTF becomeFirstResponder];
}

//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//取消按钮
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//发送按钮
- (IBAction)sendBtn:(UIButton *)sender {
    //判断手机号
    if ([self.phoneNumTF.text checkTel]) {
        //如果手机号正确跳转，并传值
        UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:nil];
        SubmitViewController *submitVC = [loginStory instantiateViewControllerWithIdentifier:@"SubmitViewController"];
        submitVC.phoneNumStr = self.phoneNumTF.text;
        [self.navigationController pushViewController:submitVC animated:YES];
    }//如果手机号不正确，提示错误
    else{
        [SVProgressHUD showErrorWithStatus:@"手机号错误"];
    }
    
    
}


@end
