//
//  THNLoginRegisterViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNLoginRegisterViewController.h"
#import "THNSignUpViewController.h"

@interface THNLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

@end

@implementation THNLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navView.hidden = YES;
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES];
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 3;
    
    self.signUpBtn.layer.masksToBounds = YES;
    self.signUpBtn.layer.cornerRadius = 3;
}

- (IBAction)cancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginClick:(id)sender {
}
- (IBAction)signUpClick:(id)sender {
    THNSignUpViewController *vc = [[THNSignUpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)weixinClick:(id)sender {
}
- (IBAction)sinaClick:(id)sender {
}
- (IBAction)qqClick:(id)sender {
}

@end
