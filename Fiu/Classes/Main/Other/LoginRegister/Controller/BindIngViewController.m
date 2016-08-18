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
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "THNInformationViewController.h"

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
    
    [self.phoneNumTF setValue:[UIColor lightGrayColor] forKeyPath:XMGPlacerholderColorKeyPath];
    self.phoneNumTF.tintColor = [UIColor lightGrayColor];
    [self.pwdTF setValue:[UIColor lightGrayColor] forKeyPath:XMGPlacerholderColorKeyPath];
    self.pwdTF.tintColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)cancelBtn:(UIButton *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginBtn:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    //发送请求来存储用户信息
    NSDictionary *params;
    if ([self.type isEqualToNumber:@1]) {
        //如果是微信需要snsAccount.unionId
        params = @{
                   @"third_source":self.type,
                   @"oid":self.snsAccount.usid,
                   @"union_id":self.snsAccount.unionId,
                   @"access_token":self.snsAccount.accessToken,
                   @"nickname":self.snsAccount.userName,
                   @"avatar_url":self.snsAccount.iconURL,
                   @"from_to":@1
                   };
        
    }
    //如果不是微信不需要snsAccount.unionId
    else{
        params = @{
                   @"third_source":self.type,
                   @"oid":self.snsAccount.usid,
                   //@"union_id":snsAccount.unionId,
                   @"access_token":self.snsAccount.accessToken,
                   @"nickname":self.snsAccount.userName,
                   @"avatar_url":self.snsAccount.iconURL,
                   @"from_to":@1
                   };
        
    }
    FBRequest *request = [FBAPI postWithUrlString:thirdRegisteredNotBinding requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        //如果请求成功，并获取用户信息来更新当前用户信息
        NSDictionary *dataDic = [result objectForKey:@"data"];
        UserInfo *info = [UserInfo mj_objectWithKeyValues:dataDic];
        [info saveOrUpdate];
        [info updateUserInfoEntity];
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        entity.isLogin = YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
