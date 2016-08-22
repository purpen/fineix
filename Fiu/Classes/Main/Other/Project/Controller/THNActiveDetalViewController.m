//
//  THNActiveDetalViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActiveDetalViewController.h"
#import "THNCuXiaoCollectionViewCell.h"
#import "THNArticleModel.h"
#import "UIView+FSExtension.h"
#import <UIImageView+WebCache.h>
#import "THNActiveRuleViewController.h"
#import "THNAttendSenceViewController.h"
#import "THNActiveResultViewController.h"

@interface THNActiveDetalViewController ()<UIScrollViewDelegate>

/**  */
@property (nonatomic, strong) UIScrollView *contentView;
/**  */
@property (nonatomic, strong) UIView *topView;
/**  */
@property (nonatomic, strong) THNCuXiaoCollectionViewCell *topCell;
/**  */
@property (nonatomic, strong) UIView *titlesView;
/**  */
@property (nonatomic, strong) UIView *indicatorView;
/**  */
@property (nonatomic, strong) UIButton *selectedButton;
/**  */
@property (nonatomic, strong) UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation THNActiveDetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navViewTitle.text = @"活动详情";
    
    self.titleLabel.text = self.model.title;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.model.cover_url] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_420"]];
    // 初始化子控制器
    [self setupChildVces];
    // 设置顶部的标签栏
    [self setupTitlesView];
    // 底部的scrollView
    [self setupContentView];
    [self.view addSubview:self.lineView];
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5 + 64 + 211, SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2" alpha:0.5];
    }
    return _lineView;
}

/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = CGRectMake(0, 64 + 211 + 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 211 - 50);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.showsHorizontalScrollIndicator = NO;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
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


/**
 * 设置顶部的标签栏
 */
- (void)setupTitlesView
{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    titlesView.width = SCREEN_WIDTH;
    titlesView.height = 50;
    titlesView.y = 64 + 211;
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


/**
 * 初始化子控制器
 */
- (void)setupChildVces
{
    
    THNActiveRuleViewController *activeRule = [[THNActiveRuleViewController alloc] init];
    activeRule.title = @"活动规则";
    activeRule.id = self.id;
    [self addChildViewController:activeRule];
    
    THNAttendSenceViewController *attendSence = [[THNAttendSenceViewController alloc] init];
    attendSence.title = @"参与的情境";
    attendSence.id = self.id;
    [self addChildViewController:attendSence];
    
    if (self.model.evt == 2) {
        THNActiveResultViewController *xinPin = [[THNActiveResultViewController alloc] init];
        xinPin.id = self.id;
        xinPin.title = @"活动结果";
        [self addChildViewController:xinPin];
    }
    
}


@end
