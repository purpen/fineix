//
//  THNDomainInfoViewController.m
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainInfoViewController.h"
#import "THNBusinessTableViewCell.h"
#import "THNCouponTableViewCell.h"
#import "THNDesTableViewCell.h"
#import "THNMoreDesTableViewCell.h"
#import "NSString+JSON.h"

static NSString *const businessCellId = @"THNBusinessTableViewCellId";
static NSString *const couponCellId = @"THNCouponTableViewCellId";
static NSString *const desCellId = @"THNDesTableViewCellId";
static NSString *const moreCellId = @"THNMoreDesTableViewCellId";
static NSString *const URLDomainInfo = @"/scene_scene/view";

@interface THNDomainInfoViewController () {
    BOOL _rowSelected;
    NSIndexPath *_selectedIndexPath;
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
}

@end

@implementation THNDomainInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoId = @"62";
    [self thn_networkDomainInfoData];
    [self thn_setViewUI];
}

- (void)thn_networkDomainInfoData {
    self.infoRequest = [FBAPI postWithUrlString:URLDomainInfo requestDictionary:@{@"id":self.infoId} delegate:self];
    [self.infoRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSLog(@"==== %@", [NSString jsonStringWithObject:result]);
            NSDictionary *dict =  [result valueForKey:@"data"];
            self.infoModel = [[DominInfoData alloc] initWithDictionary:dict];
            [self.headerImages thn_setRollimageView:self.infoModel];
        
            self.navViewTitle.text = self.infoModel.title;
            [self.domainInfoTable reloadData];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)thn_setViewUI {
    [self.view addSubview:self.domainInfoTable];
}

- (THNDomainInfoHeaderImage *)headerImages {
    if (!_headerImages) {
        _headerImages = [[THNDomainInfoHeaderImage alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    return _headerImages;
}

- (UITableView *)domainInfoTable {
    if (!_domainInfoTable) {
        _domainInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _domainInfoTable.delegate = self;
        _domainInfoTable.dataSource = self;
        _domainInfoTable.tableHeaderView = self.headerImages;
        _domainInfoTable.tableFooterView = [UIView new];
        _domainInfoTable.showsVerticalScrollIndicator = NO;
        _domainInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _domainInfoTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:businessCellId];
        cell = [[THNBusinessTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:businessCellId];
        [cell thn_setBusinessData:self.infoModel];
        return cell;
        
    } else if (indexPath.row == 1) {
        THNCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:couponCellId];
        cell = [[THNCouponTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:couponCellId];
//        [cell thn_setCouponCount];
        return cell;
    } else if (indexPath.row == 2) {
        THNDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:desCellId];
        cell = [[THNDesTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:desCellId];
        [cell thn_setDesData:self.infoModel];
        _contentHigh = cell.cellHigh;
        _defaultContentHigh = cell.defaultCellHigh;
        return cell;
    } else if (indexPath.row == 3) {
        THNMoreDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
        cell = [[THNMoreDesTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:moreCellId];
        cell.moreButton.selected = _rowSelected;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CellID"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
//        return 170;
        return 150;
    } else if (indexPath.row == 1) {
        return 0.01;
    } else if (indexPath.row == 2) {
        if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
            return _contentHigh;
        } else {
            return _defaultContentHigh;
        }
        return 80;
    } else if (indexPath.row == 3 ) {
        return 44;
    }
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        if (_contentHigh > 90) {
            if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
                _selectedIndexPath = nil;
                _rowSelected = NO;
            } else {
                _selectedIndexPath = indexPath;
                _rowSelected = YES;
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.baseTable = self.domainInfoTable;
}

@end
