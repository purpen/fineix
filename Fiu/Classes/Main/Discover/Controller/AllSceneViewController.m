//
//  AllSceneViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AllSceneViewController.h"
#import "PictureToolViewController.h"

@interface AllSceneViewController ()

@end

@implementation AllSceneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAllSceneViewUI];
    
}

#pragma mark - 
- (void)setAllSceneViewUI {
    [self.view addSubview:self.allSceneList];
}

#pragma mark - 情景列表
- (AllSceneView *)allSceneList {
    if (!_allSceneList) {
        _allSceneList = [[AllSceneView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        
        _allSceneList.allSceneView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
        }];
        
        _allSceneList.allSceneView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
        }];
    }
    return _allSceneList;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"AllSceneVcTitle", nil);
    self.delegate = self;
    [self addBarItemRightBarButton:@"" image:@"icon_newScene" isTransparent:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

//  点击右边barItem
- (void)rightBarItemSelected {
    PictureToolViewController * pictureToolVC = [[PictureToolViewController alloc] init];
    pictureToolVC.createType = @"fScene";
    [self presentViewController:pictureToolVC animated:YES completion:nil];
}

@end
