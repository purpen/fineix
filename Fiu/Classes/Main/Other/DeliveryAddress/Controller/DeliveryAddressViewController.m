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
@property (nonatomic,strong) UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

static NSString *const AddressURL = @"/delivery_address/get_list";
static NSString *const DeleteAddressURL = @"/delivery_address/deleted";
static NSString *const DeliveryAddressCellIdentifier = @"deliveryAddressCell";

@implementation DeliveryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.navViewTitle.text = @"收货地址";
    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    self.addressTableView.rowHeight = 120;
    
    [self.addressTableView registerNib:[UINib nibWithNibName:@"DeliveryAddressCell" bundle:nil] forCellReuseIdentifier:DeliveryAddressCellIdentifier];
    
    [self.addAddressBtn addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
        make.top.mas_equalTo(_addAddressBtn.mas_top).with.offset(0);
        make.left.mas_equalTo(_addAddressBtn.mas_left).with.offset(0);
        make.right.mas_equalTo(_addAddressBtn.mas_right).with.offset(0);
    }];
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
        _lineView.alpha = 0.5;
    }
    return _lineView;
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
    NSDictionary * params = @{@"page": @1, @"size": @1000};
    FBRequest * request = [FBAPI postWithUrlString:AddressURL requestDictionary:params delegate:self];
    request.flag = AddressURL;
    [request startRequest];
    [SVProgressHUD show];
}

- (void)requestRemoveAddressWithId:(NSString *)idField
{
    NSDictionary * params = @{@"id": idField};
    FBRequest * request = [FBAPI postWithUrlString:DeleteAddressURL requestDictionary:params delegate:self];
    request.flag = DeleteAddressURL;
    [request startRequest];
    [SVProgressHUD show];
}

#pragma mark - FBRequest Delegate
- (void)requestSucess:(FBRequest *)request result:(id)result
{
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
            if (self.addressAry.count == 0) {
                [self thn_setFirstAppStart];
                
                self.bgImageView.hidden = NO;
                self.tipLabel.hidden = NO;
            }else{
                self.bgImageView.hidden = YES;
                self.tipLabel.hidden = YES;
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    if ([request.flag isEqualToString:DeleteAddressURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            int a = (int)self.addressAry.count;
            a--;
            if (a == 0) {
                self.bgImageView.hidden = NO;
                self.tipLabel.hidden = NO;
            }else{
                self.bgImageView.hidden = YES;
                self.tipLabel.hidden = YES;
            }
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
}

- (void)userCanceledFailed:(FBRequest *)request error:(NSError *)error
{
    [SVProgressHUD dismiss];
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
                addressCell.unSelectedImage.hidden = YES;
            } else {
                addressCell.unSelectedImage.hidden = NO;
                addressCell.selectedImgView.hidden = true;
            }
            if (addressCell.deliveryAddress.isDefault) {
                addressCell.defaultLbl.hidden = false;
            } else {
                addressCell.defaultLbl.hidden = true;
            }
        } else {
            if (addressCell.deliveryAddress.isDefault) {
                addressCell.unSelectedImage.hidden = YES;
                addressCell.selectedImgView.hidden = false;
                addressCell.defaultLbl.hidden = false;
            } else {
                addressCell.unSelectedImage.hidden = NO;
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

#pragma mark - 首次打开加载提示
- (void)thn_setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"UserNewAddress"]){
        [USERDEFAULT setBool:YES forKey:@"UserNewAddress"];
        TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"收货地址更新" message:@"地址管理优化啦，快来填写一个新地址试试吧。"];
        TYAlertAction * confirm = [TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDefault handler:^(TYAlertAction * action) {

        }];
        [alertView addAction:confirm];
        [alertView showInWindowWithBackgoundTapDismissEnable:YES];
    }
}

@end
