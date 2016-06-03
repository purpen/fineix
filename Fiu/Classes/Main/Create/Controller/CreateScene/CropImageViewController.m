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
#import "SceneAddViewController.h"

@interface CropImageViewController ()


@end

@implementation CropImageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

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
    if ([self.createType isEqualToString:@"scene"]) {
        SceneAddViewController * sceneAddVC = [[SceneAddViewController alloc] init];
        sceneAddVC.locationArr = self.locationArr;
        sceneAddVC.filtersImg = [self.clipImageVC clippingImage];
        sceneAddVC.createType = self.createType;
        sceneAddVC.fSceneId = self.fSceneId;
        sceneAddVC.fSceneTitle = self.fSceneTitle;
        [self.navigationController pushViewController:sceneAddVC animated:YES];
        
    } else if ([self.createType isEqualToString:@"fScene"]) {
        FiltersViewController * filtersVC = [[FiltersViewController alloc] init];
        filtersVC.locationArr = self.locationArr;
        filtersVC.filtersImg = [self.clipImageVC clippingImage];
        filtersVC.createType = self.createType;
        filtersVC.fSceneId = self.fSceneId;
        filtersVC.fSceneTitle = self.fSceneTitle;
        [self.navigationController pushViewController:filtersVC animated:YES];
    }
}

#pragma mark - 设置裁剪视图
- (ClipImageViewController *)clipImageVC {
    if (!_clipImageVC) {
        _clipImageVC = [[ClipImageViewController alloc] init];
        _clipImageVC.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT + 50);
        _clipImageVC.clipImgRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);  //  裁剪的大小
        
        UIImageView * coverView = [[UIImageView alloc] initWithFrame:_clipImageVC.clipImgRect];
        [_clipImageVC.view addSubview:coverView];
        [_clipImageVC.clipImageView setNeedsDisplay];
        [self.view addSubview:_clipImageVC.view];
        [_clipImageVC.view sendSubviewToBack:self.view];
    }
    return _clipImageVC;
}

@end