//
//  EditNickNameViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "EditNickNameViewController.h"
#import "THNUserData.h"
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
    //self.navigationController.navigationBarHidden = NO;
    self.navViewTitle.text = NSLocalizedString(@"ModifyNickname", nil);
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    [self addBarItemRightBarButton:NSLocalizedString(@"save", nil) image:@"" isTransparent:NO];
    
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    self.nickNameTF.text = userdata.nickname;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    if (![self.nickNameTF.text isEqualToString:userdata.nickname]) {
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
    NSString *message = [result objectForKey:@"message"];
    if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
        THNUserData *userdata = [[THNUserData findAll] lastObject];
        userdata.nickname = [[result objectForKey:@"data"] objectForKey:@"nickname"];
        userdata.trueNickname = [[result objectForKey:@"data"] objectForKey:@"true_nickname"];
        [SVProgressHUD showSuccessWithStatus:message];
        [userdata saveOrUpdate];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:message];
    }
    
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
