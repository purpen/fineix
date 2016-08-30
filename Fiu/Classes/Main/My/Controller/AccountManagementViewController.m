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
#import "Fiu.h"
#import "MyQrCodeViewController.h"
#import "UserInfo.h"
#import "DatePickerViewController.h"
#import "AddreesPickerViewController.h"
#import "AddreesModel.h"
#import "OfficialCertificationViewController.h"
#import "SexSheetViewController.h"
#import "AreaModel.h"


@interface AccountManagementViewController ()<FBNavigationBarItemsDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,FBRequestDelegate>
{
    NSMutableArray *_provinceAry;
    NSMutableArray *_cityAry;
    NSNumber *_sex;
}
@property(nonatomic,strong) AccountView *accountView;
@property(nonatomic,strong) DatePickerViewController *pickerVC;
@property(nonatomic,strong) AddreesPickerViewController *addreesPickerVC;
@property(nonatomic,strong) SexSheetViewController *sexPickerVC;

@end

static NSString *const IconURL = @"/my/upload_token";
static NSString *const UpdateInfoURL = @"/my/update_profile";

@implementation AccountManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _provinceAry = [NSMutableArray array];
    _cityAry = [NSMutableArray array];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    _sex = entity.sex;
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.view.backgroundColor = [UIColor lightGrayColor];
    //[self addBarItemRightBarButton:@"保存" image:nil isTransparent:NO];
    self.navViewTitle.text = NSLocalizedString(@"personalInformation", nil);
    [self addBarItemRightBarButton:nil image:@"" isTransparent:NO];
    
    [self.view addSubview:self.accountView];
    [_accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64));
        make.left.mas_equalTo(self.view.mas_left).with.offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(0);
    }];
}

