//
//  THNLoginViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNLoginViewController.h"
#import "NSString+Helper.h"
#import "SVProgressHUD.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "THNInformationViewController.h"
#import "THNForgetViewController.h"
#import "UIColor+Extension.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "THNBingViewController.h"
#import "THNRedEnvelopeView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "THNUserData.h"

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnTopSpace;
@end

static NSString *const LoginURL = @"/auth/login";//登录接口
static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
static NSString *const thirdRegister = @"/auth/third_sign";//第三方登录接口


@implementation THNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (Is_iPhoneX) {
        self.backBtnTopSpace.constant += 24;
    }
    
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
        THNUserData *userData = [THNUserData mj_objectWithKeyValues:[result objectForKey:@"data"]];
        userData.isLogin = YES;
        [userData saveOrUpdate];
        //跳回个人主页
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        NSDictionary *dataDic = result[@"data"];
        NSString *str = dataDic[@"identify"][@"is_scene_subscribe"];
        if ([str integerValue] == 0) {
            THNInformationViewController *vc = [[THNInformationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                if (userData.is_bonus == 1) {
                    THNRedEnvelopeView *alartView = [[THNRedEnvelopeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    [alartView thn_showRedEnvelopeViewOnWindowWithText:NSLocalizedString(@"SendOldRed", nil)];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSceneData" object:nil];
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
    [self thn_chooseUmengLogin:(UMSocialPlatformType_WechatSession) type:@1];
}

- (IBAction)sina:(id)sender {
    //微博登录
    [self thn_chooseUmengLogin:(UMSocialPlatformType_Sina) type:@2];
}

- (IBAction)qq:(id)sender {
    //QQ登录
    [self thn_chooseUmengLogin:(UMSocialPlatformType_QQ) type:@3];
}

#pragma mark - 选择第三方的类型
- (void)thn_chooseUmengLogin:(UMSocialPlatformType)platformType type:(NSNumber *)type {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];//错误原因
        } else {
            [self afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:resp type:type];
        }
    }];
}

#pragma mark -第三方登录成功后取到用户信息
-(void)afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:(UMSocialUserInfoResponse *)snsAccount type:(NSNumber *)type{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSDictionary *params = @{
                             @"oid":snsAccount.uid,
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
            THNUserData *userData = [THNUserData mj_objectWithKeyValues:[result objectForKey:@"data"]];
            userData.isLogin = YES;
            [userData saveOrUpdate];
            
            NSString *str = dataDic[@"user"][@"identify"][@"is_scene_subscribe"];
            if ([str integerValue] == 0){
                //完善个人信息
                THNInformationViewController *vc = [[THNInformationViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [self dismissViewControllerAnimated:YES completion:^{
                    if (userData.is_bonus == 1) {
                        THNRedEnvelopeView *alartView = [[THNRedEnvelopeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                        [alartView thn_showRedEnvelopeViewOnWindowWithText:NSLocalizedString(@"SendOldRed", nil)];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSceneData" object:nil];
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

-(void)circle:(UIView*)sender{
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 3;
}

@end
