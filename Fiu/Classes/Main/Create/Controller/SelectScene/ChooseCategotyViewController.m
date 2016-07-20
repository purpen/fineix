//
//  ChooseCategotyViewController.m
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChooseCategotyViewController.h"
#import "ChooseCategoryCollectionViewCell.h"
#import "CatagoryFiuSceneModel.h"

static NSString *const URLFiuCategoryList = @"/category/getlist";

@interface ChooseCategotyViewController ()

@pro_strong NSMutableArray          *   categoryMarr;
@pro_strong NSMutableArray          *   categoryIdMarr;

@end

@implementation ChooseCategotyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.categoryView];
    [self networkAllFiuSceneCategory];
    
}

#pragma mark - 网络请求
- (void)networkAllFiuSceneCategory {
    self.categoryListRequest = [FBAPI getWithUrlString:URLFiuCategoryList requestDictionary:@{@"domain":@"13", @"show_all":@"0"} delegate:self];
    [self.categoryListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * categoryArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * categoryDic in categoryArr) {
            CatagoryFiuSceneModel * categoryModel = [[CatagoryFiuSceneModel alloc] initWithDictionary:categoryDic];
            [self.categoryMarr addObject:categoryModel];
            [self.categoryIdMarr addObject:[NSString stringWithFormat:@"%zi", categoryModel.categoryId]];
        }
        
        [self.categoryView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

#pragma mark - 情景分类视图
- (UICollectionView *)categoryView {
    if (!_categoryView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 30)/2, ((SCREEN_WIDTH - 30)/2) * 0.54);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.minimumInteritemSpacing = 10.0f;
        
        _categoryView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 50) collectionViewLayout:flowLayout];
        _categoryView.delegate = self;
        _categoryView.dataSource = self;
        _categoryView.backgroundColor = [UIColor whiteColor];
        [_categoryView registerClass:[ChooseCategoryCollectionViewCell class] forCellWithReuseIdentifier:@"ChooseCategoryCollectionViewCellID"];
    }
    return _categoryView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseCategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseCategoryCollectionViewCellID" forIndexPath:indexPath];
    if (self.categoryMarr.count) {
        [cell setCategoryData:self.categoryMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        self.getCategoryData([self.categoryMarr valueForKey:@"categoryTitle"][indexPath.row], self.categoryIdMarr[indexPath.row]);
    }];
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"chooseCategoryVC", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCloseBtn];
    [self addLine];
}

- (NSMutableArray *)categoryMarr {
    if (!_categoryMarr) {
        _categoryMarr = [NSMutableArray array];
    }
    return _categoryMarr;
}

- (NSMutableArray *)categoryIdMarr {
    if (!_categoryIdMarr) {
        _categoryIdMarr = [NSMutableArray array];
    }
    return _categoryIdMarr;
}

@end
