//
//  FBBindingMobilePhoneNumber.m
//  fineix
//
//  Created by THN-Dong on 16/3/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBBindingMobilePhoneNumber.h"
#import "SVProgressHUD.h"
#import "NSString+Helper.h"
#import "Fiu.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"

@interface FBBindingMobilePhoneNumber ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;//密码水印

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录按钮
@property (weak, nonatomic) IBOutlet UILabel *phonNumLabel;//手机号水印
@end
NSString *thirdRegistrationBindingMobilePhone = @"/auth/third_register_with_phone";
@implementation FBBindingMobilePhoneNumber

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //输入手机号
    
    
    
    
    //绑定按钮变圆润
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 3;
    
    
    
}

//点击密码Textfeild
- (IBAction)clickPwdTextFeild:(UIButton *)sender {
    //水印消失
    self.pwdLabel.hidden = YES;
    //判断密码是否为空
    if (self.phoneNumTF.text.length == 0) {
        //如果是空的，水印显示
        self.phonNumLabel.hidden = NO;
    }
    
    //如果不是空的，水印消失
    else{
        self.phonNumLabel.hidden = YES;
    }
    //成为第一响应者
    [self.pwdTF becomeFirstResponder];
}
//点击手机号textfeild
- (IBAction)clickPhoneNumtextFeild:(UIButton *)sender {
    //水印消失
    self.phonNumLabel.hidden = YES;
    //判断密码是否为空
    if (self.pwdTF.text.length == 0) {
        //如果是空的，水印显示
        self.pwdLabel.hidden = NO;
    }
    
    //如果不是空的，水印消失
    else{
        self.pwdLabel.hidden = YES;
    }
    //成为第一响应者
    [self.phoneNumTF becomeFirstResponder];
}

//取消按钮返回首页
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickBindingBtn:(UIButton *)sender {
    //判断手机号格式
    if ([self.phoneNumTF.text checkTel]) {
        //如果手机号格式正确判断密码格式
        if (self.pwdTF.text.length < 6) {
           //如果密码格式错误提示错误信息
            [SVProgressHUD showErrorWithStatus:@"密码不能少于六位"];
        }//如果密码格式正确发送请求
        else{
            //创建传输参数
            //根据是否是微信登录来确定参数里的unionID
            if (self.snsAccount.unionId == nil) {
                self.snsAccount.unionId = @"";
            }
            NSDictionary *params = @{
                                    @"third_source":self.type,
                                    @"oid":self.snsAccount.usid,
                                    @"union_id":self.snsAccount.unionId,
                                    @"access_token":self.snsAccount.accessToken,
                                    @"account":self.phoneNumTF.text,
                                    @"password":self.pwdTF.text,
                                    @"from_to":@1
                                    };
            FBRequest *request = [FBAPI postWithUrlString:thirdRegistrationBindingMobilePhone requestDictionary:params delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                //请求成功，进行用户信息关联
                NSDictionary *dataDic = [result objectForKey:@"data"];
                UserInfo *info = [UserInfo mj_objectWithKeyValues:dataDic];
                [info saveOrUpdate];
                [info updateUserInfoEntity];
                UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
                entity.isLogin = YES;
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            } failure:^(FBRequest *request, NSError *error) {
                //请求失败，提示错误信息
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                
            }];
        }
    }//如果手机号格式错误提示错误信息
    else{
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

