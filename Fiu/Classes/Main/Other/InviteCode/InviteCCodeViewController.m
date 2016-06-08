//
//  InviteCCodeViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/6/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "InviteCCodeViewController.h"
#import "FBTabBarController.h"
#import "AppDelegate.h"
#import "CounterModel.h"
#import "UITabBar+badge.h"
#import "GuidePageViewController.h"
#import "SVProgressHUD.h"

@interface InviteCCodeViewController ()<UITextFieldDelegate>
{
    CounterModel *_counterModel;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@end

@implementation InviteCCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    
    self.okBtn.layer.masksToBounds = YES;
    self.okBtn.layer.cornerRadius = 3;
    
    self.inviteCodeTF.delegate = self;
    //输入验证码后，1成功,并且下一步
    
    
    //2,失败
    
}
- (IBAction)clickOkBtn:(UIButton *)sender {
    if (self.inviteCodeTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"邀请码为空"];
    }else{
        FBRequest *request = [FBAPI postWithUrlString:@"/gateway/valide_invite_code" requestDictionary:@{
                                                                                                         @"code":self.inviteCodeTF.text
                                                                                                         } delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            
            FBRequest *backRequst = [FBAPI postWithUrlString:@"/gateway/del_invite_code" requestDictionary:@{
                                                                                                             @"code":self.inviteCodeTF.text
                                                                                                             } delegate:self];
            
            [backRequst startRequestSuccess:^(FBRequest *request, id result) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"codeFlag"];
                NSArray *arr = [NSArray arrayWithObjects:@"Guide_one",@"Guide_two",@"Guide_three",@"Guide_four", nil];
                AppDelegate *appli = (AppDelegate*)[UIApplication sharedApplication].delegate;
                //    使用的时候用key+版本号替换UserHasGuideView
                //    这样容易控制每个版本都可以显示引导图
                BOOL userIsFirstInstalled = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserHasGuideView"];
                if (userIsFirstInstalled) {
                    FBTabBarController * tabBarC = [[FBTabBarController alloc] init];
                    appli.window.rootViewController = tabBarC;
                    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
                    FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":entity.userId} delegate:self];
                    [request startRequestSuccess:^(FBRequest *request, id result) {
                        NSDictionary *dataDict = result[@"data"];
                        NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
                        _counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
                        //判断小圆点是否消失
                        if (![_counterModel.message_total_count isEqual:@0]) {
                            [tabBarC.tabBar showBadgeWithIndex:4];
                        }else{
                            [tabBarC.tabBar hideBadgeWithIndex:4];
                        }
                    } failure:^(FBRequest *request, NSError *error) {
                    }];
                }else{
                    appli.window.rootViewController = [[GuidePageViewController alloc] initWithPicArr:arr andRootVC:[[FBTabBarController alloc] init]];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserHasGuideView"];
                }
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
            
            } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.inviteCodeTF resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
