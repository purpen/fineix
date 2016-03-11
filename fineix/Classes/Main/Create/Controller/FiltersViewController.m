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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFilter:) name:@"fitlerName" object:nil];
}

- (void)changeFilter:(NSNotification *)filterName {
    UIImage * showFilterImage = [[FBFilters alloc] initWithImage:self.filtersImg filterName:[filterName object]].filterImg;
    self.filtersImageView.image = showFilterImage;
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    [self addNavViewTitle:@"工具"];
    [self addBackButton];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];

}

#pragma mark 继续按钮的点击事件
- (void)nextBtnClick {
    ReleaseViewController * releaseVC = [[ReleaseViewController alloc] init];
    releaseVC.scenceView.imageView.image = self.filtersImageView.image;
    [self.navigationController pushViewController:releaseVC animated:YES];
}

#pragma mark - 设置视图UI
- (void)setFiltersControllerUI {
    
    [self setNavViewUI];
    
    self.filtersImageView.image = self.filtersImg;
    [self.view addSubview:self.filtersImageView];
    [_filtersImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 1.33));
        make.top.equalTo(self.view.mas_top).with.offset(50);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.footView];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - 底部的工具栏
- (FBFootView *)footView {
    if (!_footView) {
        _footView = [[FBFootView alloc] init];
        NSArray * titleArr = [[NSArray alloc] initWithObjects:@"标记产品",@"添加链接",@"滤镜", nil];
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
        [self.filtersView removeFromSuperview];
        
    } else if (index == 1) {
        [self presentViewController:addUrlVC animated:YES completion:nil];
        [self.filtersView removeFromSuperview];
        
    } else if (index == 2) {
        [self.view addSubview:self.cancelFilter];
        
        [self.view addSubview:self.filtersView];
        [_filtersView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 120));
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
            make.centerX.equalTo(self.view);
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
        _filtersView = [[FiltersView alloc] init];
    }
    return _filtersView;
}

#pragma mark - 使滤镜视图消失
- (UIButton *)cancelFilter {
    if (!_cancelFilter) {
        _cancelFilter = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
        [_cancelFilter addTarget:self action:@selector(cancelFilterView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelFilter;
}

- (void)cancelFilterView {
    [self.filtersView removeFromSuperview];
    [self.cancelFilter removeFromSuperview];
}

#pragma mark - 获取照片所在位置
- (void)setPhotoLocation {
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    CLLocation * location = [[CLLocation alloc] initWithLatitude:39.982975 longitude:116.4924166666667];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            
            /** CLPlacemark         地标
             *  location            位置对象
             *  addressDictionary   地址字典
             *  name                地址详情
             *  locality            城市
             */
            
            CLPlacemark * pl = [placemarks firstObject];
            NSLog(@"＝＝＝＝%@ %@",pl.locality, pl.name);
            
        } else {
            NSLog(@"获取地理位置出错");
        }
        
    }];
}


@end
