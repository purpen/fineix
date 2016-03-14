//
//  CreateViewController.m
//  fineix
//
//  Created by FLYang on 16/2/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CreateViewController.h"
#import "CropImageViewController.h"

@interface CreateViewController () <FBFootViewDelegate>

@end

@implementation CreateViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setCreateControllerUI];
    
    if (self.pictureView.hidden == YES) {
        if (self.cameraView.session) {
            [self.cameraView.session startRunning];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavViewUI];

}

#pragma mark - 设置顶部Nav
- (void)setNavViewUI {
    [self addNavViewTitle:@"照片胶卷"];
    [self addCancelButton];
    [self addOpenPhotoAlbumsButton];
    [self.openPhotoAlbums addTarget:self action:@selector(openPhotoAlbumsClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 点击“继续”
- (void)nextButtonClick:(UIImage *)image {
    CropImageViewController * cropVC = [[CropImageViewController alloc] init];
    cropVC.clipImageVC.clipImage = self.pictureView.photoImgView.image;
    cropVC.view.frame = self.view.frame;
    [self.navigationController pushViewController:cropVC animated:YES];
}

#pragma mark - 打开相册列表
- (void)openPhotoAlbumsClick {
    if (self.openPhotoAlbums.selected == YES) {
        self.openPhotoAlbums.selected = NO;
        CGRect openPhotoAlbumsRect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-50);
        [UIView animateWithDuration:.3 animations:^{
            self.pictureView.photoAlbumsView.frame = openPhotoAlbumsRect;
        }];
        
    } else if (self.openPhotoAlbums.selected == NO){
        self.openPhotoAlbums.selected = YES;
        CGRect openPhotoAlbumsRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50);
        [UIView animateWithDuration:.3 animations:^{
            self.pictureView.photoAlbumsView.frame = openPhotoAlbumsRect;
        }];
    }
}

#pragma mark - 创建页面UI
- (void)setCreateControllerUI {
    [self.view addSubview:self.footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.pictureView];
    
}

#pragma mark - 底部选项工具栏
- (FBFootView *)footView {
    if (!_footView) {
        NSArray * arr = [NSArray arrayWithObjects:@"相册", @"拍照", nil];
        _footView = [[FBFootView alloc] init];
        _footView.backgroundColor = [UIColor blackColor];
        _footView.titleArr = arr;
        _footView.titleFontSize = Font_ControllerTitle;
        _footView.btnBgColor = [UIColor blackColor];
        _footView.titleNormalColor = [UIColor whiteColor];
        _footView.titleSeletedColor = [UIColor colorWithHexString:color alpha:1];
        [_footView addFootViewButton];
        [_footView showLineWithButton];
        _footView.delegate = self;
    }
    return _footView;
}

#pragma mark 底部选项的点击事件
- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    if (index == 1) {
        if (self.cameraView.session) {
            [self.cameraView.session startRunning];
        }
        self.pictureView.hidden = YES;
        [self.view addSubview:self.cameraView];
        
    } else if (index == 0) {
        if (self.cameraView.session) {
            [self.cameraView.session stopRunning];
        }
        [self.cameraView removeFromSuperview];
        self.pictureView.hidden = NO;

    }
}

#pragma mark - 相册的页面
- (PictureView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[PictureView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
        _pictureView.navView = self.navView;
    }
    return _pictureView;
}

#pragma mark - 打开相机的页面
- (CameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
        _cameraView.VC = self;
        _cameraView.Nav = self.navigationController;
    }
    return _cameraView;
}

#pragma mark - 停止运行相机
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.cameraView.session) {
        [self.cameraView.session stopRunning];
    }
}


@end
