//
//  THNGoodsQRCodeViewController.m
//  Fiu
//
//  Created by FLYang on 2017/5/5.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNGoodsQRCodeViewController.h"
#import "UIImage+QRCode.h"

@interface THNGoodsQRCodeViewController ()

@end

@implementation THNGoodsQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setViewUI];
}

- (void)thn_setViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    
    [self.view addSubview:self.mainView];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(270, 335));
        make.centerY.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34, 34));
        make.top.equalTo(_mainView.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view);
    }];
}

- (THNQRCodeView *)mainView {
    if (!_mainView) {
        _mainView = [[THNQRCodeView alloc] init];
        if (self.oLinkUrl.length) {
            [_mainView thn_setShareQRCodeInfoImage:[UIImage creatQRCodeImageForLinkUrl:self.oLinkUrl width:170] link:self.linkUrl];
        } else {
            [_mainView thn_setShareQRCodeInfoImage:[UIImage creatQRCodeImageForLinkUrl:self.linkUrl width:170] link:self.linkUrl];
        }
    }
    return _mainView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"share_close"] forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (void)closeButtonClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
