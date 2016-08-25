//
//  THNSceneImageViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneImageViewController.h"

@interface THNSceneImageViewController ()

@end

@implementation THNSceneImageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewUI];
}

- (void)setViewUI {
    self.view.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC:)];
    [self.view addGestureRecognizer:tap];
    
    [self.imageView downloadImage:self.image place:[UIImage imageNamed:@""]];
    
    [self.view addSubview:self.imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        make.centerY.centerX.equalTo(self.view);
    }];
}

- (void)dismissVC:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 情境大图
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
}

@end
