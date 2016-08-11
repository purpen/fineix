//
//  THNLoginViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNLoginViewController.h"
#import "NSString+Helper.h"
#import <SVProgressHUD.h>
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "THNInformationViewController.h"
#import "THNForgetViewController.h"
#import "UIColor+Extension.h"

@interface THNLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIView *seeView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/**  */
@property (nonatomic, strong) UIView *left;
/**  */
@property (nonatomic, strong) UIView *left2;
@end

NSString *const LoginURL = @"/auth/login";//登录接口
static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation THNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self circle:self.pwdTF];
    [self circle:self.phoneTF];
    [self circle:self.seeView];
    [self circle:self.loginBtn];
    
    [self.phoneTF setValue:[UIColor colorWithHexString:@"#898989"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.phoneTF.tintColor = [UIColor whiteColor];
    self.phoneTF.leftView = self.left;
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;

    [self.pwdTF setValue:[UIColor colorWithHexString:@"#898989"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.pwdTF.tintColor = [UIColor whiteColor];
    self.pwdTF.leftView = self.left2;
    self.pwdTF.leftViewMode = UITextFieldViewModeAlways;
}

-(UIView *)left2{
    if (!_left2) {
        _left2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _left2.backgroundColor = [UIColor clearColor];
    }
    return _left2;
}

-(UIView *)left{
    if (!_left) {
        _left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _left.backgroundColor = [UIColor clearColor];
    }
    return _left;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)lock:(id)sender {
    self.pwdTF.secureTextEntry = YES;
}

- (IBAction)see:(id)sender {
    self.pwdTF.secureTextEntry = NO;
}

- (IBAction)login:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    if (![self.phoneTF.text checkTel]) {
        //手机号错误提示
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"enterCorrectPhoneNumber", nil)];
        return;
    }else if(self.pwdTF.text.length < 6){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"passwordDigits", nil)];
        return;
    }
    NSDictionary *params = @{
                             @"mobile":self.phoneTF.text,
                             @"password":self.pwdTF.text,
                             @"from_to":@1
                             };
    FBRequest *request = [FBAPI postWithUrlString:LoginURL requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
        [userInfo saveOrUpdate];
        [userInfo updateUserInfoEntity];
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        entity.isLogin = YES;
        //跳回个人主页
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        NSDictionary *dataDic = result[@"data"];
        NSString *str = dataDic[@"identify"][@"is_scene_subscribe"];
        if ([str integerValue] == 0) {
            THNInformationViewController *vc = [[THNInformationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)forget:(id)sender {
    THNForgetViewController *vc = [[THNForgetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)wechat:(id)sender {
}


- (IBAction)sina:(id)sender {
}

- (IBAction)qq:(id)sender {
}

-(void)circle:(UIView*)sender{
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 3;
}

@end
