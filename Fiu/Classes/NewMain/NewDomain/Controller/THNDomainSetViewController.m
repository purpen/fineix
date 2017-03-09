//
//  THNDomainSetViewController.m
//  Fiu
//
//  Created by FLYang on 2017/3/8.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainSetViewController.h"
#import "THNDomainInfoSetViewController.h"

@interface THNDomainSetViewController ()

@end

@implementation THNDomainSetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.setTableView];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CellID"];
    return cell;
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
        THNDomainInfoSetViewController *infoSetVC = [[THNDomainInfoSetViewController alloc] init];
        [self.navigationController pushViewController:infoSetVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"地盘管理";
}

@end
