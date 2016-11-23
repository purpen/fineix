//
//  THNSceneImageViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneImageViewController.h"

static NSString *const URLUserIsEditor = @"/user/is_editor";
static NSString *const URLSceneFine = @"/user/do_fine";
static NSString *const URLSceneStick = @"/user/do_stick";
static NSString *const URLSceneCheck = @"/user/do_check";

@interface THNSceneImageViewController () {
    UIImage *_sceneImage;
    NSInteger _isEditor;
    NSString *_isFine;
    NSString *_isStick;
    NSString *_isCheck;
    NSString *_sceneFine;
    NSString *_sceneStick;
    NSString *_sceneCheck;
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
    
    if ([self isUserLogin]) {
        [self thn_networkUserIsEditor];
    }
}

- (void)thn_getSceneState:(NSInteger)fine stick:(NSInteger)stick check:(NSInteger)check {
    if (fine == 1) {
        _isFine = @"0";
        _sceneFine = @"取消精选";
    } else if (fine == 0) {
        _isFine = @"1";
        _sceneFine = @"精选";
    }
    
    if (stick == 1) {
        _isStick = @"0";
        _sceneStick = @"取消推荐";
    } else if (stick == 0) {
        _isStick = @"1";
        _sceneStick = @"推荐";
    }
    
    if (check == 1) {
        _isCheck = @"0";
        _sceneCheck = @"屏蔽";
    } else if (stick == 0) {
        _isCheck = @"1";
        _sceneCheck = @"取消屏蔽";
    }
}

#pragma mark - 网络请求
#pragma mark 获取用户编辑权限
- (void)thn_networkUserIsEditor {
    self.userRequest = [FBAPI getWithUrlString:URLUserIsEditor requestDictionary:@{} delegate:self];
    [self.userRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"=== %@", result);
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            _isEditor = [[[result valueForKey:@"data"] valueForKey:@"is_editor"] integerValue];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 屏蔽
- (void)thn_networkCheckScene:(NSString *)evt {
    if (self.sceneId.length) {
        self.checkRequest = [FBAPI postWithUrlString:URLSceneCheck requestDictionary:@{@"id":self.sceneId, @"evt":evt} delegate:self];
        [self.checkRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([evt isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"已取消屏蔽"];
            } else if ([evt isEqualToString:@"0"]) {
                 [SVProgressHUD showSuccessWithStatus:@"已屏蔽"];
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark 推荐
- (void)thn_networkStickScene:(NSString *)evt {
    if (self.sceneId.length) {
        self.stickRequest = [FBAPI postWithUrlString:URLSceneStick requestDictionary:@{@"id":self.sceneId, @"evt":evt} delegate:self];
        [self.stickRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([evt isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"已推荐"];
            } else if ([evt isEqualToString:@"0"]) {
                [SVProgressHUD showSuccessWithStatus:@"已取消推荐"];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark 精选
- (void)thn_networkFineScene:(NSString *)evt {
    if (self.sceneId.length) {
        self.fineRequest = [FBAPI postWithUrlString:URLSceneFine requestDictionary:@{@"id":self.sceneId, @"evt":evt} delegate:self];
        [self.fineRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([evt isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"已精选"];
            } else if ([evt isEqualToString:@"0"]) {
                [SVProgressHUD showSuccessWithStatus:@"已取消精选"];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

- (void)thn_setLookSceneImage:(NSString *)image {
    [self.imageView networkDisplayImage:image];
}

- (void)setViewUI {
    self.view.backgroundColor = [UIColor blackColor];
    [self addGestureRecognizer];
    [self.view addSubview:self.imageView];
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
    if (_isEditor == 1) {
        __weak __typeof(self)weakSelf = self;
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:nil message:nil];
        alertView.layer.cornerRadius = 10;
        alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
        alertView.buttonCancleBgColor = [UIColor colorWithHexString:@"#999999"];
        [alertView addAction:[TYAlertAction actionWithTitle:_sceneCheck style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
            [weakSelf thn_networkCheckScene:_isCheck];
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:_sceneStick style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            [weakSelf thn_networkStickScene:_isStick];
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:_sceneFine style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            [weakSelf thn_networkFineScene:_isFine];
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"保存图片" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            UIImageWriteToSavedPhotosAlbum(_sceneImage,
                                           self,
                                           @selector(image:didFinishSavingWithError:contextInfo:),
                                           nil);
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {

        }]];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView
                                                                              preferredStyle:TYAlertControllerStyleActionSheet];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:nil message:nil];
        alertView.layer.cornerRadius = 10;
        alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
        alertView.buttonCancleBgColor = [UIColor colorWithHexString:@"#999999"];
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
            
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"保存图片" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            UIImageWriteToSavedPhotosAlbum(_sceneImage,
                                           self,
                                           @selector(image:didFinishSavingWithError:contextInfo:),
                                           nil);
        }]];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView
                                                                              preferredStyle:TYAlertControllerStyleActionSheet];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
