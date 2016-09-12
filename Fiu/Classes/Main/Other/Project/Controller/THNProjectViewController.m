//
//  THNProjectViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNProjectViewController.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import "UIView+FSExtension.h"
#import "THNArticleViewController.h"
#import "THNActivityViewController.h"
#import "THNXinPinViewController.h"
#import "THNSalesViewController.h"

@interface THNProjectViewController ()<UIScrollViewDelegate>

/**  */
@property (nonatomic, strong) UIView *titlesView;
/**  */
@property (nonatomic, strong) UIView *indicatorView;
/**  */
@property (nonatomic, strong) UIButton *selectedButton;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
/**  */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation THNProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navViewTitle.text = @"精选主题";
    
    // 初始化子控制器
    [self setupChildVces];
    // 设置顶部的标签栏
    [self setupTitlesView];
    // 底部的scrollView
    [self setupContentView];
    
    [self.view addSubview:self.lineView];
}

/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = CGRectMake(0, 64 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5 + 64, SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2" alpha:0.5];
    }
    return _lineView;
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
    titlesView.y =64;
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
    
    THNArticleViewController *article = [[THNArticleViewController alloc] init];
    article.title = @"文章";
    [self addChildViewController:article];
    
    THNActivityViewController *activity = [[THNActivityViewController alloc] init];
    activity.title = @"活动";
    [self addChildViewController:activity];
    
    THNXinPinViewController *xinPin = [[THNXinPinViewController alloc] init];
    xinPin.title = @"新品";
    [self addChildViewController:xinPin];
    
    THNSalesViewController *cuXiao = [[THNSalesViewController alloc] init];
    cuXiao.title = @"促销";
    [self addChildViewController:cuXiao];
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    vc.view.width = SCREEN_WIDTH;
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self titleClick:self.titlesView.subviews[index]];
}

@end
