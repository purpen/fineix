//
//  ImprovViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ImprovViewController.h"
#import "Fiu.h"
#import "ImproView.h"
#import "UIImage+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"
#import "UserInfoEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Helper.h"
#import "FBTabBarController.h"

@interface ImprovViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,FBRequestDelegate>

{
    NSString *_sex;
}
@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;

@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (weak, nonatomic) IBOutlet UIButton *secretBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *sumaryTF;
@property (weak, nonatomic) IBOutlet UIView *manView;
@property (weak, nonatomic) IBOutlet UIView *womenView;
@property (weak, nonatomic) IBOutlet UIView *secretView;
@end

static NSString *const modifyUserInformation = @"/my/update_profile";
static NSString *const IconURL = @"/my/upload_token";

@implementation ImprovViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = @"完善个人资料";
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 105*0.5;
    _sex = @"男";
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl]];
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    singleRecognizer.numberOfTouchesRequired = 1;
    [self.headImageView addGestureRecognizer:singleRecognizer];
    [self.manBtn addTarget:self action:@selector(clickMenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.womenBtn addTarget:self action:@selector(clickWomenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.secretBtn addTarget:self action:@selector(clickSecretBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    self.nickNameTF.delegate = self;
    self.sumaryTF.delegate = self;
    
    self.manView.hidden = NO;
    self.womenView.hidden = YES;
    self.secretView.hidden = YES;
    
    //点击头像可以更换头像
    self.headImageView.userInteractionEnabled = YES;
    
}

-(void)singleTap:(UITapGestureRecognizer*)recognizer{
    
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

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//
//{
//    
//    CGRect frame = textField.frame;
//    
//    int offset = frame.origin.y + 70 - (self.view.frame.size.height - 216.0);//iPhone键盘高度216，iPad的为352
//    
//    
//    
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    
//    [UIView setAnimationDuration:0.5f];
//    
//    
//    
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    
//    if(offset > 0){
//        CGRect frame = self.view.frame;
//        frame.origin.y -= offset;
//        self.view.frame = frame;
//        [UIView commitAnimations];
//    }
//}

//输入框编辑完成以后，将视图恢复到原始状态
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//
//{
//    
//    CGRect frame = textField.frame;
//    
//    int offset = frame.origin.y + 70 - (self.view.frame.size.height - 216.0);//iPhone键盘高度216，iPad的为352
//    
//    
//    
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    
//    [UIView setAnimationDuration:0.5f];
//    
//    CGRect frame1 = self.view.frame;
//    frame1.origin.y -= offset;
//    self.view.frame = frame1;
//    [UIView commitAnimations];
//
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nickNameTF resignFirstResponder];
    [self.sumaryTF resignFirstResponder];
}

-(void)clickMenBtn:(UIButton*)sender{
    self.manView.hidden = NO;
    self.womenView.hidden = YES;
    self.secretView.hidden = YES;
    _sex = @"男";
}

-(void)clickWomenBtn:(UIButton*)sender{
    self.manView.hidden = YES;
    self.womenView.hidden = NO;
    self.secretView.hidden = YES;
    _sex = @"女";
}

-(void)clickSecretBtn:(UIButton*)sender{
    self.manView.hidden = YES;
    self.womenView.hidden = YES;
    self.secretView.hidden = NO;
    _sex = @"保密";
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
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:IconURL]) {
        NSString * message = [result objectForKey:@"message"];
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            
            NSString * fileUrl = [[result objectForKey:@"data"] objectForKey:@"file_url"];
            UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
            userEntity.mediumAvatarUrl = fileUrl;
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:fileUrl] placeholderImage:nil];
            
            [SVProgressHUD showSuccessWithStatus:message];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    if ([request.flag isEqualToString:modifyUserInformation]) {
        NSString * message = [result objectForKey:@"message"];
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            //更新用户名，性别，个人简介
            UserInfoEntity *entiey = [UserInfoEntity defaultUserInfoEntity];
            entiey.nickname = [result objectForKey:@"data"][@"nickname"];
            entiey.sex = [result objectForKey:@"data"][@"sex"];
            entiey.summary = [result objectForKey:@"data"][@"summary"];
            [SVProgressHUD showSuccessWithStatus:message];
            //成功后跳转到home页
//            FBTabBarController *tab = [[FBTabBarController alloc] init];
//            [tab setSelectedIndex:3];
//            [self presentViewController:tab animated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.tabBarController setSelectedIndex:3];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
        
    }
}
- (IBAction)clickNextBtn:(UIButton *)sender {
    //开始传送数据
    NSDictionary *params = @{
                             @"nickname":self.nickNameTF.text,
                             @"sex":_sex,
                             @"summary":self.sumaryTF.text
                             };
    FBRequest *request = [FBAPI postWithUrlString:modifyUserInformation requestDictionary:params delegate:self];
    request.flag = modifyUserInformation;
    [request startRequest];
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
