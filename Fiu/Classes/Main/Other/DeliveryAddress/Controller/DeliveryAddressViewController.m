//
//  DeliveryAddressViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "DeliveryAddressViewController.h"
#import "SVProgressHUD.h"
#import "DeliveryAddressModel.h"
#import "EditAddressViewController.h"
#import "DeliveryAddressCell.h"
#import "TYAlertView.h"
#import "UIView+TYAlertView.h"

@interface DeliveryAddressViewController ()<FBNavigationBarItemsDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (nonatomic, strong) NSMutableArray * addressAry;
@end

static NSString *const AddressURL = @"/shopping/address";
static NSString *const DeleteAddressURL = @"/shopping/remove_address";
static NSString *const DeliveryAddressCellIdentifier = @"deliveryAddressCell";

@implementation DeliveryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navViewTitle.text = @"收货地址";
    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    self.addressTableView.rowHeight = 120;
    // Do any additional setup after loading the view from its nib.
    [self.addressTableView registerNib:[UINib nibWithNibName:@"DeliveryAddressCell" bundle:nil] forCellReuseIdentifier:DeliveryAddressCellIdentifier];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestDataForAddress];
}

#pragma mark - Network
//请求收货地址信息
- (void)requestDataForAddress
{
    NSDictionary * params = @{@"page": @1, @"size": @50};
    FBRequest * request = [FBAPI postWithUrlString:AddressURL requestDictionary:params delegate:self];
    request.flag = AddressURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

- (void)requestRemoveAddressWithId:(NSString *)idField
{
    NSDictionary * params = @{@"id": idField};
    FBRequest * request = [FBAPI postWithUrlString:DeleteAddressURL requestDictionary:params delegate:self];
    request.flag = DeleteAddressURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

#pragma mark - FBRequest Delegate
- (void)requestSucess:(FBRequest *)request result:(id)result
{
    NSLog(@"收货地址   %@", result);
    NSString * message = result[@"message"];
    if ([request.flag isEqualToString:AddressURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            
            self.addressAry = [NSMutableArray array];
            NSDictionary * dataDic = [result objectForKey:@"data"];
            NSArray * rowsAry = [dataDic objectForKey:@"rows"];
            
            for (NSDictionary * addressDic in rowsAry) {
                DeliveryAddressModel * address = [[DeliveryAddressModel alloc] initWithDictionary:addressDic];
                [self.addressAry addObject:address];
            }
            [self.addressTableView reloadData];
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    if ([request.flag isEqualToString:DeleteAddressURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    request = nil;
}

- (void)requestFailed:(FBRequest *)request error:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", [error localizedDescription]);
}

- (void)userCanceledFailed:(FBRequest *)request error:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", [error localizedDescription]);
}


- (IBAction)addAddressBtn:(UIButton *)sender {
    EditAddressViewController * editAddressVC = [[EditAddressViewController alloc] initWithNibName:@"EditAddressViewController" bundle:nil];
    editAddressVC.deliveryAddress = nil;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.addressAry.count) {
        return self.addressAry.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryAddressCell * addressCell = [tableView dequeueReusableCellWithIdentifier:DeliveryAddressCellIdentifier forIndexPath:indexPath];
    
    addressCell.selectedCellBlock = ^(DeliveryAddressCell * cell) {
        EditAddressViewController * editAddressVC = [[EditAddressViewController alloc] initWithNibName:@"EditAddressViewController" bundle:nil];
        editAddressVC.deliveryAddress = cell.deliveryAddress;
        [self.navigationController pushViewController:editAddressVC animated:YES];
    };
    
    if (self.addressAry.count) {
        addressCell.deliveryAddress = self.addressAry[indexPath.row];
        
        if (self.isSelectType) {
            if ([addressCell.deliveryAddress.idField isEqualToString:self.selectedAddress.idField]) {
                addressCell.selectedImgView.hidden = false;
            } else {
                addressCell.selectedImgView.hidden = true;
            }
            if (addressCell.deliveryAddress.isDefault) {
                addressCell.defaultLbl.hidden = false;
            } else {
                addressCell.defaultLbl.hidden = true;
            }
        } else {
            if (addressCell.deliveryAddress.isDefault) {
                addressCell.selectedImgView.hidden = false;
                addressCell.defaultLbl.hidden = false;
            } else {
                addressCell.selectedImgView.hidden = true;
                addressCell.defaultLbl.hidden = true;
            }
        }
    }
    return addressCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    DeliveryAddressCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.isSelectType) {
        self.selectedAddressBlock(cell.deliveryAddress);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    EditAddressViewController * editAddressVC = [[EditAddressViewController alloc] initWithNibName:@"EditAddressViewController" bundle:nil];
    editAddressVC.deliveryAddress = cell.deliveryAddress;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}

//启用cell左滑删除效果，必须实现该方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DeliveryAddressCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"确认删除地址？" message:nil];
        WEAKSELF
        TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
            [tableView setEditing:false];
        }];
        TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {
            [weakSelf requestRemoveAddressWithId:cell.deliveryAddress.idField];
            
            [weakSelf.addressAry removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [alertView addAction:cancel];
        [alertView addAction:confirm];
        [alertView showInWindowWithBackgoundTapDismissEnable:YES];
    }
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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
