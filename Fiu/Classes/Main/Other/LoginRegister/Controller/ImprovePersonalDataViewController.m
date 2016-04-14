//
//  ImprovePersonalDataViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ImprovePersonalDataViewController.h"
#import "ImprovePersonalInformationView.h"
#import "UIImage+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"
#import "UserInfoEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Helper.h"
#import "Fiu.h"
#import "FBTabBarController.h"

@interface ImprovePersonalDataViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,FBRequestDelegate>
{
    NSString *_sex;
    ImprovePersonalInformationView *_improvePersonalV;
    
}

@end

static NSString *const modifyUserInformation = @"/my/update_profile";
static NSString *const IconURL = @"/my/upload_token";

@implementation ImprovePersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _improvePersonalV = [ImprovePersonalInformationView getImprovePersonalInformationView];
    _improvePersonalV.frame = CGRectMake(0, 64+30, _improvePersonalV.frame.size.width/667.0*SCREEN_HEIGHT, _improvePersonalV.frame.size.height/667.0*SCREEN_HEIGHT);
    CGPoint center = _improvePersonalV.center;
    center.x = self.view.center.x;
    _improvePersonalV.center = center;
    [self.view addSubview:_improvePersonalV];
    //
    [_improvePersonalV.menBtn addTarget:self action:@selector(clickMenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_improvePersonalV.womenBtn addTarget:self action:@selector(clickWomenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_improvePersonalV.secretBtn addTarget:self action:@selector(clickSecretBtn:) forControlEvents:UIControlEventTouchUpInside];
    //
    _improvePersonalV.nickNameTF.delegate = self;
    _improvePersonalV.IndividualitySignatureTF.delegate = self;
    //
    self.navigationItem.title = @"完善个人资料";
    _improvePersonalV.womenView.hidden = YES;
    _improvePersonalV.secretView.hidden = YES;
    _sex = @"男";
    //头像变成椭圆
    _improvePersonalV.headImageView.layer.masksToBounds = YES;
    _improvePersonalV.headImageView.layer.cornerRadius = 50;
    //点击头像可以更换头像
    _improvePersonalV.headImageView.userInteractionEnabled = YES;
    _improvePersonalV.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    singleRecognizer.numberOfTouchesRequired = 1;
    [_improvePersonalV.headImageView addGestureRecognizer:singleRecognizer];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    CGRect frame = textField.frame;
    
    int offset = frame.origin.y + 70 - (self.view.frame.size.height - 216.0);//iPhone键盘高度216，iPad的为352
    
    
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:0.5f];
    
    
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    
    if(offset > 0)
        
        _improvePersonalV.frame = CGRectMake(0, 64+30-offset, _improvePersonalV.frame.size.width, _improvePersonalV.frame.size.height);
        
    CGPoint center = _improvePersonalV.center;
    center.x = self.view.center.x;
    _improvePersonalV.center = center;
    [UIView commitAnimations];
    
}

//输入框编辑完成以后，将视图恢复到原始状态

-(void)textFieldDidEndEditing:(UITextField *)textField

{
    
    _improvePersonalV.frame = CGRectMake(0, 64+30, _improvePersonalV.frame.size.width, _improvePersonalV.frame.size.height);
    CGPoint center = _improvePersonalV.center;
    center.x = self.view.center.x;
    _improvePersonalV.center = center;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_improvePersonalV.nickNameTF resignFirstResponder];
    [_improvePersonalV.IndividualitySignatureTF resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBarHidden = NO;
}

-(void)clickMenBtn:(UIButton*)sender{
    _improvePersonalV.manView.hidden = NO;
    _improvePersonalV.womenView.hidden = YES;
    _improvePersonalV.secretView.hidden = YES;
    _sex = @"男";
}

-(void)clickWomenBtn:(UIButton*)sender{
    _improvePersonalV.womenView.hidden = NO;
    _improvePersonalV.manView.hidden = YES;
    _improvePersonalV.secretView.hidden = YES;
    _sex = @"女";
}

-(void)clickSecretBtn:(UIButton*)sender{
    _improvePersonalV.secretView.hidden = NO;
    _improvePersonalV.manView.hidden = YES;
    _improvePersonalV.womenView.hidden = YES;
    _sex = @"保密";
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
        [self dismissViewControllerAnimated:YES completion:nil];
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
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:IconURL]) {
        NSString * message = [result objectForKey:@"message"];
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            
            NSString * fileUrl = [[result objectForKey:@"data"] objectForKey:@"file_url"];
            UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
            userEntity.mediumAvatarUrl = fileUrl;
            [_improvePersonalV.headImageView sd_setImageWithURL:[NSURL URLWithString:fileUrl] placeholderImage:nil];
            
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
            FBTabBarController *tab = [[FBTabBarController alloc] init];
            [tab setSelectedIndex:0];
            [self presentViewController:tab animated:YES completion:nil];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }

    }
}

//#pragma mark -保存图片到沙盒
//-(void)saveImage:(UIImage*)currentImage withName:(NSString*)imageName{
//    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1);
//    //获取沙盒路径
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//    //讲图片写入文件
//    [imageData writeToFile:fullPath atomically:NO];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chosenBtn:(UIButton *)sender {
    //开始传送数据
    NSDictionary *params = @{
                             @"nickname":_improvePersonalV.nickNameTF.text,
                             @"sex":_sex,
                             @"summary":_improvePersonalV.IndividualitySignatureTF.text
                             };
    FBRequest *request = [FBAPI postWithUrlString:modifyUserInformation requestDictionary:params delegate:self];
    request.flag = modifyUserInformation;
    [request startRequest];
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
