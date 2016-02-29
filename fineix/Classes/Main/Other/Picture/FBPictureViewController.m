//
//  FBPictureViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"

@interface FBPictureViewController ()

@end

@implementation FBPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}

#pragma mark 隐藏系统状态栏
//  iOS7.0以后
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark 设置控制器UI界面
- (void)setUI {
    [self.view addSubview:self.navView];
    
}

#pragma mark 设置顶部Nav导航视图
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _navView.backgroundColor = [UIColor colorWithHexString:pictureNavColor alpha:1];
        
    }
    return _navView;
}

#pragma mark 设置取消创建情景按钮
- (void)addCancelBtn {
    [self.navView addSubview:self.cancelBtn];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

//  添加取消按钮
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _cancelBtn.backgroundColor = [UIColor redColor];
    }
    return _cancelBtn;
}

// 取消创建情景
- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 设置胶卷按钮
- (void)addPhotoAlbumBtn {
    [self.navView addSubview:self.photoAlbumBtn];
    [_photoAlbumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.top.equalTo(self.navView).with.offset(0);
        make.centerX.equalTo(self.navView);
    }];
}

//  添加胶卷按钮
- (UIButton *)photoAlbumBtn {
    if (!_photoAlbumBtn) {
        _photoAlbumBtn = [[UIButton alloc] init];
        [_photoAlbumBtn setTitle:@"照片胶卷" forState:(UIControlStateNormal)];
        [_photoAlbumBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _photoAlbumBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
    }
    return _photoAlbumBtn;
}

#pragma mark 设置继续下一步按钮
- (void)addNextBtn {
    [self.navView addSubview:self.nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70,50));
        make.top.equalTo(self.navView).with.offset(0);
        make.right.equalTo(self.navView.mas_right).with.offset(0);
    }];
}

//  添加继续下一步按钮
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setTitle:@"继续" forState:(UIControlStateNormal)];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
    }
    return _nextBtn;
}

@end
