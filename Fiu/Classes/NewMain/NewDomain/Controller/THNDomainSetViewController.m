//
//  THNDomainSetViewController.m
//  Fiu
//
//  Created by FLYang on 2017/3/8.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainSetViewController.h"
#import "THNDomainInfoSetViewController.h"
#import "THNInfoTitleTableViewCell.h"
#import "THNDomainImagesTableViewCell.h"
#import "THNDomainEditViewController.h"

static NSString *const URLDomainInfo = @"/scene_scene/view";
static NSString *const infoCellId = @"THNInfoTitleTableViewCellId";
static NSString *const imageCellId = @"THNDomainImagesTableViewCellId";

@interface THNDomainSetViewController ()

@end

@implementation THNDomainSetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.domainId.length) {
        [self thn_networkDomainInfoData];
        [self.view addSubview:self.setTableView];
    }
}

#pragma mark 地盘详情数据
- (void)thn_networkDomainInfoData {
    [SVProgressHUD show];
    self.infoRequest = [FBAPI getWithUrlString:URLDomainInfo requestDictionary:@{@"id":self.domainId, @"is_edit":@"1"} delegate:self];
    [self.infoRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"======= %@", [NSString jsonStringWithObject:result]);
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSDictionary *dict =  [result valueForKey:@"data"];
            self.infoData = [[THNDomainManageInfoData alloc] initWithDictionary:dict];
            [self.setTableView reloadData];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@" ---- %@ ----", error);
    }];
}

#pragma mark - 设置界面UI 
- (UITableView *)setTableView {
    if (!_setTableView) {
        _setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _setTableView.delegate = self;
        _setTableView.dataSource = self;
        _setTableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    }
    return _setTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    } else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        THNDomainImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellId];
        cell = [[THNDomainImagesTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:imageCellId];
        return cell;
        
    } else {
        THNInfoTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellId];
        cell = [[THNInfoTitleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:infoCellId];
        if (indexPath.section == 0) {
            [cell thn_setInfoTitleLeftText:@"地盘基本信息" andRightText:@""];
            if (self.infoData) {
                [cell thn_showImage:self.infoData.avatarUrl];
            }
            
        } else if (indexPath.section == 1) {
            NSArray *leftText = @[@"地盘简介", @"地盘亮点"];
            [cell thn_setInfoTitleLeftText:leftText[indexPath.row] andRightText:@""];
            
        } else if (indexPath.section == 3) {
            [cell thn_setInfoTitleLeftText:@"添加商品到地盘" andRightText:@""];
            [cell thn_showLeftButton];
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 140.0f;
    } else
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
        if (self.infoData) {
            THNDomainInfoSetViewController *infoSetVC = [[THNDomainInfoSetViewController alloc] init];
            infoSetVC.infoData = self.infoData;
            [self.navigationController pushViewController:infoSetVC animated:YES];
        }
    
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            THNDomainEditViewController *editVC = [[THNDomainEditViewController alloc] init];
            editVC.setInfoType = 8;
            editVC.infoData = self.infoData;
            [self.navigationController pushViewController:editVC animated:YES];
        }
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"地盘管理";
}

#pragma mark - 

@end
