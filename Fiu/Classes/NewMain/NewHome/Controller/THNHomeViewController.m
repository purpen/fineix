//
//  THNHomeViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHomeViewController.h"
#import "SearchViewController.h"
#import "SceneSubscribeViewController.h"

@interface THNHomeViewController ()

@end

@implementation THNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setFirstAppStart];
    [self setNavigationViewUI];
    
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor grayColor];
    self.delegate = self;
    [self addNavLogoImg];
    [self addBarItemLeftBarButton:@"" image:@"Nav_Search"];
    [self addBarItemRightBarButton:@"" image:@"Nav_Concern"];
    [self addQRBtn];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

- (void)leftBarItemSelected {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.searchType = 0;
    searchVC.beginSearch = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)rightBarItemSelected {
    SceneSubscribeViewController * sceneSubVC = [[SceneSubscribeViewController alloc] init];
    [self.navigationController pushViewController:sceneSubVC animated:YES];
}

#pragma mark - 首次打开加载指示图
- (void)setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"homeLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"homeLaunch"];
        [self setMoreGuideImgForVC:@[@"guide_home",@"Guide_index",@"guide-fiu",@"guide-personal"]];
    }
}

@end
