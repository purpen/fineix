//
//  ForgotPasswordViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "SubmitViewController.h"


@interface ForgotPasswordViewController ()

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
    
    
    //发送按钮变圆润
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 3;
    
}

//点击手机号textfeild
- (IBAction)clickPhoneNumTextFeild:(UIButton *)sender {
    //水印消失
    self.phoneNumLabel.hidden = YES;
}
//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//取消按钮,返回首页
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
