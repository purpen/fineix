//
//  THNBingViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNBingViewController.h"
#import "SVProgressHUD.h"
#import "NSString+Helper.h"
#import "Fiu.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "THNInformationViewController.h"
#import "BindIngViewController.h"
#import "THNRedEnvelopeView.h"

@interface THNBingViewController ()

@end

static NSString *const thirdRegisteredNotBinding = @"/auth/third_register_without_phone";//第三方快捷注册(不绑定手机号)接口

@implementation THNBingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)login:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    //发送请求来存储用户信息
    NSDictionary *params;
    if ([self.type isEqualToNumber:@1]) {
        //如果是微信需要snsAccount.unionId
        params = @{
                   @"third_source":self.type,
                   @"oid":self.snsAccount.uid,
                   @"union_id":self.snsAccount.openid,
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
                   @"oid":self.snsAccount.uid,
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
            [self dismissViewControllerAnimated:YES completion:^{
                if (entity.is_bonus == 1) {
                    THNRedEnvelopeView *alartView = [[THNRedEnvelopeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    [alartView thn_showRedEnvelopeViewOnWindowWithText:NSLocalizedString(@"SendOldRed", nil)];
                }
            }];
        }
    } failure:^(FBRequest *request, NSError *error) {
        //如果请求失败提示失败信息
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)bing:(id)sender {
    BindIngViewController *vc = [[BindIngViewController alloc] init];
    vc.type = self.type;
    vc.snsAccount = self.snsAccount;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
