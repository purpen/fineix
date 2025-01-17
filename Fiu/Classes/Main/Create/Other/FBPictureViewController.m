//
//  FBPictureViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "UIView+TYAlertView.h"
#import "THNUserData.h"
#import "THNMacro.h"

@interface FBPictureViewController ()

@end

@implementation FBPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navView];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    if (Is_iPhoneX) {
        self.navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 88);
    }
}

#pragma mark - 获取用户登录id
- (NSString *)getLoginUserID {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    return userdata.userId;
}

#pragma mark - 添加控件
//  页面标题
- (void)addNavViewTitle:(NSString *)title {
    self.navTitle.text = title;
    
    [self.navView addSubview:self.navTitle];
    [_navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 45));
        make.centerX.equalTo(_navView);
        make.bottom.equalTo(_navView.mas_bottom).with.offset(0);
    }];
}

//  打开相薄
- (void)addOpenPhotoAlbumsButton:(NSString *)title {
    [self.openPhotoAlbums setTitle:title forState:(UIControlStateNormal)];
    [self.navView addSubview:self.openPhotoAlbums];
    [_openPhotoAlbums mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 45));
        make.centerX.equalTo(self.navView.mas_centerX).with.offset(-10);
        make.bottom.equalTo(self.navView.mas_bottom).with.offset(0);
    }];
}

- (void)getPhotoAlbumsTitleSize:(NSString *)title {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGFloat titleW = [title boundingRectWithSize:CGSizeMake(320, 0)
                                         options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size.width;
    
    [_openPhotoAlbums setImageEdgeInsets:(UIEdgeInsetsMake(0, (titleW+20)*2, 0, 0))];
}

//  取消创建按钮
- (void)addCancelButton:(NSString *)image {
    [self.cancelBtn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [self.navView addSubview:self.cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.equalTo(_navView.mas_left).with.offset(0);
        make.bottom.equalTo(_navView.mas_bottom).with.offset(0);
    }];
}

//  继续下一步
- (void)addNextButton {
    [self.navView addSubview:self.nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.right.equalTo(_navView.mas_right).with.offset(-5);
        make.bottom.equalTo(_navView.mas_bottom).with.offset(0);
    }];
}

//  返回上一步
- (void)addBackButton:(NSString *)image {
    [self.backBtn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [self.navView addSubview:self.backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.equalTo(_navView.mas_left).with.offset(0);
        make.bottom.equalTo(_navView.mas_bottom).with.offset(0);
    }];
}

//  发布按钮
- (void)addDoneButton {
    [self.navView addSubview:self.doneBtn];
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.right.equalTo(_navView.mas_right).with.offset(-5);
        make.bottom.equalTo(_navView.mas_bottom).with.offset(0);
    }];
}

//  关闭按钮
- (void)addCloseBtn:(NSString *)image {
    [self.closeBtn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [self.navView addSubview:self.closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.equalTo(_navView.mas_left).with.offset(0);
        make.bottom.equalTo(_navView.mas_bottom).with.offset(0);
    }];
}

//  确定
- (void)addSureButton {
    [self.navView addSubview:self.sureButton];
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.right.equalTo(_navView.mas_right).with.offset(-5);
        make.bottom.equalTo(_navView.mas_bottom).with.offset(0);
    }];
}

//  取消发布
- (void)addCancelDoneButton {
    [self.navView addSubview:self.cancelDoneBtn];
    [_cancelDoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.equalTo(_navView.mas_left).with.offset(0);
        make.bottom.equalTo(_navView.mas_bottom).with.offset(0);
    }];
}

//  分割线
- (void)addLine {
    [self.navView addSubview:self.line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        make.left.equalTo(_navView.mas_left).with.offset(0);
        make.bottom.equalTo(_navView.mas_bottom).with.offset(0);
    }];
}

#pragma mark - 顶部导航
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _navView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    }
    return _navView;
}

#pragma mark - 页面的标题
- (UILabel *)navTitle {
    if (!_navTitle) {
        _navTitle = [[UILabel alloc] init];
        _navTitle.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        _navTitle.textColor = [UIColor whiteColor];
        _navTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _navTitle;
}

#pragma mark - Nav跟内容的分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:lineGrayColor alpha:1];
    }
    return _line;
}

#pragma mark - 继续下一步的执行事件
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setTitle:NSLocalizedString(@"next", nil) forState:(UIControlStateNormal)];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
    }
    return _nextBtn;
}

#pragma mark - 返回上一步的执行事件 
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backBtn;
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 关闭
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 确定
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_sureButton setTitle:NSLocalizedString(@"sure", nil) forState:(UIControlStateNormal)];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
    }
    return _sureButton;
}

- (void)sureButtonClick {
    if ([self.delegate respondsToSelector:@selector(thn_sureButtonAction)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate thn_sureButtonAction];
        }];
    }
}

#pragma mark - 设置取消创建场景按钮
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
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
        [_doneBtn setTitle:NSLocalizedString(@"release", nil) forState:(UIControlStateNormal)];
        [_doneBtn setTitleColor:[UIColor colorWithHexString:fineixColor alpha:1] forState:(UIControlStateNormal)];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
    }
    return _doneBtn;
}

#pragma mark - 取消发布按钮
- (UIButton *)cancelDoneBtn {
    if (!_cancelDoneBtn) {
        _cancelDoneBtn = [[UIButton alloc] init];
        [_cancelDoneBtn setImage:[UIImage imageNamed:@"icon_back"] forState:(UIControlStateNormal)];
        [_cancelDoneBtn addTarget:self action:@selector(cancelDoneBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelDoneBtn;
}

- (void)cancelDoneBtnClick {
    TYAlertView *cancelAlertView = [TYAlertView alertViewWithTitle:@"是否返回上一步？" message:@""];
    cancelAlertView.layer.cornerRadius = 10;
    cancelAlertView.buttonDefaultBgColor = [UIColor colorWithHexString:fineixColor];
    cancelAlertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#999999"];
    [cancelAlertView addAction:[TYAlertAction actionWithTitle:@"取消创建" style:(TYAlertActionStyleCancel) handler:^(TYAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [cancelAlertView addAction:[TYAlertAction actionWithTitle:@"确定" style:(TYAlertActionStyleDefault) handler:^(TYAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
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
    label.font = [UIFont systemFontOfSize:14];
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
        _openPhotoAlbums = [[UIButton alloc] init];
        [_openPhotoAlbums setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_openPhotoAlbums setImage:[UIImage imageNamed:@"icon_down"] forState:(UIControlStateNormal)];
        [_openPhotoAlbums setImage:[UIImage imageNamed:@"icon_upward"] forState:(UIControlStateSelected)];
        _openPhotoAlbums.titleLabel.font = [UIFont systemFontOfSize:17];
        _openPhotoAlbums.selected = NO;
        _openPhotoAlbums.clipsToBounds = YES;
    }
    return _openPhotoAlbums;
}

#pragma mark - 添加引导图
- (void)setGuideImgForVC:(NSString *)image {
    UIButton * guideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [guideBtn setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [guideBtn addTarget:self action:@selector(removeGuide:) forControlEvents:(UIControlEventTouchUpInside)];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:guideBtn];
}

- (void)removeGuide:(UIButton *)button {
    [button removeFromSuperview];
}

@end
