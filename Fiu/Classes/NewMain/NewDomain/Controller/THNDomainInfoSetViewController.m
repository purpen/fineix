//
//  THNDomainInfoSetViewController.m
//  Fiu
//
//  Created by FLYang on 2017/3/9.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainInfoSetViewController.h"
#import "THNInfoTitleTableViewCell.h"
#import "THNDomainEditViewController.h"
#import "SearchLocationViewController.h"
#import "UIView+TYAlertView.h"

static NSString *const setInfoCellId = @"SetInfoCellId";
static NSString *const URLEditDomain = @"/scene_scene/save";
static NSString *const URLDomainInfo = @"/scene_scene/view";

@interface THNDomainInfoSetViewController () {
    NSString *_domainId;
}

@end

@implementation THNDomainInfoSetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    
    if (self.infoData) {
        _domainId = [NSString stringWithFormat:@"%zi", self.infoData.idField];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo) name:@"SaveEditInfoSucceed" object:nil];
}

- (void)refreshInfo {
    [self thn_networkDomainInfoData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.infoTableView];

}

#pragma mark 地盘详情数据
- (void)thn_networkDomainInfoData {
    [SVProgressHUD show];
    self.infoRequest = [FBAPI getWithUrlString:URLDomainInfo requestDictionary:@{@"id":_domainId, @"is_edit":@"1"} delegate:self];
    [self.infoRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict =  [result valueForKey:@"data"];
        self.infoData = [[THNDomainManageInfoData alloc] initWithDictionary:dict];
        [self.infoTableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@" ---- %@ ----", error);
    }];
}

#pragma mark - 保存编辑
- (void)thn_networkSaveEditData:(SaveEditType)type headerImage:(UIImage *)image location:(NSDictionary *)location {
    if (type == SaveEditTypeHeaderImage) {
        [SVProgressHUD showWithStatus:@"正在上传" maskType:(SVProgressHUDMaskTypeBlack)];
        NSData * imageData = UIImageJPEGRepresentation(image, 1);
        NSString *img64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        self.domainEditRequest = [FBAPI postWithUrlString:URLEditDomain requestDictionary:@{@"id":_domainId,
                                                                                            @"avatar_tmp":img64Str} delegate:self];
        
    } else if (type == SaveEditTypeLocation) {
        [SVProgressHUD show];
        self.domainEditRequest = [FBAPI postWithUrlString:URLEditDomain requestDictionary:@{@"id":_domainId,
                                                                                            @"city":location[@"city"],
                                                                                            @"address":location[@"address"],
                                                                                            @"lat":location[@"lat"],
                                                                                            @"lng":location[@"lng"]} delegate:self];
    }
    
    [self.domainEditRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self thn_networkDomainInfoData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"--- %@ ---", error);
    }];
}

#pragma mark - 设置界面UI
- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _infoTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else
        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNInfoTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setInfoCellId];
    cell = [[THNInfoTitleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:setInfoCellId];
    if (indexPath.section == 0) {
        NSArray *leftText = @[@"地盘头像", @"地盘标题", @"地盘副标题", @"地盘分类", @"地盘标签"];
        NSArray *rightText = @[@"", self.infoData.title, self.infoData.subTitle, self.infoData.category.title, @""];
        [cell thn_setInfoTitleLeftText:leftText[indexPath.row] andRightText:rightText[indexPath.row]];
        if (indexPath.row == 0) {
            [cell thn_showImage:self.infoData.avatarUrl];
        }
    
    } else if (indexPath.section == 1) {
        NSArray *leftText = @[@"地盘地址", @"地盘电话", @"地盘营业时间"];
        NSArray *rightText = @[self.infoData.address, self.infoData.extra.tel, self.infoData.extra.shopHours];
        [cell thn_setInfoTitleLeftText:leftText[indexPath.row] andRightText:rightText[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    } else
        return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self openImagePickerChooseHeader];
            
        } else {
            THNDomainEditViewController *editVC = [[THNDomainEditViewController alloc] init];
            editVC.setInfoType = indexPath.row;
            editVC.infoData = self.infoData;
            [self.navigationController pushViewController:editVC animated:YES];
        }
    
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self openLocationMap];
       
        } else {
            THNDomainEditViewController *editVC = [[THNDomainEditViewController alloc] init];
            editVC.setInfoType = indexPath.row + 5;
            editVC.infoData = self.infoData;
            [self.navigationController pushViewController:editVC animated:YES];
        }
    }
}

#pragma mark - 打开地图选择位置
- (void)openLocationMap {
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *locationDict = [NSMutableDictionary dictionary];
    SearchLocationViewController *searchLocationVC = [[SearchLocationViewController alloc] init];
    searchLocationVC.type = @"release";
    searchLocationVC.selectedLocationBlock = ^(NSString *location, NSString *city, NSString *latitude, NSString *longitude){
        [locationDict setObject:location forKey:@"address"];
        [locationDict setObject:city forKey:@"city"];
        [locationDict setObject:latitude forKey:@"lat"];
        [locationDict setObject:longitude forKey:@"lng"];
        [weakSelf thn_networkSaveEditData:(SaveEditTypeLocation) headerImage:nil location:locationDict];
    };
    [self.navigationController pushViewController:searchLocationVC animated:YES];

}

#pragma mark - 打开相册选择头像
- (void)openImagePickerChooseHeader {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"选择地盘头像" message:@""];
    alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#666666"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"拍照" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self takePhoto];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"相册选择" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self openPhotoLibrary];
    }]];

    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
//        NSLog(@"--- 取消 ---");
    }]];

    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 拍照
- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark 打开相册
- (void)openPhotoLibrary {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 获取图片完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self thn_networkSaveEditData:(SaveEditTypeHeaderImage) headerImage:image location:nil];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"基本信息";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SaveEditInfoSucceed" object:nil];
}

@end
