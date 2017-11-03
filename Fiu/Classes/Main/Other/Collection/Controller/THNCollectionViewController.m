//
//  THNCollectionViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNCollectionViewController.h"
#import "UIView+FSExtension.h"
#import "THNContentViewController.h"

@interface THNCollectionViewController ()<UIScrollViewDelegate>

/**  */
@property (nonatomic, strong) UIView *titlesView;
/**  */
@property (nonatomic, strong) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation THNCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navViewTitle.text = @"收藏";
    // 初始化子控制器
    [self setupChildVces];
    // 设置顶部的标签栏
    [self setupTitlesView];
    // 底部的scrollView
    [self setupContentView];
}

/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    if (SCREEN_HEIGHT == 812) {
        contentView.frame = CGRectMake(0, 88 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 88 - 44);
    } else {
        contentView.frame = CGRectMake(0, 64 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44);
    }
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

/**
 * 设置顶部的标签栏
 */
- (void)setupTitlesView
{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    titlesView.width = SCREEN_WIDTH;
    titlesView.height = 44;
    if (SCREEN_HEIGHT == 812) {
        titlesView.y = 88;
    } else {
        titlesView.y = 64;
    }
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor colorWithHexString:@"#C29022"];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = titlesView.width / self.childViewControllers.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0; i<self.childViewControllers.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        //        [button layoutIfNeeded]; // 强制布局(强制更新子控件的frame)
        [button setTitleColor:[UIColor colorWithHexString:@"#6F6F6F"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#C29022"] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    
    [titlesView addSubview:indicatorView];
}

- (void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}


/**
 * 初始化子控制器
 */
- (void)setupChildVces
{
    
    THNContentViewController *sence = [[THNContentViewController alloc] init];
    sence.title = @"情境";
    sence.type = CollectionTypeSence;
    [self addChildViewController:sence];
    
    THNContentViewController *good = [[THNContentViewController alloc] init];
    good.title = @"产品";
    good.type = CollectionTypeGood;
    [self addChildViewController:good];

}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (SCREEN_HEIGHT == 812) {
        return CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.25 * 667.0);
    }
    return CGSizeMake((SCREEN_WIDTH - 15 * 3) * 0.5, 0.25 * SCREEN_HEIGHT);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}



@end
