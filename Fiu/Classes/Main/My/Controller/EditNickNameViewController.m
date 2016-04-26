//
//  EditNickNameViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "EditNickNameViewController.h"
#import "UserInfoEntity.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"

@interface EditNickNameViewController ()<FBNavigationBarItemsDelegate,FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@end

static NSString *const UpdateInfoURL = @"/my/update_profile";

@implementation EditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"修改昵称";
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
//    [self addBarItemRightBarButton:@"保存" image:nil];
    
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    self.nickNameTF.text = entity.nickname;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    NSLog(@"保存");
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if (![self.nickNameTF.text isEqualToString:entity.nickname]) {
        //保存更改的信息
        FBRequest *request = [FBAPI postWithUrlString:UpdateInfoURL requestDictionary:@{@"nickname":self.nickNameTF.text} delegate:self];
        request.flag = UpdateInfoURL;
        [request startRequest];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)requestSucess:(FBRequest *)request result:(id)result{
    NSLog(@"result%@",result);
    NSString *message = [result objectForKey:@"message"];
    if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        entity.nickname = [[result objectForKey:@"data"] objectForKey:@"nickname"];
        entity.trueNickname = [[result objectForKey:@"data"] objectForKey:@"true_nickname"];
        [SVProgressHUD showSuccessWithStatus:message];
    }else{
        [SVProgressHUD showInfoWithStatus:message];
    }
    request = nil;
    [self.navigationController popViewControllerAnimated:YES];
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
