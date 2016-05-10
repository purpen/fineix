//
//  FiltersViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiltersViewController.h"
#import "ReleaseViewController.h"
#import "MarkGoodsViewController.h"
#import "AddUrlViewController.h"

#import "FBFilters.h"

@interface FiltersViewController () <FBFootViewDelegate>

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setFiltersControllerUI];
    
    [self setNotification];

}

- (void)changeFilter:(NSNotification *)filterName {
    UIImage * showFilterImage = [[FBFilters alloc] initWithImage:self.filtersImg filterName:[filterName object]].filterImg;
    self.filtersImageView.image = showFilterImage;
}

#pragma mark - 设置视图UI
- (void)setFiltersControllerUI {
    NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝ 创建的类型：%@", self.createType);
    
    [self setNavViewUI];
    
    self.filtersImageView.image = self.filtersImg;
    [self.view addSubview:self.filtersImageView];
    [_filtersImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.67, SCREEN_HEIGHT - 220));
        make.top.equalTo(self.view.mas_top).with.offset(50);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.footView];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.filtersView];
    
    //  判断是情景/场景
    if ([self.createType isEqualToString:@"scene"]) {
        [self addNavViewTitle:NSLocalizedString(@"filtersVcTitle", nil)];
    
    } else if ([self.createType isEqualToString:@"fScene"]) {
        [self addNavViewTitle:NSLocalizedString(@"filterVcTitle", nil)];
        [self.footView removeFromSuperview];
        CGRect filtersViewRect = _filtersView.frame;
        filtersViewRect = CGRectMake(0, SCREEN_HEIGHT - 120, SCREEN_WIDTH, 120);
        _filtersView.frame = filtersViewRect;
    }

}

#pragma mark - 底部的工具栏
- (FBFootView *)footView {
    if (!_footView) {
        _footView = [[FBFootView alloc] init];
        NSArray * titleArr = [[NSArray alloc] initWithObjects:NSLocalizedString(@"marker", nil), NSLocalizedString(@"addUrl", nil), NSLocalizedString(@"filter", nil), nil];
        _footView.backgroundColor = [UIColor blackColor];
        _footView.titleArr = titleArr;
        _footView.titleFontSize = Font_GroupHeader;
        _footView.btnBgColor = [UIColor blackColor];
        _footView.titleNormalColor = [UIColor whiteColor];
        _footView.titleSeletedColor = [UIColor whiteColor];
        [_footView addFootViewButton];
        _footView.delegate = self;
    }
    return _footView;
}

- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    MarkGoodsViewController * markGoodsVC = [[MarkGoodsViewController alloc] init];
    AddUrlViewController * addUrlVC = [[AddUrlViewController alloc] init];
    
    if (index == 0) {
        [self presentViewController:markGoodsVC animated:YES completion:nil];
        
    } else if (index == 1) {
        [self presentViewController:addUrlVC animated:YES completion:nil];
        addUrlVC.findGodosBlock = ^(NSString * title, NSString * price) {
            NSLog(@"＝＝＝＝＝＝＝ 找到的商品标题：%@ －－－－－ 价格：%@ ------", title, price);
            
        };
        
    } else if (index == 2) {
        CGRect filtersViewRect = _filtersView.frame;
        filtersViewRect = CGRectMake(0, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 120);
        [UIView animateWithDuration:.2 animations:^{
            _filtersView.frame = filtersViewRect;
        }];
    }
}

#pragma mark - 处理图片的视图
- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] init];
    }
    return _filtersImageView;
}

#pragma mark - 滤镜视图
- (FiltersView *)filtersView {
    if (!_filtersView) {
        _filtersView = [[FiltersView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 120)];
    }
    return _filtersView;
}

#pragma mark - 使滤镜视图消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGRect filtersViewRect = _filtersView.frame;
    filtersViewRect = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 120);
    [UIView animateWithDuration:.2 animations:^{
        _filtersView.frame = filtersViewRect;
    }];
}


#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    [self addBackButton:@"icon_back_white"];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
}

#pragma mark 继续按钮的点击事件
- (void)nextBtnClick {
    ReleaseViewController * releaseVC = [[ReleaseViewController alloc] init];
    releaseVC.locationArr = self.locationArr;
    releaseVC.scenceView.imageView.image = self.filtersImageView.image;
    releaseVC.createType = self.createType;
    releaseVC.fSceneId = self.fSceneId;
    releaseVC.fSceneTitle = self.fSceneTitle;
    releaseVC.goodsTitle = @"测试商品1,测试商品2,测试商品3";
    releaseVC.goodsPrice = @"321,1829,2901";
    releaseVC.goodsId = @"304,301,299";
    releaseVC.goodsX = @"43,32,65";
    releaseVC.goodsY = @"20,22,42";
    [self.navigationController pushViewController:releaseVC animated:YES];
    
}

#pragma mark - 接收消息通知
- (void)setNotification {
    //  from "FiltersView.m"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFilter:) name:@"fitlerName" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fitlerName" object:nil];
}

@end
