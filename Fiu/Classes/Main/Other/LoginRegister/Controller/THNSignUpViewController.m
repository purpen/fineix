//
//  THNSignUpViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSignUpViewController.h"
#import "THNTFView.h"
#import <Masonry.h>
#import "NSString+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"
#import "THNInputCodeViewController.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "UserInfo.h"
#import "UserInfoEntity.h"
#import "THNInformationViewController.h"
#import "BindIngViewController.h"

@interface THNSignUpViewController ()<UITextFieldDelegate,FBRequestDelegate>

/**  */
@property (nonatomic, strong) NSMutableArray *textAry;
/**  */
@property (nonatomic, strong) UIButton *sendBtn;
/**  */
@property (nonatomic, strong) THNTFView *tFView;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *thirdTipBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@end

static NSString *const VerifyCodeURL = @"/auth/verify_code";//发送验证码借口
static NSString *const thirdRegister = @"/auth/third_sign";//第三方登录接口


@implementation THNSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tFView];
    [self.tFView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(200);
    }];
    
    [self.view addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.top.mas_equalTo(self.tFView.mas_bottom).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
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

-(THNTFView *)tFView{
    if (!_tFView) {
        _tFView = [[THNTFView alloc] init];
        _tFView.elementCount = 11;
    }
    return _tFView;
}
- (IBAction)sina:(id)sender {
    //微博登录
    
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        
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

#pragma mark -第三方登录成功后取到用户信息
-(void)afterTheSuccessOfTheThirdPartyToRegisterToGetUserInformation:(UMSocialAccountEntity *)snsAccount type:(NSNumber *)type{
    UMSocialConfig *h = [[UMSocialConfig alloc] init];
    h.hiddenLoadingHUD = YES;
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
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            [SVProgressHUD dismiss];

            BindIngViewController *bing = [[BindIngViewController alloc] init];
            bing.snsAccount = snsAccount;
            bing.type = type;
            [self.navigationController pushViewController:bing animated:YES];
            //如果用户不存在,提示用户是否进行绑定
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
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

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = [UIColor blackColor];
        [_sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn setTitleColor:[UIColor colorWithRed:148/255.0 green:107/255.0 blue:16/255.0 alpha:1.0] forState:UIControlStateNormal];
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 3;
        [_sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

-(void)sendClick{
    if ([self.tFView.textField.text checkTel]){
        FBRequest *request1 = [FBAPI postWithUrlString:@"/auth/check_account" requestDictionary:@{@"account":self.tFView.textField.text} delegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [request1 startRequestSuccess:^(FBRequest *request, id result) {
            if ([result objectForKey:@"success"]) {
                //如果手机号正确，发送短信
                NSDictionary *params = @{
                                         @"mobile":self.tFView.textField.text
                                         };
                FBRequest *request = [FBAPI postWithUrlString:VerifyCodeURL requestDictionary:params delegate:self];
                request.flag = VerifyCodeURL;
                [request startRequest];
            }else{
                [SVProgressHUD showWithStatus:[result objectForKey:@"message"]];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号不正确"];
    }
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    //发送验证码请求
    if ([request.flag isEqualToString:VerifyCodeURL]){
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD dismiss];
            THNInputCodeViewController *vc = [[THNInputCodeViewController alloc] init];
            vc.phoneString = self.tFView.textField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            NSString * message = result[@"message"];
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
}
- (IBAction)weichat:(id)sender {
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

- (IBAction)backclick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
