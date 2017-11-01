//
//  THNMallViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMallViewController.h"
#import "QRCodeScanViewController.h"
#import "THNRecommendViewController.h"
#import "THNNiceGoodsViewController.h"
#import "THNMallSceneViewController.h"
#import "THNMallBrandViewController.h"
#import "THNMallGoodsViewController.h"

static NSString *const URLCategory = @"/category/getlist";

@interface THNMallViewController () {
    NSString   *_idx;
    THNRecommendViewController *_recommendVC;
    THNNiceGoodsViewController *_subjectVC;
    THNMallSceneViewController *_sceneListVC;
    THNMallBrandViewController *_brandVC;
    THNMallGoodsViewController *_goodsVC;
}

@end

@implementation THNMallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self thn_setFirstAppStart];
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self thn_setMallViewUI];
    [self networkCategoryData];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    if (Is_iPhoneX) {
        self.menuView.frame = CGRectMake(0, 88, SCREEN_WIDTH, 44);
        self.mallRollView.frame = CGRectMake(0, 132, SCREEN_WIDTH, SCREEN_HEIGHT - 215);
    }
}

#pragma mark - 设置视图UI
- (void)thn_setMallViewUI {
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.mallRollView];
}

#pragma mark 滚动列表容器
- (UIScrollView *)mallRollView {
    if (!_mallRollView) {
        _mallRollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 157)];
        _mallRollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, 0);
        _mallRollView.backgroundColor = [UIColor whiteColor];
        _mallRollView.showsHorizontalScrollIndicator = NO;
        _mallRollView.pagingEnabled = YES;
        _mallRollView.scrollEnabled = NO;
        
        [self thn_addChildViewController];
    }
    return _mallRollView;
}

/**
 添加滚动的各子视图
 */
- (void)thn_addChildViewController {
    _recommendVC = [[THNRecommendViewController alloc] init];
    [self addChildViewController:_recommendVC];
    [self.mallRollView addSubview:_recommendVC.view];
    
    _subjectVC = [[THNNiceGoodsViewController alloc] init];
    _subjectVC.isIndex = 1;
    [self addChildViewController:_subjectVC];
    [self.mallRollView addSubview:_subjectVC.view];
    
    _goodsVC = [[THNMallGoodsViewController alloc] init];
    _goodsVC.index = 2;
    [self addChildViewController:_goodsVC];
    [self.mallRollView addSubview:_goodsVC.view];
    
    _sceneListVC = [[THNMallSceneViewController alloc] init];
    _sceneListVC.index = 3;
    [self addChildViewController:_sceneListVC];
    [self.mallRollView addSubview:_sceneListVC.view];
    
    _brandVC = [[THNMallBrandViewController alloc] init];
    _brandVC.index = 4;
    [self addChildViewController:_brandVC];
    [self.mallRollView addSubview:_brandVC.view];
}

#pragma mark 分类导航栏
- (FBMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _menuView.delegate = self;
        _menuView.defaultColor = @"#666666";
    }
    return _menuView;
}

/**
 切换分类

 @param index 点击的分类下标
 */
- (void)menuItemSelectedWithIndex:(NSInteger)index {
    [self thn_changeContentOffSize:index];
    _idx = self.categoryIdMarr[index];
    
    if (index > 1 && index < self.categoryIdMarr.count - 2) {
         [_goodsVC thn_getCategoryGoodsListData:_idx];
    }
}

- (void)thn_changeContentOffSize:(NSInteger)index {
    if (index > 2) {
        if (index == self.categoryMarr.count - 1) {
            index = 4;
        } else if (index == self.categoryMarr.count - 2) {
            index = 3;
        } else {
            index = 2;
        }
    }
    
    CGPoint point = self.mallRollView.contentOffset;
    point.x = SCREEN_WIDTH * index;
    [UIView animateWithDuration:0.3 animations:^{
        self.mallRollView.contentOffset = point;
    }];
}


#pragma mark -
#pragma mark - 网络获取分类列表
- (void)networkCategoryData {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategory requestDictionary:@{@"domain":@"1", @"page":@"1", @"size":@"100", @"use_cache":@"1"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self.categoryMarr removeAllObjects];
        
        //  本地增加分类标题
        [self.categoryMarr addObject:@"推荐"];
        [self.categoryMarr addObject:@"合集"];
        NSMutableArray *idxMarr = [NSMutableArray array];
        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *dataDict in dataArr) {
            CategoryRow *model = [[CategoryRow alloc] initWithDictionary:dataDict];
            [self.categoryMarr addObject:model.title];
            [idxMarr addObject:[NSString stringWithFormat:@"%zi",model.idField]];
        }
        [self.categoryMarr addObject:@"情境"];
        [self.categoryMarr addObject:@"品牌"];
        
        //  增加分类id
        [self.categoryIdMarr addObject:@"0"];
        NSString *allId = [idxMarr componentsJoinedByString:@","];
        [self.categoryIdMarr addObject:allId];
        [self.categoryIdMarr addObjectsFromArray:idxMarr];
        [self.categoryIdMarr addObject:@"0"];
        [self.categoryIdMarr addObject:@"0"];
        
        if (self.categoryMarr.count) {
            self.menuView.menuTitle = self.categoryMarr;
            [self.menuView updateMenuButtonData];
            [self.menuView updateMenuBtnState:0];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.navViewTitle.hidden = YES;
    [self thn_addSearchBtnText:NSLocalizedString(@"mallSearch", nil) type:2];
    self.searchBtn.frame = CGRectMake(50, 29, SCREEN_WIDTH - 65, 26);
    [self thn_addBarItemLeftBarButton:@"" image:@"mall_saoma"];
}

- (void)thn_leftBarItemSelected {
    QRCodeScanViewController * qrVC = [[QRCodeScanViewController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma mark - 首次打开加载指示图
- (void)thn_setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"MallGoodsLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"MallGoodsLaunch"];
        [self thn_setMoreGuideImgForVC:@[@"haohuo_saoyisao",@"haohuo_gouwuche"]];
    }
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
