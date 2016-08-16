//
//  THNSetPwdViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSetPwdViewController.h"
#import "UIColor+Extension.h"
#import <SVProgressHUD.h>
#import "FBRequest.h"
#import "FBAPI.h"

@interface THNSetPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@property (weak, nonatomic) IBOutlet UIButton *completedBtn;
/**  */
@property (nonatomic, strong) UIView *left;
@property (weak, nonatomic) IBOutlet UIView *seeView;
@end

static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
static NSString *const RegisterCodeURL = @"/auth/register";//手机号注册

@implementation THNSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 修改占位文字颜色
    [self.pwdTF setValue:[UIColor colorWithHexString:@"#898989"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.pwdTF.tintColor = [UIColor whiteColor];
    self.pwdTF.leftView = self.left;
    self.pwdTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self circle:self.pwdTF];
    [self circle:self.completedBtn];
    [self circle:self.seeView];
}

-(void)circle:(UIView*)sender{
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 3;
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

- (IBAction)completed:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    if (self.pwdTF.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不得少于6位"];
        return;
    }
    NSDictionary *params = @{
                             @"mobile": self.phoneStr,
                             @"password": self.pwdTF.text,
                             @"verify_code": self.codeStr,
                             @"from_to" : @1
                             };
    FBRequest *request = [FBAPI postWithUrlString:RegisterCodeURL requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
}


- (IBAction)lock:(UIButton*)sender {
    sender.selected = !sender.selected;
    self.pwdTF.secureTextEntry = sender.selected;
}

@end
