//
//  THNForgetViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNForgetViewController.h"
#import "NSString+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "THNUserData.h"
#import "SVProgressHUD.h"
#import "UIColor+Extension.h"

@interface THNForgetViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *vertCodeTF;
@property (weak, nonatomic) IBOutlet UIView *toResendV;
@property (weak, nonatomic) IBOutlet UILabel *backToTheTimeL;
@property (weak, nonatomic) IBOutlet UITextField *setNewPwd;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

static NSString *const VerifyCodeURL = @"/auth/verify_code";//发送验证码接口
static NSString *const FindPwdURL = @"/auth/find_pwd";//忘记密码接口
static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";


@implementation THNForgetViewController
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.setNewPwd.delegate = self;
    [self.phoneTF setValue:[UIColor colorWithHexString:@"#8B8B8B"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.phoneTF.tintColor = [UIColor whiteColor];
    [self.vertCodeTF setValue:[UIColor colorWithHexString:@"#8B8B8B"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.vertCodeTF.tintColor = [UIColor whiteColor];
    [self.setNewPwd setValue:[UIColor colorWithHexString:@"#8B8B8B"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.setNewPwd.tintColor = [UIColor whiteColor];
    _toResendV.hidden = YES;
    _toResendV.layer.masksToBounds = YES;
    _toResendV.layer.cornerRadius = 3;
    _sendBtn.layer.cornerRadius = 3;
    _sendBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 3;
}
- (IBAction)sendVerBtn:(UIButton *)sender {
    if ([_phoneTF.text checkTel]) {
        
        //如果手机号正确，发送短信
        NSDictionary *params = @{
                                 @"mobile":_phoneTF.text
                                 };
        FBRequest *request = [FBAPI postWithUrlString:VerifyCodeURL requestDictionary:params delegate:self];
        request.flag = VerifyCodeURL;
        [request startRequest];
        //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        _toResendV.hidden = NO;
        [self startTime];
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号不正确"];
    }
}

- (IBAction)submitBtn:(UIButton *)sender {
    //判断验证码
    if (!_vertCodeTF.text.length) {
        //如果验证码不正确提示错误信息
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
    }//如果验证码正确重设密码
    else{
        //输入新密码
        //判断新密码
        if (_setNewPwd.text.length < 6) {
            //如果密码错误，提示错误信息
            [SVProgressHUD showErrorWithStatus:@"密码不能少于6位"];
        }//如果新密码正确，发送请求设置新的密码
        else{
            NSDictionary *params = @{
                                     @"mobile" : _phoneTF.text,
                                     @"password" : _setNewPwd.text,
                                     @"verify_code" : _vertCodeTF.text
                                     };
            FBRequest *request = [FBAPI postWithUrlString:FindPwdURL requestDictionary:params delegate:self];
            request.flag = FindPwdURL;
            [request startRequest];
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
                //时间到了后重新发送view消失
                _toResendV.hidden = YES;
            });
        }//按钮显示剩余时间
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                _backToTheTimeL.text = strTime;
                [UIView commitAnimations];
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
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
    }else if ([request.flag isEqualToString:FindPwdURL]){
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            THNUserData * userInfo = [THNUserData mj_objectWithKeyValues:[result objectForKey:@"data"]];
            userInfo.isLogin = YES;
            [userInfo saveOrUpdate];
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        } else {
            NSString * message = result[@"message"];
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
}

@end
