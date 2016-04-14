//
//  PhoneToLogInViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PhoneToLogInViewController.h"
#import "MyViewController.h"
#import "SVProgressHUD.h"
#import "NSString+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#include "UserInfoEntity.h"

@interface PhoneToLogInViewController ()<FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;//手机号或邮箱
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;//提示用的laebl

@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;//密码 提示用的label

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录按钮
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;//密码
@end

NSString *const LoginURL = @"/auth/login";//登录接口

@implementation PhoneToLogInViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    //登录按钮变圆滑
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 3;
    
    //设置textfiled的tag值
    self.phoneTextField.tag = 10;
    self.pwdTextField.tag = 20;
    //水印文字
    
    
}
//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//取消按钮，跳回到首页
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//点击手机号textFeild
- (IBAction)clickPhoneTextFeild:(UIButton *)sender {
    //水印消失
    self.phoneNumLabel.hidden = YES;
    //判断密码是否为空
    if (self.pwdTextField.text.length == 0) {
        //如果是空的，水印显示
        self.pwdLabel.hidden = NO;
    }
    
    //如果不是空的，水印消失
    else{
        self.pwdLabel.hidden = YES;
    }
    //成为第一响应者
    [self.phoneTextField becomeFirstResponder];
}

//点击密码textFeild
- (IBAction)clickPwdTextFeild:(UIButton *)sender {
    //水印消失
    self.pwdLabel.hidden = YES;
    //判断密码是否为空
    if (self.phoneTextField.text.length == 0) {
        //如果是空的，水印显示
        self.phoneNumLabel.hidden = NO;
    }
    
    //如果不是空的，水印消失
    else{
        self.phoneNumLabel.hidden = YES;
    }
    //成为第一响应者
    [self.pwdTextField becomeFirstResponder];
}

//登录按钮
- (IBAction)loginBtn:(UIButton *)sender {
    if (![self.phoneTextField.text checkTel]) {
        //手机号错误提示
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"enterCorrectPhoneNumber", nil)];
        return;
    }//密码格式错误提示
    else if(self.pwdTextField.text.length < 6){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"passwordDigits", nil)];
        return;
    }
    //将填写的信息提交服务器
    NSDictionary *params = @{
                             @"mobile":self.phoneTextField.text,
                             @"password":self.pwdTextField.text,
                             @"from_to":@1
                             };
    FBRequest *request = [FBAPI postWithUrlString:LoginURL requestDictionary:params delegate:self];
    request.flag = LoginURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

#pragma mark -fbrequestDElegate
-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:LoginURL]) {
        //如果成功，获取到用户的信息
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [userInfo saveOrUpdate];
            [userInfo updateUserInfoEntity];
            NSLog(@"%@",userInfo);
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            
            UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
            MyViewController *myVC = [myStoryBoard instantiateViewControllerWithIdentifier:@"MyViewController"];
            [self.navigationController pushViewController:myVC animated:YES];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"loginSuccessful", nil)];
            //跳回个人主页
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.tabBarController setSelectedIndex:3];
        }//如果失败，提示用户失败原因
        else{
            NSString *message = result[@"message"];
            [SVProgressHUD showErrorWithStatus:message];
        }
    }
    
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
