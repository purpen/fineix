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

@interface FBSignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@end

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
