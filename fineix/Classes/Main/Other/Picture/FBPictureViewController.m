//
//  FBPictureViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "UIView+TYAlertView.h"

@interface FBPictureViewController ()

@end

@implementation FBPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
}

#pragma mark - 隐藏系统状态栏
//  iOS7.0以后
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - 添加控件
//  页面标题
- (void)addNavViewTitle:(NSString *)title {
    self.navTitle.text = title;
    [self.navView addSubview:self.navTitle];
}

//  打开相薄
- (void)addOpenPhotoAlbumsButton {
    [self.navView addSubview:self.openPhotoAlbums];
}

//  取消创建按钮
- (void)addCancelButton {
    [self.navView addSubview:self.cancelBtn];
}

//  继续下一步
- (void)addNextButton {
    [self.navView addSubview:self.nextBtn];
}

//  返回上一步
- (void)addBackButton {
    [self.navView addSubview:self.backBtn];
}

//  发布按钮
- (void)addDoneButton {
    [self.navView addSubview:self.doneBtn];
}

//  取消发布
- (void)addCancelDoneButton {
    [self.navView addSubview:self.cancelDoneBtn];
}

//  分割线
- (void)addLine {
    [self.navView addSubview:self.line];
}

#pragma mark - 顶部滚动的导航
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _navView.backgroundColor = [UIColor colorWithHexString:pictureNavColor alpha:1];
    }
    return _navView;
}

#pragma mark -  页面的标题
- (UILabel *)navTitle {
    if (!_navTitle) {
        _navTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, (SCREEN_WIDTH - 100), 50)];
        _navTitle.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        _navTitle.textColor = [UIColor whiteColor];
        _navTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _navTitle;
}

#pragma mark - Nav跟内容的分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:@"#F0F0F1" alpha:1];
    }
    return _line;
}

#pragma mark - 继续下一步的执行事件
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_nextBtn setTitle:@"继续" forState:(UIControlStateNormal)];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];

    }
    return _nextBtn;
}

#pragma mark - 返回上一步的执行事件 
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:(UIControlStateNormal)];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backBtn;
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置取消创建场景按钮
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_cancelBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置发布场景景按钮
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_doneBtn setTitle:@"发布" forState:(UIControlStateNormal)];
        [_doneBtn setTitleColor:[UIColor colorWithHexString:color alpha:1] forState:(UIControlStateNormal)];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
    }
    return _doneBtn;
}

#pragma mark - 取消发布按钮
- (UIButton *)cancelDoneBtn {
    if (!_cancelDoneBtn) {
        _cancelDoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_cancelDoneBtn setImage:[UIImage imageNamed:@"icon_back"] forState:(UIControlStateNormal)];
        [_cancelDoneBtn addTarget:self action:@selector(cancelDoneBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelDoneBtn;
}

- (void)cancelDoneBtnClick {
    NSLog(@"取消发布");
    TYAlertView * cancelAlertView = [TYAlertView alertViewWithTitle:@"取消创建" message:@"是否放弃创建情景？"];
    [cancelAlertView addAction:[TYAlertAction actionWithTitle:@"返回上一步" style:(TYAlertActionStyleCancle) handler:^(TYAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [cancelAlertView addAction:[TYAlertAction actionWithTitle:@"确定" style:(TYAlertActionStyleDefault) handler:^(TYAlertAction *action) {
         [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [cancelAlertView showInWindowWithBackgoundTapDismissEnable:YES];
}

#pragma mark - 页面提示框
- (void)showMessage:(NSString *)message {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    [showview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200,44));
        make.bottom.equalTo(window.mas_bottom).with.offset(-100);
        make.centerX.equalTo(window);
    }];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 200, 44)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    [showview addSubview:label];
    
    [UIView animateWithDuration:2.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

#pragma mark - 打开相薄
- (UIButton *)openPhotoAlbums {
    if (!_openPhotoAlbums) {
        _openPhotoAlbums = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 0, 110, 50)];
        [_openPhotoAlbums setImage:[UIImage imageNamed:@"icon_down"] forState:(UIControlStateNormal)];
        [_openPhotoAlbums setImage:[UIImage imageNamed:@"icon_upward"] forState:(UIControlStateSelected)];
        [_openPhotoAlbums setImageEdgeInsets:(UIEdgeInsetsMake(0, 90, 0, 0))];
        _openPhotoAlbums.selected = NO;
    }
    return _openPhotoAlbums;
}


@end
