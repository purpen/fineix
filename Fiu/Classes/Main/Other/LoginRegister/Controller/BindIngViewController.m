//
//  BindIngViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BindIngViewController.h"
#import "SVProgressHUD.h"
#import "NSString+Helper.h"
#import "Fiu.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "THNInformationViewController.h"
#import "THNUserData.h"

@interface BindIngViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *bingBtn;

@end
NSString *thirdRegistrationBindingMobilePhone = @"/auth/third_register_with_phone";
static NSString *const thirdRegisteredNotBinding = @"/auth/third_register_without_phone";//第三方快捷注册(不绑定手机号)接口
static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation BindIngViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bingBtn.layer.masksToBounds = YES;
    self.bingBtn.layer.cornerRadius = 3;
    
    self.phoneNumTF.delegate = self;
    self.pwdTF.delegate = self;
    
    [self.phoneNumTF setValue:[UIColor colorWithHexString:@"#8B8B8B"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.phoneNumTF.tintColor = [UIColor whiteColor];
    [self.pwdTF setValue:[UIColor colorWithHexString:@"#8B8B8B"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.pwdTF.tintColor = [UIColor whiteColor];
}


- (IBAction)clickBingBtn:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    //判断手机号格式
    if ([self.phoneNumTF.text checkTel]) {
        //如果手机号格式正确判断密码格式
        if (self.pwdTF.text.length < 6) {
            //如果密码格式错误提示错误信息
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"passwordDigits", nil)];
            //NSLocalizedString(@"cropVcTitle", nil)
        }//如果密码格式正确发送请求
        else{
            //创建传输参数
            //根据是否是微信登录来确定参数里的unionID
            if (self.snsAccount.uid == nil) {
                self.snsAccount.uid = @"";
            }
            NSDictionary *params = @{
                                     @"third_source":self.type,
                                     @"oid":self.snsAccount.openid,
                                     @"union_id":self.snsAccount.uid,
                                     @"access_token":self.snsAccount.accessToken,
                                     @"account":self.phoneNumTF.text,
                                     @"password":self.pwdTF.text,
                                     @"from_to":@1
                                     };
            FBRequest *request = [FBAPI postWithUrlString:thirdRegistrationBindingMobilePhone requestDictionary:params delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                //请求成功，进行用户信息关联
                NSDictionary *dataDic = [result objectForKey:@"data"];
                THNUserData *userData = [THNUserData mj_objectWithKeyValues:dataDic];
                userData.isLogin = YES;
                [userData saveOrUpdate];
                
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"loginSuccessful", nil)];
                //推荐感兴趣的情景
                NSDictionary *identifyDict = [dataDic objectForKey:@"identify"];
                if ([[identifyDict objectForKey:@"is_scene_subscribe"] isEqualToNumber:@0]) {
                    //跳转到推荐界面
//                    SubscribeInterestedCollectionViewController *subscribeVC = [[SubscribeInterestedCollectionViewController alloc] init];
                    THNInformationViewController *vc = [[THNInformationViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
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


- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginBtn:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    //发送请求来存储用户信息
    NSDictionary *params;
    if ([self.type isEqualToNumber:@1]) {
        //如果是微信需要snsAccount.unionId
        params = @{
                   @"third_source":self.type,
                   @"oid":self.snsAccount.openid,
                   @"union_id":self.snsAccount.uid,
                   @"access_token":self.snsAccount.accessToken,
                   @"nickname":self.snsAccount.name,
                   @"avatar_url":self.snsAccount.iconurl,
                   @"from_to":@1
                   };
        
    }
    //如果不是微信不需要snsAccount.unionId
    else{
        params = @{
                   @"third_source":self.type,
                   @"oid":self.snsAccount.openid,
                   //@"union_id":snsAccount.unionId,
                   @"access_token":self.snsAccount.accessToken,
                   @"nickname":self.snsAccount.name,
                   @"avatar_url":self.snsAccount.iconurl,
                   @"from_to":@1
                   };
        
    }
    FBRequest *request = [FBAPI postWithUrlString:thirdRegisteredNotBinding requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        //如果请求成功，并获取用户信息来更新当前用户信息
        NSDictionary *dataDic = [result objectForKey:@"data"];
        THNUserData *userData = [THNUserData mj_objectWithKeyValues:dataDic];
        userData.isLogin = YES;
        [userData saveOrUpdate];
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"registeredSuccessfully", nil)];
        NSString *str = dataDic[@"identify"][@"is_scene_subscribe"];
        if ([str integerValue] == 0) {
            THNInformationViewController *vc = [[THNInformationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        } 
    } failure:^(FBRequest *request, NSError *error) {
        //如果请求失败提示失败信息
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];

}


@end
