//
//  ChangeSumaryViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChangeSumaryViewController.h"
#import "SVProgressHUD.h"
#import "FBAPI.h"
#import "UserInfoEntity.h"

@interface ChangeSumaryViewController ()<FBNavigationBarItemsDelegate,FBRequestDelegate>
@property (weak, nonatomic) IBOutlet UITextView *sumaryTFV;

@end

static NSString *const UpdateInfoURL = @"/my/update_profile";

@implementation ChangeSumaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    //self.navigationController.navigationBarHidden = NO;
    self.navViewTitle.text = @"个性签名";
    [self addBarItemRightBarButton:@"完成" image:nil isTransparent:NO];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    self.sumaryTFV.text = entity.summary;
    self.sumaryTFV.layoutManager.allowsNonContiguousLayout = NO;
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    NSLog(@"完成");
    if (self.sumaryTFV.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"编辑内容为空"];
    }else if (self.sumaryTFV.text.length > 30) {
        [SVProgressHUD showErrorWithStatus:@"编辑内容过长"];
    }else{
        //推送
        FBRequest *request = [FBAPI postWithUrlString:UpdateInfoURL requestDictionary:@{@"summary":self.sumaryTFV.text} delegate:self];
        [request startRequest];
    }
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    NSString *message = [result objectForKey:@"message"];
    if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        entity.summary = self.sumaryTFV.text;
        [entity updateUserInfo];
        [SVProgressHUD showSuccessWithStatus:message];
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
