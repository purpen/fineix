//
//  THNDomainInfoSetViewController.m
//  Fiu
//
//  Created by FLYang on 2017/3/9.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainInfoSetViewController.h"

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CellID"];
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

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"基本信息";
}

@end
