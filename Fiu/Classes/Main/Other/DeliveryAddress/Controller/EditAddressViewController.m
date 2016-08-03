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

@interface EditAddressViewController ()<FBNavigationBarItemsDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *zipTF;
@property (weak, nonatomic) IBOutlet UITextField *detailsAddressTF;
@property (weak, nonatomic) IBOutlet UISwitch *addressSwicth;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UILabel *prinLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;

@property (nonatomic, strong) NSMutableArray * provinceAry;
@property (nonatomic, strong) NSMutableArray * cityAry;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, copy) NSString  * provinceStr;
@property (nonatomic, copy) NSString  * cityStr;

@property (nonatomic, assign) NSInteger provinceRow;
@property(nonatomic,strong) AddreesPickerViewController *addreesPickerVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceing;

@end

static NSString *const EditAddressURL = @"/shopping/ajax_address";
static NSString *const DeleteAddressURL = @"/shopping/remove_address";

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    if (self.deliveryAddress) {
        self.navViewTitle.text = @"编辑收货地址";
        [self addBarItemRightBarButton:@"删除" image:nil isTransparent:NO];
        self.nameTF.text = self.deliveryAddress.name;
        self.phoneNumTF.text = self.deliveryAddress.phone;
        self.zipTF.text = self.deliveryAddress.zip;
        self.addressTF.hidden = YES;
        self.prinLabel.text = self.deliveryAddress.provinceName;
        self.cityLabel.text = self.deliveryAddress.cityName;
        self.addressTF.text = self.deliveryAddress.address;
        self.addressSwicth.on = self.deliveryAddress.isDefault;
        self.detailsAddressTF.text = self.deliveryAddress.address;
    } else {
        self.navViewTitle.text = @"新增收货地址";
        [self addBarItemRightBarButton:@"" image:nil isTransparent:NO];
        self.addressTF.hidden = NO;
    }
    self.provinceId = self.deliveryAddress.province;
    self.cityId = self.deliveryAddress.city;
    //通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
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
    //弹出选择视图
    self.addreesPickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_addreesPickerVC animated:NO completion:nil];
    [_addreesPickerVC.pickerBtn addTarget:self action:@selector(clickAddreesPickerBtn:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)clickAddreesPickerBtn:(UIButton*)sender{
    self.addressTF.hidden = YES;
    //拿到ID名称 更新列表，更新服务器上的 然后消失
    //self.addressTF.text = [NSString stringWithFormat:@"%@ %@",self.addreesPickerVC.provinceStr,self.addreesPickerVC.cityStr];
    self.prinLabel.text = self.addreesPickerVC.provinceStr;
    self.cityLabel.text = self.addreesPickerVC.cityStr;
    self.provinceId = self.addreesPickerVC.provinceId;
    self.cityId = self.addreesPickerVC.cityId;
    [self.addreesPickerVC dismissViewControllerAnimated:NO completion:nil];
}

-(AddreesPickerViewController *)addreesPickerVC{
    if (!_addreesPickerVC) {
        _addreesPickerVC = [[AddreesPickerViewController alloc] init];
    }
    return _addreesPickerVC;
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
    
    if (self.zipTF.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写邮编"];
        return;
    }
    
    if (self.prinLabel.text.length == 0 || self.cityLabel.text.length == 0) {
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
    if (self.zipTF.text.length != 6) {
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
    NSDictionary * params = @{@"id": idStr, @"name": self.nameTF.text, @"phone": self.phoneNumTF.text, @"province": [NSNumber numberWithInteger:self.provinceId], @"city": [NSNumber numberWithInteger:self.cityId], @"address": self.detailsAddressTF.text, @"zip": self.zipTF.text, @"is_default": [NSNumber numberWithBool:self.addressSwicth.on]};
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
