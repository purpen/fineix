//
//  ModifyGenderViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ModifyGenderViewController.h"
#import "UserInfoEntity.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"

@interface ModifyGenderViewController ()<FBNavigationBarItemsDelegate,FBRequestDelegate>

{
    NSNumber *_sex;
}

@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (weak, nonatomic) IBOutlet UIButton *secretBtn;

@end

static NSString *const UpdateInfoURL = @"/my/update_profile";

@implementation ModifyGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    _sex = entity.sex;
    switch ([_sex intValue]) {
        case 0:
            self.secretBtn.selected = YES;
            break;
        case 1:
            self.manBtn.selected = YES;
            break;
        case 2:
            self.womenBtn.selected = YES;
            break;
            
        default:
            break;
    }
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"修改性别";
    [self addBarItemLeftBarButton:nil image:@"icon_back" isTransparent:NO];
    [self.manBtn addTarget:self action:@selector(clickManBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.womenBtn addTarget:self action:@selector(clickwoMneBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickManBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
    self.womenBtn.selected = NO;
    self.secretBtn.selected = NO;
    _sex = @1;
}

-(void)clickwoMneBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
    self.manBtn.selected = NO;
    self.secretBtn.selected = NO;
    _sex = @2;
}
- (IBAction)clickSecretBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.manBtn.selected = NO;
    self.womenBtn.selected = NO;
    _sex = @0;
}



-(void)leftBarItemSelected{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if ([_sex intValue] != [entity.sex intValue]) {
        //进行更新
        FBRequest *request = [FBAPI postWithUrlString:UpdateInfoURL requestDictionary:@{@"sex":_sex} delegate:self];
        [request startRequest];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    NSString *message = [result objectForKey:@"message"];
    if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        entity.sex = _sex;
        [entity updateUserInfo];
        [SVProgressHUD showSuccessWithStatus:message];
        request = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:message];
        request = nil;
        [self.navigationController popViewControllerAnimated:YES];
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
