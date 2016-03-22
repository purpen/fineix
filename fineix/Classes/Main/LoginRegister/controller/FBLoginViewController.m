//
//  FBLoginViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBLoginViewController.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "Fineix.h"
#import "NSString+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#include "UserInfoEntity.h"


@interface FBLoginViewController ()<UITextFieldDelegate,FBRequestDelegate>
@property (nonatomic, assign) BOOL isPopup;//弹出状态
@property (weak, nonatomic) IBOutlet UILabel *thirdPartyTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@property (strong, nonatomic) IBOutlet UITextField *accountField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

NSString *const LoginURL = @"/auth/login";//登录接口

@implementation FBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏未安装的第三方登录平台
//    if (![WXApi isWXAppInstalled] && ![WeiboSDK isWeiboAppInstalled] && ![QQApiInterface isQQInstalled]) {
//        self.thirdPartyTitleLbl.hidden = true;
//    }
//    if ([WXApi isWXAppInstalled] == FALSE) {
//        self.wechatBtn.hidden = true;
//    }
//    if ([WeiboSDK isWeiboAppInstalled] == FALSE) {
//        self.weiboBtn.hidden = true;
//    }
//    if ([QQApiInterface isQQInstalled] == FALSE) {
//        self.qqBtn.hidden = true;
//    }
    //设置按钮显示椭圆
    self.wechatBtn.layer.cornerRadius  = 2;
    self.wechatBtn.layer.masksToBounds = YES;
    self.weiboBtn.layer.cornerRadius  = 2;
    self.weiboBtn.layer.masksToBounds = YES;
    self.qqBtn.layer.cornerRadius  = 2;
    self.qqBtn.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius  = 2;
    self.loginButton.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:true];
}

- (IBAction)clickWeChatBtn:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            //UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
            
            //[self requestDataForThirdPartyLoginWithSnsAccount:snsAccount type:@1];
            
            //得到的数据在回调Block对象形参respone的data属性
                        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *response){
                            NSLog(@"SnsInformation is %@", response.data);
                        }];
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];//错误原因
        }
    });

}

#pragma mark -点击登录按钮
- (IBAction)clickLoginBtn:(UIButton *)sender {
    
    
    
    if (![self.accountField.text checkTel]) {
        //手机号错误提示
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }//密码格式错误提示
    else if(self.passwordField.text.length < 6){
        [SVProgressHUD showErrorWithStatus:@"密码不得少于6位"];
        return;
    }
    //将填写的信息提交服务器
    NSDictionary *params = @{
                             @"mobile":self.accountField.text,
                             @"password":self.passwordField.text,
                             @"from_to":@1
                             };
    FBRequest *request = [FBAPI postWithUrlString:LoginURL requestDictionary:params delegate:self];
    request.flag = LoginURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    
}


#pragma mark -fbrequestDElegate 
-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:LoginURL]) {
        //如果成功，获取到用户的信息
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [userInfo updateUserInfoEntity];
            NSLog(@"%@",userInfo);
            UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
            entity.isLogin = YES;
            [userInfo saveOrUpdate];
            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        }//如果失败，提示用户失败原因
        else{
            NSString *message = result[@"message"];
            [SVProgressHUD showErrorWithStatus:message];
        }
    }
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
