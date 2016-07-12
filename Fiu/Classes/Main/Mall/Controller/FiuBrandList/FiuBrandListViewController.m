//
//  FiuBrandListViewController.m
//  Fiu
//
//  Created by FLYang on 16/7/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuBrandListViewController.h"
#import "BrandsListTableViewCell.h"
#import "GoodsBrandViewController.h"

static NSString *const URLBrandList = @"/scene_brands/getlist";

@interface FiuBrandListViewController () {
    NSMutableDictionary     *   _brandDict;
}

@pro_strong NSMutableArray      *   brandListMarr;
@pro_strong NSMutableArray      *   brandIdMarr;
@pro_strong NSMutableArray      *   selfBrandListMarr;
@pro_strong NSMutableArray      *   selfBrandIdMarr;

@end

@implementation FiuBrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationViewUI];
    
    _brandDict = [[NSMutableDictionary alloc] init];
    
    [self.view addSubview:self.brandTable];
    
    [self networkBrandListData];

}

#pragma mark - 网络请求
#pragma mark 品牌列表
- (void)networkBrandListData {
    [SVProgressHUD show];
    
    self.selfBrandListRequest = [FBAPI getWithUrlString:URLBrandList requestDictionary:@{@"page":@"1", @"size":@"100", @"sort":@"1", @"self_run":@"1"} delegate:self];
    [self.selfBrandListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * selfBrandListArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * selfBrandDict in selfBrandListArr) {
            BrandListModel * selfBrandModel = [[BrandListModel alloc] initWithDictionary:selfBrandDict];
            [self.selfBrandListMarr addObject:selfBrandModel];
            [self.selfBrandIdMarr addObject:selfBrandModel.brandId];
        }
        [self.seleBrandView setBrandData:self.selfBrandListMarr withIdData:self.selfBrandIdMarr];
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    self.brandListRequest = [FBAPI getWithUrlString:URLBrandList requestDictionary:@{@"page":@"1", @"size":@"100", @"sort":@"1"} delegate:self];
    [self.brandListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * brandListArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * brandDict in brandListArr) {
            BrandListModel * brandModel = [[BrandListModel alloc] initWithDictionary:brandDict];
            [self.brandListMarr addObject:brandModel];
            [self.brandIdMarr addObject:brandModel.brandId];
        }
        
        if (self.brandListMarr.count > 0) {
            [self getAllBrand];
            [self.brandTable reloadData];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 获取品牌首字母
- (void)getAllBrand {
    for (BrandListModel * model in self.brandListMarr) {
        NSMutableArray * marr = _brandDict[model.mark];
        if (marr == nil) {
            marr = [NSMutableArray array];
            [_brandDict setObject:marr forKey:model.mark];
        }
        [marr addObject:model];
    }
}

#pragma mark - 按首字母排序
- (NSArray *)getSortAllBrand {
    NSArray * keys = [_brandDict allKeys];
    
    return [keys sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - 自营商品列表
- (FBBrandGoodsView *)seleBrandView {
    if (!_seleBrandView) {
        _seleBrandView = [[FBBrandGoodsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.61 + 50)];
        _seleBrandView.nav = self.navigationController;
    }
    return _seleBrandView;
}

#pragma mark - 转换大小写
- (NSMutableArray *)upperBrandName {
    NSMutableArray * upperMarr = [NSMutableArray array];
    NSArray * keys = [self getSortAllBrand];
    for (NSString * str in keys) {
        NSString * upperStr = [str uppercaseString];
        [upperMarr addObject:upperStr];
    }
    return upperMarr;
}

#pragma mark - 所有品牌列表
- (UITableView *)brandTable {
    if (!_brandTable) {
        _brandTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _brandTable.delegate = self;
        _brandTable.dataSource = self;
        _brandTable.tableHeaderView = self.seleBrandView;
        _brandTable.sectionHeaderHeight = 20.0f;
        _brandTable.sectionFooterHeight = 0.01f;
        _brandTable.sectionIndexColor = [UIColor colorWithHexString:@"#666666"];
        _brandTable.tableFooterView = [UIView new];
    }
    return _brandTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self getSortAllBrand].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * keys = [self getSortAllBrand];
    NSString * keyStr = keys[section];
    NSArray * array = [_brandDict objectForKey:keyStr];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * brandListCellId = @"brandListCellId";
    BrandsListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:brandListCellId];
    if (!cell) {
        cell = [[BrandsListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:brandListCellId];
    }
    if (self.brandListMarr.count) {
        NSArray * keys = [self getSortAllBrand];
        NSString * keyStr = keys[indexPath.section];
        NSMutableArray * marr = [_brandDict objectForKey:keyStr];
        [cell setBrandListData:marr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self upperBrandName][section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self upperBrandName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * keys = [self getSortAllBrand];
    NSString * keyStr = keys[indexPath.section];
    NSArray * array = [_brandDict objectForKey:keyStr];
    BrandListModel * model = [array objectAtIndex:indexPath.row];
    GoodsBrandViewController * brandVC = [[GoodsBrandViewController alloc] init];
    brandVC.brandId = model.brandId;
    [self.navigationController pushViewController:brandVC animated:YES];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"FiuBrandListVC", nil);
    self.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

#pragma mark -
- (NSMutableArray *)brandListMarr {
    if (!_brandListMarr) {
        _brandListMarr = [NSMutableArray array];
    }
    return _brandListMarr;
}

- (NSMutableArray *)brandIdMarr {
    if (!_brandIdMarr) {
        _brandIdMarr = [NSMutableArray array];
    }
    return _brandIdMarr;
}

- (NSMutableArray *)selfBrandListMarr {
    if (!_selfBrandListMarr) {
        _selfBrandListMarr = [NSMutableArray array];
    }
    return _selfBrandListMarr;
}

- (NSMutableArray *)selfBrandIdMarr {
    if (!_selfBrandIdMarr) {
        _selfBrandIdMarr = [NSMutableArray array];
    }
    return _selfBrandIdMarr;
}

@end
