//
//  CreateViewController.m
//  fineix
//
//  Created by FLYang on 16/2/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CreateViewController.h"
#import "SceneAddViewController.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setFirstAppStart];
    
    if ([self isAllowMedia]) {
        if (self.pictureView.hidden == YES) {
            if (self.cameraView.session) {
                [self.cameraView.session startRunning];
            }
        }
    }
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCreateControllerUI];
}

#pragma mark - 应用第一次打开，加载操作指示图
- (void)setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"creatLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"creatLaunch"];
        [self setGuideImgForVC:@"Guide_photo"];
    }
}

#pragma mark - 设置顶部Nav
- (void)setNavViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    [self addNavViewTitle:NSLocalizedString(@"createVcTitle", nil)];
    [self addCancelButton:@"icon_cancel"];
    [self addOpenPhotoAlbumsButton];
    [self.openPhotoAlbums addTarget:self action:@selector(openPhotoAlbumsClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 点击“继续”
- (void)nextButtonClick:(UIImage *)image {
    SceneAddViewController * addVC = [[SceneAddViewController alloc] init];
    addVC.locationArr = self.pictureView.locationArr;
    addVC.filtersImg = self.pictureView.photoImgView.image;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - 打开相册列表
- (void)openPhotoAlbumsClick {
    if (self.openPhotoAlbums.selected == YES) {
        self.openPhotoAlbums.selected = NO;
        CGRect openPhotoAlbumsRect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-45);
        [UIView animateWithDuration:.3 animations:^{
            self.pictureView.photoAlbumsView.frame = openPhotoAlbumsRect;
            self.nextBtn.hidden = NO;
        }];
        
    } else if (self.openPhotoAlbums.selected == NO){
        self.openPhotoAlbums.selected = YES;
        CGRect openPhotoAlbumsRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-45);
        [UIView animateWithDuration:.3 animations:^{
            self.pictureView.photoAlbumsView.frame = openPhotoAlbumsRect;
            self.nextBtn.hidden = YES;
        }];
    }
}

#pragma mark - 创建页面UI
- (void)setCreateControllerUI {
    [self.view addSubview:self.footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.pictureView];
}

#pragma mark - 底部选项工具栏
- (FBFootView *)footView {
    if (!_footView) {
        NSArray * arr = [NSArray arrayWithObjects:NSLocalizedString(@"album", nil), NSLocalizedString(@"camera", nil), nil];
        _footView = [[FBFootView alloc] init];
        _footView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleArr = arr;
        _footView.titleFontSize = Font_ControllerTitle;
        _footView.btnBgColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleNormalColor = [UIColor whiteColor];
        _footView.titleSeletedColor = [UIColor colorWithHexString:fineixColor alpha:1];
        [_footView addFootViewButton];
        [_footView showLineWithButton];
        _footView.delegate = self;
    }
    return _footView;
}

#pragma mark 底部选项的点击事件
- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    if (index == 1) {
        if ([self isAllowMedia]) {
            if (self.cameraView.session) {
                [self.cameraView.session startRunning];
            }
            self.pictureView.hidden = YES;
            [self.view addSubview:self.cameraView];
        }
        
    } else if (index == 0) {
        if (self.cameraView.session) {
            [self.cameraView.session stopRunning];
        }
        [self.cameraView removeFromSuperview];
        self.pictureView.hidden = NO;

    }
}

- (BOOL)isAllowMedia{
    BOOL isMedia;
    NSString *mediaMessage = @"请在设置->隐私->相机 中打开本应用的访问权限";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        isMedia = NO;
    }else{
        isMedia = YES;
    }
    if (!isMedia) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:mediaMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 7;
        alertView.delegate = self;
        [alertView show];
    }
    return isMedia;
}

#pragma mark - 相册的页面
- (PictureView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[PictureView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 90)];
        _pictureView.navView = self.navView;
        _pictureView.photoAlbumsView.photoAlbumsBtn = self.openPhotoAlbums;
        _pictureView.photoAlbumsView.nextBtn = self.nextBtn;
        //  from "PhotoAlbumsView.h"
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewTitle:) name:@"PhotoAlbumsName" object:nil];
    }
    return _pictureView;
}

- (void)changeViewTitle:(NSNotification *)title {
    self.navTitle.text = [title object];
}

#pragma mark - 打开相机的页面
- (CameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PhotoAlbumsName" object:nil];
}


@end
