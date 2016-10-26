//
//  EditAddressViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "EditAddressViewController.h"
#import "DeliveryAddressModel.h"
#import "TYAlertView.h"
#import "UIView+TYAlertView.h"
#import "SVProgressHUD.h"
#import "NSString+Helper.h"
#import "AddreesPickerViewController.h"
#import "THNChooseCityViewController.h"

@interface EditAddressViewController ()<FBNavigationBarItemsDelegate,UITextFieldDelegate> {
    NSString *_provinceId;
    NSString *_cityId;
    NSString *_countyId;
    NSString *_townId;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *zipTF;
@property (weak, nonatomic) IBOutlet UITextField *detailsAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UISwitch *addressSwicth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceing;

@property (nonatomic, strong) NSMutableArray * provinceAry;
@property (nonatomic, strong) NSMutableArray * cityAry;
@property (nonatomic, assign) NSInteger provinceRow;

@end

static NSString *const EditAddressURL = @"/delivery_address/save";
static NSString *const DeleteAddressURL = @"/delivery_address/deleted";
static NSString * const FSPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    [self changePlaceHolderColor:self.nameTF];
    [self changePlaceHolderColor:self.phoneNumTF];
    [self changePlaceHolderColor:self.addressTF];
    [self changePlaceHolderColor:self.detailsAddressTF];
    [self changePlaceHolderColor:self.zipTF];
    
    if (self.deliveryAddress) {
        self.navViewTitle.text = @"编辑收货地址";
        [self addBarItemRightBarButton:@"删除" image:nil isTransparent:NO];
        self.nameTF.text = self.deliveryAddress.name;
        self.phoneNumTF.text = self.deliveryAddress.phone;
        self.zipTF.text = self.deliveryAddress.zip;
        self.addressTF.hidden = NO;
        self.addressTF.text = [NSString stringWithFormat:@"%@ %@ %@ %@", self.deliveryAddress.provinceName, self.deliveryAddress.cityName, self.deliveryAddress.countyName, self.deliveryAddress.townName];
        self.addressSwicth.on = self.deliveryAddress.isDefault;
        self.detailsAddressTF.text = self.deliveryAddress.address;
    } else {
        self.navViewTitle.text = @"新建收货地址";
        [self addBarItemRightBarButton:@"" image:nil isTransparent:NO];
        self.addressTF.hidden = NO;
    }
    _provinceId = [NSString stringWithFormat:@"%zi", self.deliveryAddress.provinceId];
    _cityId = [NSString stringWithFormat:@"%zi", self.deliveryAddress.cityId];
    _countyId = [NSString stringWithFormat:@"%zi", self.deliveryAddress.countyId];
    _townId = [NSString stringWithFormat:@"%zi", self.deliveryAddress.townId];
}

-(void)changePlaceHolderColor:(UITextField*)tf{
    [tf setValue:[UIColor colorWithHexString:@"999999"] forKeyPath:FSPlacerholderColorKeyPath];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

-(void)keyBoardWillChangeFrame:(NSNotification*)note{
    CGRect keyboardFrame = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomSpaceing.constant = keyboardFrame.size.height;
}

- (IBAction)clickAddressBtn:(UIButton *)sender {
    [self.view endEditing:true];
    
    __weak __typeof(self)weakSelf = self;
    THNChooseCityViewController *chooseCityVC = [[THNChooseCityViewController alloc] init];
    chooseCityVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    chooseCityVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    chooseCityVC.getChooseAddressId = ^(NSString *provinceId, NSString *cityId, NSString *countyId, NSString *streetId) {
        NSLog(@"== %@ == %@ == %@ == %@", provinceId, cityId, countyId, streetId);
        _provinceId = provinceId;
        _cityId = cityId;
        _countyId = countyId;
        _townId = streetId;
    };
    chooseCityVC.getChooseAddressName = ^(NSString *provinceName, NSString *cityName, NSString *countyName, NSString *streetName) {
        NSLog(@"== %@ == %@ == %@ == %@", provinceName, cityName, countyName, streetName);
        weakSelf.addressTF.text = [NSString stringWithFormat:@"%@ %@ %@ %@", provinceName, cityName, countyName, streetName];
    };
    [self presentViewController:chooseCityVC animated:YES completion:nil];
}

-(void)rightBarItemSelected{
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"确定删除地址？" message:nil];
    WEAKSELF
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:nil];
    TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
        NSDictionary * params = @{@"id": self.deliveryAddress.idField};
        FBRequest * request = [FBAPI postWithUrlString:DeleteAddressURL requestDictionary:params delegate:weakSelf];
        request.flag = DeleteAddressURL;
        [request startRequest];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }];
    [alertView addAction:cancel];
    [alertView addAction:confirm];
    [alertView showInWindowWithBackgoundTapDismissEnable:YES];
}


- (IBAction)submitBtn:(UIButton *)sender {
    if (self.nameTF.text.length < 2) {
        [SVProgressHUD showInfoWithStatus:@"收货人姓名至少2个字符"];
        return;
    }
    
    if (self.phoneNumTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写联系方式"];
        return;
    }
    
    if (self.addressTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择所在地区"];
        return;
    }
    
    if (self.detailsAddressTF.text.length == 5) {
        [SVProgressHUD showInfoWithStatus:@"请填写详细地址"];
        return;
    }
    
    if (self.detailsAddressTF.text.length < 5) {
        [SVProgressHUD showInfoWithStatus:@"详细地址描述信息不得少于5个字符"];
        return;
    }
    
    if (self.phoneNumTF.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"内地手机号码为11位数字"];
        return;
    }
    
    if (self.zipTF.text.length > 6) {
        [SVProgressHUD showInfoWithStatus:@"邮编为6位数字"];
        return;
    }
    
    [self requestDataForCommitAddress];
}

#pragma mark - Network
//请求提交收货地址信息
- (void)requestDataForCommitAddress
{
    NSString * idStr = self.deliveryAddress.idField;
    if (self.deliveryAddress.idField == nil) {
        idStr = @"";
    }
    if (self.zipTF.text.length == 0) {
        self.zipTF.text = @"";
    }
    NSDictionary * params = @{@"id": idStr,
                              @"name": self.nameTF.text,
                              @"phone": self.phoneNumTF.text,
                              @"province_id": _provinceId,
                              @"city_id": _cityId,
                              @"county_id": _countyId,
                              @"town_id": _townId,
                              @"address": self.detailsAddressTF.text,
                              @"zip": self.zipTF.text,
                              @"is_default": [NSNumber numberWithBool:self.addressSwicth.on]};
    FBRequest * request = [FBAPI postWithUrlString:EditAddressURL requestDictionary:params delegate:self];
    request.flag = EditAddressURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

#pragma mark - FBRequest Delegate
- (void)requestSucess:(FBRequest *)request result:(id)result
{
    NSString * message = result[@"message"];
    if ([request.flag isEqualToString:EditAddressURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:message];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    if ([request.flag isEqualToString:DeleteAddressURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:message];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    request = nil;
}

- (void)requestFailed:(FBRequest *)request error:(NSError *)error
{
    [SVProgressHUD dismiss];
}

- (void)userCanceledFailed:(FBRequest *)request error:(NSError *)error
{
    [SVProgressHUD dismiss];
}


@end
