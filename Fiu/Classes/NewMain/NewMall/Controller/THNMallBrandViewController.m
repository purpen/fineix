//
//  THNMallBrandViewController.m
//  Fiu
//
//  Created by FLYang on 2017/4/11.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNMallBrandViewController.h"
#import "FBBrandGoodsCollectionViewCell.h"
#import "THNBrandInfoViewController.h"
#import "BrandListModel.h"

NSString *const URLBrandList = @"/scene_brands/getlist";
NSString *const BrandCellId = @"FBBrandGoodsCollectionViewCellID";

@interface THNMallBrandViewController ()

@end

@implementation THNMallBrandViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.frame = CGRectMake(SCREEN_WIDTH * self.index, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 157);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setViewUI];
}

#pragma mark - 网络获取品牌列表
- (void)thn_networkBrandListData {
    self.brandRequest = [FBAPI postWithUrlString:URLBrandList requestDictionary:@{@"page":@"1", @"size":@"10000", @"sort":@"1", @"from_to":@"1"} delegate:self];
    [self.brandRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *brandDic in goodsArr) {
            BrandListModel *brandModel = [[BrandListModel alloc] initWithDictionary:brandDic];
            [self.brandModelMarr addObject:brandModel];
            [self.brandIdMarr addObject:brandModel.brandId];
        }
        [self.brandList reloadData];
    
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"--- %@ ---", error);
    }];
}

#pragma mark - 设置视图
- (void)thn_setViewUI {
    [self.view addSubview:self.brandList];
    
    [self thn_networkBrandListData];
}

#pragma mark 好货列表
- (UICollectionView *)brandList {
    if (!_brandList) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 70)/4, (SCREEN_WIDTH - 70)/4 + 10);
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayout.minimumLineSpacing = 15.0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _brandList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 157)
                                            collectionViewLayout:flowLayout];
        _brandList.showsVerticalScrollIndicator = NO;
        _brandList.delegate = self;
        _brandList.dataSource = self;
        _brandList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_brandList registerClass:[FBBrandGoodsCollectionViewCell class] forCellWithReuseIdentifier:BrandCellId];
    }
    return _brandList;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.brandModelMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FBBrandGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BrandCellId
                                                                                     forIndexPath:indexPath];
    if (self.brandModelMarr.count) {
        [cell thn_setBrandData:self.brandModelMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNBrandInfoViewController *brandVC = [[THNBrandInfoViewController alloc] init];
    brandVC.brandId = self.brandIdMarr[indexPath.row];
    [self.navigationController pushViewController:brandVC animated:YES];
}

#pragma mark - NSMutableArray
- (NSMutableArray *)brandModelMarr {
    if (!_brandModelMarr) {
        _brandModelMarr = [NSMutableArray array];
    }
    return _brandModelMarr;
}

- (NSMutableArray *)brandIdMarr {
    if (!_brandIdMarr) {
        _brandIdMarr = [NSMutableArray array];
    }
    return _brandIdMarr;
}

@end
