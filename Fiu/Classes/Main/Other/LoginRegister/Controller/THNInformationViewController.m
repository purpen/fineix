//
//  THNInformationViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNInformationViewController.h"
#import "UIColor+Extension.h"
#import "UIView+FSExtension.h"
#import "UserInfoEntity.h"
#import "UIImage+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "THNAgeViewController.h"

@interface THNInformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
/**  */
@property (nonatomic, strong) NSNumber *sexNum;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@end

static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
static NSString *const IconURL = @"/my/upload_token";
static NSString *const modifyUserInformation = @"/my/update_profile";


@implementation THNInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nameTF setValue:[UIColor colorWithHexString:@"#986E10"] forKeyPath:XMGPlacerholderColorKeyPath];
    self.nameTF.tintColor = [UIColor colorWithHexString:@"#986E10"];
    [self.nameTF circle:3];
    self.manBtn.selected = YES;
    self.sexNum = @1;
    
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":entity.userId} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        NSDictionary *dataDict = result[@"data"];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:dataDict[@"medium_avatar_url"]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];

    
    
    self.nameTF.text = entity.nickname;
    
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 45;
    self.nameTF.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}


- (IBAction)head:(id)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机。模拟器没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //调取相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertC addAction:cameraAction];
    }
    UIAlertAction *phontoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调取相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:phontoAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * editedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:editedImg] , 0.5);
    //        NSData * iconData = UIImageJPEGRepresentation(editedImg , 0.5);
    [self uploadIconWithData:iconData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//上传头像
- (void)uploadIconWithData:(NSData *)iconData
{
    NSString * icon64Str = [iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary * params = @{@"type": @3, @"tmp": icon64Str};
    FBRequest * request = [FBAPI postWithUrlString:IconURL requestDictionary:params delegate:self];
    request.flag = IconURL;
    [request startRequest];
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:IconURL]) {
        NSString * message = [result objectForKey:@"message"];
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            
            NSString * fileUrl = [[result objectForKey:@"data"] objectForKey:@"file_url"];
            UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
            userEntity.mediumAvatarUrl = fileUrl;
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:fileUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
            
            [SVProgressHUD showSuccessWithStatus:message];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
}


- (IBAction)men:(UIButton*)sender {
    for (UIButton *btn in self.sexView.subviews) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.sexNum = @1;
}
- (IBAction)women:(UIButton*)sender {
    for (UIButton *btn in self.sexView.subviews) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.sexNum = @2;
}
- (IBAction)secret:(UIButton*)sender {
    for (UIButton *btn in self.sexView.subviews) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.sexNum = @0;
}
- (IBAction)next:(id)sender {

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    //开始传送数据
    NSDictionary *params = @{
                             @"nickname":self.nameTF.text,
                             @"sex":_sexNum,
                             };
    FBRequest *request = [FBAPI postWithUrlString:modifyUserInformation requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD dismiss];
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            //更新用户名，性别，个人简介
            UserInfoEntity *entiey = [UserInfoEntity defaultUserInfoEntity];
            entiey.nickname = [result objectForKey:@"data"][@"nickname"];
            entiey.sex = [result objectForKey:@"data"][@"sex"];
            THNAgeViewController *vc = [[THNAgeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];

}

@end
