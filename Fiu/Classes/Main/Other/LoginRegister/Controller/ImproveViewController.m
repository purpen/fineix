//
//  ImproveViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ImproveViewController.h"
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

@interface ImproveViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,FBRequestDelegate>
{
    NSString *_sex;
}
@end

static NSString *const modifyUserInformation = @"/my/update_profile";
static NSString *const IconURL = @"/my/upload_token";

@implementation ImproveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"完善个人资料";
    _sex = @"男";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(0);
        make.right.mas_equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(44/667.0*SCREEN_HEIGHT);
    }];
    
    [self.view addSubview:self.improView];
    [_improView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).with.offset(271*0.5*SCREEN_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(564*0.5/667.0*SCREEN_HEIGHT, 621*0.5/667.0*SCREEN_HEIGHT));
    }];
    
    
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

-(ImproView *)improView{
    if (!_improView) {
        _improView = [[ImproView alloc] init];
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        singleRecognizer.numberOfTapsRequired = 1;
        singleRecognizer.numberOfTouchesRequired = 1;
        [_improView.headImageView addGestureRecognizer:singleRecognizer];
        [_improView.manBtn addTarget:self action:@selector(clickMenBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_improView.womanBtn addTarget:self action:@selector(clickWomenBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_improView.secretBtn addTarget:self action:@selector(clickSecretBtn:) forControlEvents:UIControlEventTouchUpInside];
        //
        _improView.nickNameTF.delegate = self;
        _improView.sumTF.delegate = self;
        
        _improView.manBtn.selected = YES;
        
        //点击头像可以更换头像
        _improView.headImageView.userInteractionEnabled = YES;
    }
    return _improView;
}

-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setBackgroundColor:[UIColor colorWithHexString:fineixColor]];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.text = @"选好了，开始Fineix之旅";
        [_nextBtn addTarget:self action:@selector(clickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    CGRect frame = textField.frame;
    
    int offset = frame.origin.y + 70 - (self.view.frame.size.height - 216.0);//iPhone键盘高度216，iPad的为352
    
    
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:0.5f];
    
    
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    
    if(offset > 0){
        
        [_improView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(self.view.mas_top).with.offset(271*0.5*SCREEN_HEIGHT-offset);
            make.size.mas_equalTo(CGSizeMake(564*0.5/667.0*SCREEN_HEIGHT, 621*0.5/667.0*SCREEN_HEIGHT));
        }];
        
        [UIView commitAnimations];
    }
}

//输入框编辑完成以后，将视图恢复到原始状态

-(void)textFieldDidEndEditing:(UITextField *)textField

{
    
    [_improView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).with.offset(271*0.5*SCREEN_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(564*0.5/667.0*SCREEN_HEIGHT, 621*0.5/667.0*SCREEN_HEIGHT));
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_improView.nickNameTF resignFirstResponder];
    [_improView.sumTF resignFirstResponder];
}

-(void)clickMenBtn:(UIButton*)sender{
    _improView.manBtn.selected = YES;
    _improView.womanBtn.selected = NO;
    _improView.secretBtn.selected = NO;
    _sex = @"男";
}

-(void)clickWomenBtn:(UIButton*)sender{
    _improView.manBtn.selected = NO;
    _improView.womanBtn.selected = YES;
    _improView.secretBtn.selected = NO;
    _sex = @"女";
}

-(void)clickSecretBtn:(UIButton*)sender{
    _improView.manBtn.selected = NO;
    _improView.womanBtn.selected = NO;
    _improView.secretBtn.selected = YES;
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
            [_improView.headImageView sd_setImageWithURL:[NSURL URLWithString:fileUrl] placeholderImage:nil];
            
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

-(void)clickNextBtn:(UIButton*)sender{
    //开始传送数据
    NSDictionary *params = @{
                             @"nickname":_improView.nickNameTF.text,
                             @"sex":_sex,
                             @"summary":_improView.sumTF.text
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
