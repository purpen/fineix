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

static NSString *const setInfoCellId = @"SetInfoCellId";

@interface THNDomainInfoSetViewController ()

@end

@implementation THNDomainInfoSetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.infoTableView];
    
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
        NSArray *rightText = @[@"", self.infoData.title, self.infoData.subTitle, @"", @""];
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
        if (indexPath.row != 0) {
            THNDomainEditViewController *editVC = [[THNDomainEditViewController alloc] init];
            editVC.setInfoType = indexPath.row;
            editVC.infoData = self.infoData;
            [self.navigationController pushViewController:editVC animated:YES];
        }
    
    } else if (indexPath.section == 1) {
        THNDomainEditViewController *editVC = [[THNDomainEditViewController alloc] init];
        editVC.setInfoType = indexPath.row + 5;
        editVC.infoData = self.infoData;
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"基本信息";
}

@end
