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


@interface FBSignupViewController ()<FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@end
static NSString *const RegisterCodeURL = @"/auth/register";

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

#pragma mark - FBRequest Delegate
//-(void)requestSucess:(FBRequest *)request result:(id)result{
//    if ([request.flag isEqualToString:RegisterCodeURL]) {
//        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
//            UserInfo * userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
//            [userInfo updateUserInfoEntity];
//            UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
//            userEntity.isLogin = YES;
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [userInfo saveOrUpdate];
//                //                NSUserDefaults * userSet = [NSUserDefaults standardUserDefaults];
//                //                [userSet setObject:[NSNumber numberWithBool:userEntity.isLogin] forKey:@"isLogin"];
//                //                [userSet synchronize];
//            });
//            
//            [self dismissViewControllerAnimated:YES completion:nil];
//            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
//        } else {
//            NSString * message = result[@"message"];
//            [SVProgressHUD showInfoWithStatus:message];
//        }
//    }
//
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
