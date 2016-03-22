//
//  FBSignupViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBSignupViewController.h"
#import "NSString+Helper.h"
#import "Fineix.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"

@interface FBSignupViewController ()<FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationCodeBtn;//发送验证码按钮
@end
static NSString *const RegisterCodeURL = @"/auth/register";//手机号注册
static NSString *const VerifyCodeURL = @"/auth/verify_code";//发送验证码借口
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
