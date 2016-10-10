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
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "THNBingViewController.h"
#import "THNRedEnvelopeView.h"

@interface THNLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIView *seeView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/**  */
@property (nonatomic, strong) UIView *left;
/**  */
@property (nonatomic, strong) UIView *left2;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@end

NSString *const LoginURL = @"/auth/login";//登录接口
static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
static NSString *const thirdRegister = @"/auth/third_sign";//第三方登录接口


@implementation THNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self circle:self.pwdTF];
    [self circle:self.phoneTF];
    [self circle:self.seeView];
    [self circle:self.loginBtn];
    
    [self.phoneTF setValue:[UIColor colorWithHexString:@"#8B8B8B"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.phoneTF.tintColor = [UIColor whiteColor];
    self.phoneTF.leftView = self.left;
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;

    [self.pwdTF setValue:[UIColor colorWithHexString:@"#8B8B8B"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.pwdTF.tintColor = [UIColor whiteColor];
    self.pwdTF.leftView = self.left2;
    self.pwdTF.leftViewMode = UITextFieldViewModeAlways;
    
    //判断手机是否安装了相应的客户端
    [self judge];
}

#pragma mark -判断手机是否安装了相应的客户端
-(void)judge{
    //隐藏未安装的第三方登录平台
    if (![WXApi isWXAppInstalled] && ![WeiboSDK isWeiboAppInstalled] && ![QQApiInterface isQQInstalled]) {
        self.thirdView.hidden = true;
    }
    if ([WXApi isWXAppInstalled] == FALSE) {
        self.wechatBtn.hidden = true;
    }
    if ([WeiboSDK isWeiboAppInstalled] == FALSE) {
        self.sinaBtn.hidden = true;
    }
    if ([QQApiInterface isQQInstalled] == FALSE) {
        self.qqBtn.hidden = true;
    }
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

- (IBAction)lock:(UIButton*)sender {
    sender.selected = !sender.selected;
    self.pwdTF.secureTextEntry = !sender.selected;
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
            [self dismissViewControllerAnimated:YES completion:^{
                if (entity.is_bonus == 1) {
                    THNRedEnvelopeView *alartView = [[THNRedEnvelopeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    [alartView thn_showRedEnvelopeViewOnWindowWithText:NSLocalizedString(@"SendOldRed", nil)];
                }
            }];
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)forget:(id)sender {
    THNForgetViewController *vc = [[THNForgetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)wechat:(id)sender {
    //微信登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        if (response.responseCode == UMSResponseCodeSuccess) {
            //如果微信登录成功，取到用户信息
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@1];
        }else {
            [SVProgressHUD showErrorWithStatus:response.message];//错误原因
        }
    });
}

#pragma mark -第三方登录成功后取到用户信息
-(void)afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:(UMSocialAccountEntity *)snsAccount type:(NSNumber *)type{
    NSString *oid;
    if ([type isEqualToNumber:@1]) {
        oid = snsAccount.unionId;
    }else{
        oid = snsAccount.usid;
    }
    NSDictionary *params = @{
                             @"oid":oid,
                             @"access_token":snsAccount.accessToken,
                             @"type":type,
                             @"from_to":@1
                             };
    FBRequest *request = [FBAPI postWithUrlString:thirdRegister requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        //如果请求成功
        [SVProgressHUD dismiss];
        NSDictionary *dataDic = [result objectForKey:@"data"];
        if ([[dataDic objectForKey:@"has_user"] isEqualToNumber:@1]){
            //用户存在，更新当前用户的信息
            UserInfo *userinfo = [UserInfo mj_objectWithKeyValues:[dataDic objectForKey:@"user"]];
            [userinfo saveOrUpdate];
            [userinfo updateUserInfoEntity];
            
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            NSString *str = dataDic[@"user"][@"identify"][@"is_scene_subscribe"];
            if ([str integerValue] == 0){
                //完善个人信息
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
        }else{
            
            //跳转到绑定手机号界面
            THNBingViewController *bing = [[THNBingViewController alloc] init];
            bing.snsAccount = snsAccount;
            bing.type = type;
            [self.navigationController pushViewController:bing animated:YES];
            //如果用户不存在,提示用户是否进行绑定
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


- (IBAction)sina:(id)sender {
    //微博登录
    
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            //如果微博登录成功，取到用户信息
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@2];
            
            //得到的数据在回调Block对象形参respone的data属性
            //                        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *response){
            //                            NSLog(@"SnsInformation is %@", response.data);
            //                        }];
        } else {//如果微博登录失败，提示错误信息
            [SVProgressHUD showErrorWithStatus:response.message];//错误原因
        }
    });
}

- (IBAction)qq:(id)sender {
    //QQ登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        if (response.responseCode == UMSResponseCodeSuccess) {
            //如果QQ登录成功，取到用户信息
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:snsAccount type:@3];
            
            //得到的数据在回调Block对象形参respone的data属性
            //                        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *response){
            //                            NSLog(@"SnsInformation is %@", response.data);
            //                        }];
        } else {//如果QQ登录失败，提示错误信息
            [SVProgressHUD showErrorWithStatus:response.message];//错误原因
        }
    });
}

-(void)circle:(UIView*)sender{
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 3;
}

@end
