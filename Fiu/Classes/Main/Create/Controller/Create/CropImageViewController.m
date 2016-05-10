//
//  CropImageViewController.m
//  fineix
//
//  Created by FLYang on 16/3/3.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CropImageViewController.h"
#import "ClipImageViewController.h"
#import "FiltersViewController.h"


@interface CropImageViewController ()


@end

@implementation CropImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    [self setNavViewUI];
    
    [self addChildViewController:self.clipImageVC];
}

#pragma mark - 设置页面导航Nav
- (void)setNavViewUI {
    [self addNavViewTitle:NSLocalizedString(@"cropVcTitle", nil)];
    [self addBackButton:@"icon_back_white"];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

//  “继续”
- (void)nextBtnClick {
    FiltersViewController * filtersVC = [[FiltersViewController alloc] init];
    filtersVC.locationArr = self.locationArr;
    filtersVC.filtersImg = [self.clipImageVC clippingImage];
    filtersVC.createType = self.createType;
    filtersVC.fSceneId = self.fSceneId;
    filtersVC.fSceneTitle = self.fSceneTitle;
    [self.navigationController pushViewController:filtersVC animated:YES];
}

#pragma mark - 设置裁剪视图
- (ClipImageViewController *)clipImageVC {
    if (!_clipImageVC) {
        _clipImageVC = [[ClipImageViewController alloc] init];
        
        _clipImageVC.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
        _clipImageVC.clipImgRect = CGRectMake((SCREEN_WIDTH - (SCREEN_WIDTH * 0.925))/2, 0, SCREEN_WIDTH * 0.925, SCREEN_HEIGHT - 50);  //  裁剪的大小
        
        UIImageView * coverView = [[UIImageView alloc] initWithFrame:_clipImageVC.clipImgRect];
        [_clipImageVC.view addSubview:coverView];
        [_clipImageVC.clipImageView setNeedsDisplay];
        [self.view addSubview:_clipImageVC.view];
    }
    return _clipImageVC;
}

@end
