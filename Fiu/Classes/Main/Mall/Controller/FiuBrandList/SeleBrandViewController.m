//
//  SeleBrandViewController.m
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SeleBrandViewController.h"
#import "GoodsBrandViewController.h"
#import "FBBrandGoodsCollectionViewCell.h"

static NSString *const URLBrandList = @"/scene_brands/getlist";

@interface SeleBrandViewController ()

@end

@implementation SeleBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationViewUI];
    
    [self.view addSubview:self.selfBrandList];
    
    [self networkBrandListData];
    
}

#pragma mark - 网络请求
#pragma mark 品牌列表
- (void)networkBrandListData {
    [SVProgressHUD show];
    
    self.selfBrandListRequest = [FBAPI getWithUrlString:URLBrandList requestDictionary:@{@"page":@"1", @"size":@"10000", @"self_run":@"1"} delegate:self];
    [self.selfBrandListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * selfBrandListArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * selfBrandDict in selfBrandListArr) {
            BrandListModel * selfBrandModel = [[BrandListModel alloc] initWithDictionary:selfBrandDict];
            [self.selfBrandListMarr addObject:selfBrandModel];
            [self.selfBrandIdMarr addObject:selfBrandModel.brandId];
        }
        [self.selfBrandList reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 自营商品列表
- (UICollectionView *)selfBrandList {
    if (!_selfBrandList) {
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 50)/3, (SCREEN_WIDTH - 50)/3);
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
        
        _selfBrandList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
        _selfBrandList.backgroundColor = [UIColor whiteColor];
        _selfBrandList.delegate = self;
        _selfBrandList.dataSource = self;
        [_selfBrandList registerClass:[FBBrandGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"FBBrandGoodsCollectionViewCellID"];
        
    }
    return _selfBrandList;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selfBrandListMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FBBrandGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FBBrandGoodsCollectionViewCellID" forIndexPath:indexPath];
    [cell setSelfBrandData:self.selfBrandListMarr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsBrandViewController * brandVC = [[GoodsBrandViewController alloc] init];
    brandVC.brandId = self.selfBrandIdMarr[indexPath.row];
    [self.navigationController pushViewController:brandVC animated:YES];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"SeleBrandVC", nil);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
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
