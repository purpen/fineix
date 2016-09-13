//
//  THNSceneImageViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneImageViewController.h"

@interface THNSceneImageViewController () {
    UIImage *_sceneImage;
}

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
    _sceneImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
    [self addGestureRecognizer];
    [self.view addSubview:self.imageView];
    [self.imageView displayImage:_sceneImage];
}

#pragma mark - 添加手势操作
- (void)addGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC:)];
    [self.view addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [self.imageView addGestureRecognizer:longPress];
}

- (void)dismissVC:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UILongPressGestureRecognizer *)loogPress {
    switch (loogPress.state) {
        case UIGestureRecognizerStateBegan:
            [self showSaveImageMess];
            break;
            
        case UIGestureRecognizerStateEnded:
            break;
            
        default:
            break;
    }
}

#pragma mark - 保存图片提示框
- (void)showSaveImageMess {
    TYAlertView *saveAlertView = [TYAlertView alertViewWithTitle:@"是否保存图片到本地？" message:@""];
    [saveAlertView addAction:[TYAlertAction actionWithTitle:@"取消" style:(TYAlertActionStyleCancle) handler:^(TYAlertAction *action) {

    }]];
    [saveAlertView addAction:[TYAlertAction actionWithTitle:@"确定" style:(TYAlertActionStyleDefault) handler:^(TYAlertAction *action) {
        UIImageWriteToSavedPhotosAlbum(_sceneImage,
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
        
    }]];
    [saveAlertView showInWindowWithBackgoundTapDismissEnable:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL){
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

#pragma mark - 情境大图
- (THNSceneImageScrollView *)imageView {
    if (!_imageView) {
        _imageView = [[THNSceneImageScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
}

@end
