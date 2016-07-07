//
//  FiltersViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiltersViewController.h"
#import "ReleaseViewController.h"
#import "FBFilters.h"

@interface FiltersViewController () 

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setFiltersControllerUI];
    
    [self setNotification];
    
//    pg_edit_sdk_controller *editCtl = nil;
//    {
//        //构建编辑对象    Construct edit target
//        pg_edit_sdk_controller_object *obje = [[pg_edit_sdk_controller_object alloc] init];
//        {
//            //输入原图  Input original
//            obje.pCSA_fullImage = [self.filtersImg copy];
//        }
//        editCtl = [[pg_edit_sdk_controller alloc] initWithEditObject:obje withDelegate:self];
//    }
//    NSAssert(editCtl, @"Error");
//    if (editCtl) {
//        
//        [self.navigationController pushViewController:editCtl animated:YES];
//
//    }
}

//- (void)dgPhotoEditingViewControllerDidCancel:(UIViewController *)pController withClickSaveButton:(BOOL)isClickSaveBtn
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)dgPhotoEditingViewControllerShowLoadingView:(UIView *)view
//{
//    [SVProgressHUD show];
//}
//
//- (void)dgPhotoEditingViewControllerHideLoadingView:(UIView *)view
//{
//    [SVProgressHUD dismiss];
//}


#pragma mark - 应用第一次打开，加载操作指示图
- (void)setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"flitersLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"flitersLaunch"];
        [self setGuideImgForVC:@"Guide_stamp product"];
    }
}

- (void)changeFilter:(NSNotification *)filterName {
    UIImage * showFilterImage = [[FBFilters alloc] initWithImage:self.filtersImg filterName:[filterName object]].filterImg;
    self.filtersImageView.image = showFilterImage;
}

#pragma mark - 设置视图UI
- (void)setFiltersControllerUI {
    [self setNavViewUI];
    
    [self.view addSubview:self.filtersImageView];
    [self.view addSubview:self.filtersView];
}

#pragma mark - 处理图片的视图
- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _filtersImageView.image = self.filtersImg;
    }
    return _filtersImageView;
}

#pragma mark - 滤镜视图
- (FiltersView *)filtersView {
    if (!_filtersView) {
        _filtersView = [[FiltersView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 120, SCREEN_WIDTH, 120)];
    }
    return _filtersView;
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
    
    if ([self.createType isEqualToString:@"scene"]) {
        releaseVC.locationArr = self.locationArr;
        releaseVC.scenceView.imageView.image = self.filtersImageView.image;
        releaseVC.createType = self.createType;
        releaseVC.fSceneId = self.fSceneId;
        releaseVC.fSceneTitle = self.fSceneTitle;
        releaseVC.goodsTitle = self.goodsTitle;
        releaseVC.goodsPrice = self.goodsPrice;
        releaseVC.goodsId = self.goodsId;
        releaseVC.goodsX = self.goodsX;
        releaseVC.goodsY = self.goodsY;
        releaseVC.scenceView.type = self.createType;
        [self.navigationController pushViewController:releaseVC animated:YES];
    
    } else if ([self.createType isEqualToString:@"fScene"]) {
        releaseVC.locationArr = self.locationArr;
        releaseVC.scenceView.imageView.image = self.filtersImageView.image;
        releaseVC.createType = self.createType;
        [self.navigationController pushViewController:releaseVC animated:YES];
    }
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
