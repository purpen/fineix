//
//  FBPictureViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"

#define nextBtnTag 66
#define backBtnTag 77

@interface FBPictureViewController ()

@end

@implementation FBPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.navRollView];
    
}

#pragma mark - 隐藏系统状态栏
//  iOS7.0以后
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - 顶部滚动的导航
//  滚动视图
- (UIScrollView *)navRollView {
    if (!_navRollView) {
        _navRollView = [[UIScrollView alloc] init];
        _navRollView.backgroundColor = [UIColor colorWithHexString:pictureNavColor alpha:1];
        _navRollView.showsHorizontalScrollIndicator = NO;
        _navRollView.showsVerticalScrollIndicator = NO;
        _navRollView.bounces = NO;
    }
    return _navRollView;
}

- (void)addNavView:(NSMutableArray *)titleArr {
    _navRollView.frame = CGRectMake(0, 0, SCREEN_WIDTH * titleArr.count, 50);
    
    //  取消创建按钮
    [_navRollView addSubview:self.cancelBtn];
    
    //  页面的标题
    for (NSUInteger jdx = 0; jdx < titleArr.count; jdx ++) {
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50 + (SCREEN_WIDTH * jdx), 0, SCREEN_WIDTH - 100, 50)];
        titleLab.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = titleArr[jdx];
        
        [_navRollView addSubview:titleLab];
    }
    
    //  继续下一步按钮
    for (NSUInteger idx = 0; idx < titleArr.count - 1; idx ++) {
        UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60) + (SCREEN_WIDTH * idx), 0, 60, 50)];
        [nextBtn setTitle:@"继续" forState:(UIControlStateNormal)];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        nextBtn.tag = nextBtnTag + idx;
        [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_navRollView addSubview:nextBtn];
    }
    
    //  返回按钮
    for (NSUInteger kdx = 0; kdx < titleArr.count -1; kdx ++) {
        UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH + (SCREEN_WIDTH * kdx), 0, 60, 50)];
        [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:(UIControlStateNormal)];
        backBtn.tag = backBtnTag + kdx;
        [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_navRollView addSubview:backBtn];
    }
    
    //  发布创建按钮
    [_navRollView addSubview:self.doneBtn];
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 50));
        make.top.equalTo(self.navRollView.mas_top).with.offset(0);
        make.left.equalTo(self.navRollView.mas_left).with.offset(SCREEN_WIDTH * titleArr.count - 60);
    }];
    
}

#pragma mark - 继续下一步的执行事件
- (void)nextBtnClick:(UIButton *)nextButton {
    CGPoint navPoint = _navRollView.contentOffset;
    navPoint.x = SCREEN_WIDTH * (nextButton.tag - nextBtnTag +1);
    [UIView animateWithDuration:.3 animations:^{
        _navRollView.contentOffset = navPoint;
    }];
}

#pragma mark - 返回上一步的执行事件 
- (void)backBtnClick:(UIButton *)backButton {
    CGPoint navPoint = _navRollView.contentOffset;
    navPoint.x = SCREEN_WIDTH * (backButton.tag - backBtnTag);
    [UIView animateWithDuration:.3 animations:^{
        _navRollView.contentOffset = navPoint;
    }];
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
        _doneBtn = [[UIButton alloc] init];
        [_doneBtn setTitle:@"发布" forState:(UIControlStateNormal)];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
    }
    return _doneBtn;
}


@end
