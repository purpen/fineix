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
#import "Fineix.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"

@interface FBBindingMobilePhoneNumber ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@end
NSString *thirdRegistrationBindingMobilePhone = @"/auth/third_register_with_phone";
@implementation FBBindingMobilePhoneNumber

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //输入手机号
    
    
    
    
    
    
    
    
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

