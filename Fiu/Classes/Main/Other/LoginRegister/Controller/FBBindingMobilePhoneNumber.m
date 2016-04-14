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
#import "PhoneNumLoginView.h"

@interface FBBindingMobilePhoneNumber ()<UITextFieldDelegate>
{
    PhoneNumLoginView *_phoneNumLoginV;
}

@end
NSString *thirdRegistrationBindingMobilePhone = @"/auth/third_register_with_phone";
@implementation FBBindingMobilePhoneNumber

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //输入手机号
    
    
    
    
    _phoneNumLoginV = [[PhoneNumLoginView alloc] init];
    CGRect frame = _phoneNumLoginV.frame;
    frame.origin.y = 117.0/667.0*SCREEN_HEIGHT;
    _phoneNumLoginV.frame = frame;
    _phoneNumLoginV.soonBtn.hidden = YES;
    _phoneNumLoginV.forgetBtn.hidden = YES;
    [_phoneNumLoginV.loginBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [_phoneNumLoginV.loginBtn addTarget:self action:@selector(clickBindingBTn:) forControlEvents:UIControlEventTouchUpInside];
    _phoneNumLoginV.phoneTF.delegate = self;
    _phoneNumLoginV.pwdTF.delegate = self;
    
}
//取消按钮
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)clickBindingBTn:(UIButton*)sender{
    //判断手机号格式
    if ([_phoneNumLoginV.phoneTF.text checkTel]) {
        //如果手机号格式正确判断密码格式
        if (_phoneNumLoginV.pwdTF.text.length < 6) {
            //如果密码格式错误提示错误信息
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"passwordDigits", nil)];
            //NSLocalizedString(@"cropVcTitle", nil)
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
                                     @"account":_phoneNumLoginV.phoneTF.text,
                                     @"password":_phoneNumLoginV.pwdTF.text,
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
                
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"loginSuccessful", nil)];
                //推荐感兴趣的情景
                NSDictionary *identifyDict = [dataDic objectForKey:@"identify"];
                if ([[identifyDict objectForKey:@"is_scene_subscribe"] isEqualToNumber:@0]) {
                    //跳转到推荐界面
                }else{
                    //已经订阅过，直接个人中心
                    //跳回个人主页
                    //跳回个人主页
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.tabBarController setSelectedIndex:3];
                    
                }
                
                
            } failure:^(FBRequest *request, NSError *error) {
                //请求失败，提示错误信息
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                
            }];
        }
    }//如果手机号格式错误提示错误信息
    else{
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"phoneNumberNotCorrect", nil)];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

