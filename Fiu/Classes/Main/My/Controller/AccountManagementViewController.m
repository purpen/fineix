//
//  AccountManagementViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AccountManagementViewController.h"
#import "AccountView.h"
#import "UIImage+Helper.h"
#import "UserInfoEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "EditNickNameViewController.h"
#import "ModifyGenderViewController.h"
#import "ChangeSumaryViewController.h"

@interface AccountManagementViewController ()<FBNavigationBarItemsDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) AccountView *accountView;

@end

static NSString *const IconURL = @"/my/upload_token";

@implementation AccountManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self addBarItemRightBarButton:@"保存" image:nil];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"保存信息";
    
    self.view = self.accountView;
}

-(AccountView *)accountView{
    if (!_accountView) {
        _accountView = [AccountView getAccountView];
        [_accountView.headBtn addTarget:self action:@selector(clickHeadImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.nickBtn addTarget:self action:@selector(clickNickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.sexBtn addTarget:self action:@selector(clickSexBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.sumBtn addTarget:self action:@selector(clickSumBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accountView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    //更新头像
    [_accountView.iconUrl sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"Circle + User"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _accountView.nickName.text = entity.nickname;
    _accountView.adress.text = entity.address;
    switch ([entity.sex intValue]) {
        case 0:
            _accountView.sex.text = @"保密";
            break;
        case 1:
            _accountView.sex.text = @"男";
            break;
        case 3:
            _accountView.sex.text = @"女";
            break;
            
        default:
            break;
    }
    _accountView.birthday.text = entity.birthday;

}

-(void)clickSumBtn:(UIButton*)sender{
    ChangeSumaryViewController *vc = [[ChangeSumaryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickSexBtn:(UIButton*)sender{
    ModifyGenderViewController *vc = [[ModifyGenderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickNickBtn:(UIButton*)sender{
    EditNickNameViewController *editVC = [[EditNickNameViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

-(void)clickHeadImageBtn:(UIButton*)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机。模拟器没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //调取相机xx
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
            [_accountView.iconUrl sd_setImageWithURL:[NSURL URLWithString:fileUrl] placeholderImage:nil];
            
            [SVProgressHUD showSuccessWithStatus:message];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    NSLog(@"保存");
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