-(AccountView *)accountView{
    if (!_accountView) {
        _accountView = [AccountView getAccountView];
        _accountView.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        [_accountView.headBtn addTarget:self action:@selector(clickHeadImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.nickBtn addTarget:self action:@selector(clickNickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.sexBtn addTarget:self action:@selector(clickSexBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.sumBtn addTarget:self action:@selector(clickSumBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.qrcodeBtn addTarget:self action:@selector(clickQrBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.adreesBtn addTarget:self action:@selector(clickAdreesBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.birthdayBtn addTarget:self action:@selector(clickBirthBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_accountView.certificationBtn addTarget:self action:@selector(clickCertificationBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accountView;
}

-(void)clickCertificationBtn:(UIButton*)sender{
    OfficialCertificationViewController *vc = [[OfficialCertificationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)clickBirthBtn:(UIButton*)sender{
    self.pickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_pickerVC animated:NO completion:^{
        
    }];
    [_pickerVC.pickerBtn addTarget:self action:@selector(clickPickerBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(DatePickerViewController *)pickerVC{
    if (!_pickerVC) {
        _pickerVC = [[DatePickerViewController alloc] init];
    }
    return _pickerVC;
}

-(void)clickPickerBtn:(UIButton*)sender{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * birthdayStr = [dateFormatter stringFromDate:self.pickerVC.datePicker.date];
    self.accountView.birthday.text = birthdayStr;
    [self.pickerVC dismissViewControllerAnimated:NO completion:nil];
    
    FBRequest * request = [FBAPI postWithUrlString:UpdateInfoURL requestDictionary:@{@"birthday": birthdayStr} delegate:self];
    request.flag = UpdateInfoURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

}

-(SexSheetViewController *)sexPickerVC{
    if (!_sexPickerVC) {
        _sexPickerVC = [[SexSheetViewController alloc] init];
    }
    return _sexPickerVC;
}

-(AddreesPickerViewController *)addreesPickerVC{
    if (!_addreesPickerVC) {
        _addreesPickerVC = [[AddreesPickerViewController alloc] init];
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        if (entity.city.length != 0 && entity.prin.length != 0) {
            _addreesPickerVC.provinceStr = entity.prin;
            _addreesPickerVC.cityStr = entity.city;
        }
    }
    return _addreesPickerVC;
}

-(void)clickAdreesBtn:(UIButton*)sender{
//    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
//    NSMutableArray *provincesAry = [NSMutableArray array];
//    NSMutableArray *cityAry = [NSMutableArray array];
//    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"areas" ofType:@"plist"];
//    NSArray * areaAry = [NSArray arrayWithContentsOfFile:filePath];
//    for (NSDictionary * provinceDic in areaAry) {
//        AreaModel * province = [[AreaModel alloc] initWithDictionary:provinceDic];
//        [provincesAry addObject:province];
//        NSArray * citiesAry = [provinceDic objectForKey:@"children"];
//        NSMutableArray * cityOfProAry = [NSMutableArray array];
//        for (NSDictionary * cityDic in citiesAry) {
//            AreaModel * city = [[AreaModel alloc] initWithDictionary:cityDic];
//            [cityOfProAry addObject:city];
//        }
//        [cityAry addObject:cityOfProAry];
//    }
//    
//    NSInteger prinTeger = 1;
//    NSInteger cityTeger = 1;
//    for (int i = 0; i < provincesAry.count; i ++) {
//        if ([((AreaModel*)provincesAry[i]).name rangeOfString:entity.prin].location != NSNotFound) {
//            prinTeger = i;
//        }
//    }
//    for (int i = 0; i < cityAry.count; i ++) {
//        for (int j = 0; j < ((NSArray*)cityAry[i]).count; j ++) {
//            if ([((AreaModel*)cityAry[i][j]).name rangeOfString:entity.city].location != NSNotFound) {
//                cityTeger = j;
//            }
//        }
//    }

    self.addreesPickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
   
    [self presentViewController:_addreesPickerVC animated:NO completion:^{
//        [self.addreesPickerVC.addreesBtn selectRow:0 inComponent:0 animated:YES];
//        AreaModel * city = cityAry[1];
//        self.addreesPickerVC.cityId = city.idField;
//        self.addreesPickerVC.cityStr = city.name;
    }];
    [_addreesPickerVC.pickerBtn addTarget:self action:@selector(clickAddreesPickerBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickSexPickerBtn:(UIButton*)sender{
    //进行更新
    FBRequest *request = [FBAPI postWithUrlString:@"/my/update_profile" requestDictionary:@{@"sex":self.sexPickerVC.sexNum} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        entity.sex = self.sexPickerVC.sexNum;
        [entity updateUserInfo];
        request = nil;
        switch ([entity.sex intValue]) {
            case 0:
                _accountView.sex.text = NSLocalizedString(@"secret", nil);
                break;
            case 1:
                _accountView.sex.text = NSLocalizedString(@"men", nil);
                break;
            case 2:
                _accountView.sex.text = NSLocalizedString(@"women", nil);
                break;
                
            default:
                break;
        }
        [self.sexPickerVC dismissViewControllerAnimated:NO completion:nil];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}


-(void)clickAddreesPickerBtn:(UIButton*)sender{
    FBRequest *request = [FBAPI postWithUrlString:@"/my/update_profile" requestDictionary:@{@"province_id":@(self.addreesPickerVC.provinceId),@"district_id":@(self.addreesPickerVC.cityId)} delegate:self];
    request.flag = @"UpdateInfoURL";
    [request startRequest];
    [self.addreesPickerVC dismissViewControllerAnimated:NO completion:nil];
}

-(void)clickQrBtn:(UIButton*)sender{
    MyQrCodeViewController *vc = [[MyQrCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    entity.isLogin = YES;
    //更新头像
    [_accountView.iconUrl sd_setImageWithURL:[NSURL URLWithString:entity.mediumAvatarUrl] placeholderImage:[UIImage imageNamed:@"Circle + User"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _accountView.nickName.text = entity.nickname;
    if (entity.prin) {
        _accountView.adress.text = [NSString stringWithFormat:@"%@ %@",entity.prin,entity.city];
    }
    switch ([entity.sex intValue]) {
        case 0:
            _accountView.sex.text = NSLocalizedString(@"secret", nil);
            break;
        case 1:
            _accountView.sex.text = NSLocalizedString(@"men", nil);
            break;
        case 2:
            _accountView.sex.text = NSLocalizedString(@"women", nil);
            break;
            
        default:
            break;
    }
    _accountView.birthday.text = entity.birthday;
    if (entity.summary.length == 0) {
        _accountView.personalitySignatureLabel.text = [NSString stringWithFormat:@"%@",entity.label];
    }else{
        _accountView.personalitySignatureLabel.text = [NSString stringWithFormat:@"%@ | %@",entity.label,entity.summary];
    }
    FBRequest *request  =[FBAPI postWithUrlString:@"/my/fetch_talent" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSNumber *verifiedNum = [dataDict objectForKey:@"verified"];
        NSString *str;
        str = NSLocalizedString(@"notAudit", nil);
        if ([verifiedNum isEqualToNumber:@1]){
            str = NSLocalizedString(@"refused", nil);
        }else if ([verifiedNum isEqualToNumber:@2]){
            str = entity.expert_label;
        }
        _accountView.IdentityTagsLabel.text = str;
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(void)clickSumBtn:(UIButton*)sender{
    ChangeSumaryViewController *vc = [[ChangeSumaryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickSexBtn:(UIButton*)sender{
    self.sexPickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    _sex = entity.sex;
    [self presentViewController:_sexPickerVC animated:NO completion:^{
        [self.sexPickerVC.sexPickerView selectRow:[_sex intValue] inComponent:0 animated:NO];
        self.sexPickerVC.sexNum = _sex;
    }];
    [_sexPickerVC.backBtn addTarget:self action:@selector(clickSexPickerBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickNickBtn:(UIButton*)sender{
    EditNickNameViewController *editVC = [[EditNickNameViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

-(void)clickHeadImageBtn:(UIButton*)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"replaceHeadPortrait", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机。模拟器没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"takingPictures", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //调取相机xx
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertC addAction:cameraAction];
    }
    UIAlertAction *phontoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"fromAlbumToChoose", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调取相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:phontoAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * editedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:editedImg] , 0.5);
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
            [userEntity updateUserInfo];
            [_accountView.iconUrl sd_setImageWithURL:[NSURL URLWithString:fileUrl] placeholderImage:nil];
            
            [SVProgressHUD showSuccessWithStatus:message];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
        request = nil;
    }
    
    if ([request.flag isEqualToString:UpdateInfoURL]) {
        NSString * message = [result objectForKey:@"message"];
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            //            UserInfo * userInfo = [[UserInfo findAll] lastObject];
            //            userInfo.birthday = self.birthdayLbl.text;
            //            [userInfo update];
            
            UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
            userEntity.birthday = self.accountView.birthday.text;
            [userEntity updateUserInfo];
            [SVProgressHUD showSuccessWithStatus:message];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
        request = nil;
    }
    
    if ([request.flag isEqualToString:@"UpdateInfoURL"]) {
        NSDictionary *dataDict = result[@"data"];
        UserInfoEntity * userEntity = [UserInfoEntity defaultUserInfoEntity];
        NSArray *areasAry = [NSArray arrayWithArray:dataDict[@"areas"]];
        if (areasAry.count) {
            userEntity.prin = areasAry[0];
            userEntity.city = areasAry[1];
        }
        [userEntity updateUserInfo];
        _accountView.adress.text = [NSString stringWithFormat:@"%@ %@",userEntity.prin,userEntity.city];
        request = nil;
    }

}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    
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
