//
//  GoodsBrandViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsBrandViewController.h"
#import "GoodsBrandTableViewCell.h"
#import "BrandInfoData.h"

static NSString *const URLBrandInfo = @"/scene_brands/view";

@interface GoodsBrandViewController ()

@pro_strong BrandInfoData          *    brandInfo;

@end

@implementation GoodsBrandViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self networkBrandInfoData];
    [self.view addSubview:self.goodsBrandTable];
    [self.goodsBrandTable addSubview:self.titleLab];
}

#pragma mark - 网络请求
- (void)networkBrandInfoData {
    self.brandRequest = [FBAPI getWithUrlString:URLBrandInfo requestDictionary:@{@"id":self.brandId} delegate:self];
    [self.brandRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"品牌详情%@", result);
        self.brandInfo = [[BrandInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        [self.goodsBrandTable reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - 品牌视图
- (UITableView *)goodsBrandTable {
    if (!_goodsBrandTable) {
        _goodsBrandTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _goodsBrandTable.showsVerticalScrollIndicator = NO;
        _goodsBrandTable.showsHorizontalScrollIndicator = NO;
        _goodsBrandTable.delegate = self;
        _goodsBrandTable.dataSource = self;
        _goodsBrandTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsBrandTable.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    }
    return _goodsBrandTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * goodsBrandCellId = @"GoodsBrandCellId";
        GoodsBrandTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsBrandCellId];
        if (!cell) {
            cell = [[GoodsBrandTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsBrandCellId];
        }
        [cell.brandBgImg downloadImage:self.brandBgImg place:[UIImage imageNamed:@""]];
        [cell setBrandInfoData:self.brandInfo];
        return cell;
    
    } else {
        static NSString * brandGoodsListCellId = @"BrandGoodsListCellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:brandGoodsListCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:brandGoodsListCellId];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"商品 %zi", indexPath.row];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GoodsBrandTableViewCell * cell = [[GoodsBrandTableViewCell alloc] init];
        [cell getContentCellHeight:self.brandInfo.des];
        return  cell.cellHeight;
    } else {
        return 266.5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addBarItemLeftBarButton:@"" image:@"icon_back_white" isTransparent:YES];
}

- (void)leftBarItemSelected {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

#pragma mark - 控制器标题
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, 20, 200, 44)];
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}


@end
