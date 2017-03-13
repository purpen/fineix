//
//  THNSceneImageViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneImageViewController.h"
#import "THNDomainImageCollectionViewCell.h"
#import <TYAlertController/UIView+TYAlertView.h>

static NSString *const domainImageCellId = @"DomainImageCollectionViewCellId";

static NSString *const URLUserIsEditor = @"/user/is_editor";
static NSString *const URLSceneFine = @"/user/do_fine";
static NSString *const URLSceneStick = @"/user/do_stick";
static NSString *const URLSceneCheck = @"/user/do_check";
static NSString *const URLDeleteAsset = @"/common/delete_asset";
static NSString *const URLSetCover = @"/common/set_default_cover";

@interface THNSceneImageViewController () {
    UIImage *_sceneImage;
    NSInteger _isEditor;
    NSString *_isFine;
    NSString *_isStick;
    NSString *_isCheck;
    NSString *_sceneFine;
    NSString *_sceneStick;
    NSString *_sceneCheck;
    NSString *_imageId;
    NSInteger _imageIndex;
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
    if (self.domainImagesMarr.count == 0) {
        [self.view addSubview:self.imageView];
        [self addGestureRecognizer];
    }
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
        alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#999999"];
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
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {

        }]];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView
                                                                              preferredStyle:TYAlertControllerStyleActionSheet];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:nil message:nil];
        alertView.layer.cornerRadius = 10;
        alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
        alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#999999"];
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
            
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

#pragma mark - ----------
#pragma mark 删除地盘图片
- (void)thn_networkDeleteDomainImage {
    self.deleteAsset = [FBAPI postWithUrlString:URLDeleteAsset requestDictionary:@{@"id":_imageId} delegate:self];
    [self.deleteAsset startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadImageSucceed" object:nil];
            
            [self.domainImagesMarr removeObjectAtIndex:_imageIndex];
            [self.imageCollection deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_imageIndex inSection:0]]];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"--- %@ ---", [error localizedDescription]);
    }];
}

#pragma mark 设为封面
- (void)thn_networkSetCoverDomainImage {
    self.setDefaultCover = [FBAPI postWithUrlString:URLSetCover requestDictionary:@{@"type":@"1", @"id":self.domainId, @"asset_id":_imageId} delegate:self];
    [self.setDefaultCover startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"--- %@ ---", [error localizedDescription]);
    }];
}

#pragma mark - 展示地盘图片的集合
- (void)thn_showDomainImagesOfSet:(NSMutableArray *)images withIndex:(NSInteger)index {
    _imageId = self.imagesIdMarr[index];
    _imageIndex = index;
    
    self.domainImagesMarr = images;
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.moreButton];
    
    [self.view addSubview:self.imageCollection];
    [self.imageCollection reloadData];
    [self.imageCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
    
    [self.view addSubview:self.imageCountLab];
    [self setImageIndexLable:index];
}

#pragma mark - 地盘图片
- (UICollectionView *)imageCollection {
    if (!_imageCollection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
        flowLayout.minimumLineSpacing = 0.01f;
        flowLayout.minimumInteritemSpacing = 0.01f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _imageCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) / 2, SCREEN_WIDTH, SCREEN_WIDTH) collectionViewLayout:flowLayout];
        _imageCollection.delegate = self;
        _imageCollection.dataSource = self;
        _imageCollection.pagingEnabled = YES;
        _imageCollection.backgroundColor = [UIColor blackColor];
        _imageCollection.showsVerticalScrollIndicator = NO;
        _imageCollection.showsHorizontalScrollIndicator = NO;
        [_imageCollection registerClass:[THNDomainImageCollectionViewCell class] forCellWithReuseIdentifier:domainImageCellId];
    }
    return _imageCollection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.domainImagesMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THNDomainImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:domainImageCellId
                                                                                       forIndexPath:indexPath];
    if (self.domainImagesMarr.count) {
        [cell thn_setDomainDetailsImage:self.domainImagesMarr[indexPath.row]];
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.imageCollection) {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self setImageIndexLable:index];
        _imageId = self.imagesIdMarr[index];
        _imageIndex = index;
    }
}

#pragma mark - 图片数量显示
- (UILabel *)imageCountLab {
    if (!_imageCountLab) {
        _imageCountLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, SCREEN_HEIGHT - 44, 60, 40)];
        _imageCountLab.textAlignment = NSTextAlignmentRight;
        _imageCountLab.textColor = [UIColor whiteColor];
    }
    return _imageCountLab;
}

- (void)setImageIndexLable:(NSInteger)index {
    NSString *imagesCount = [NSString stringWithFormat:@"%zi", self.domainImagesMarr.count];
    NSString *indexString = [NSString stringWithFormat:@"%zi", index + 1];
    NSString *defaultString = [NSString stringWithFormat:@"%@／%@", indexString, imagesCount];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:defaultString];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, indexString.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(indexString.length, imagesCount.length + 1)];
    
    self.imageCountLab.attributedText = attributedStr;
}

#pragma mark - 关闭查看地盘大图
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_closeButton setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeButton;
}

- (void)closeButtonClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置地盘图片
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44)];
        [_moreButton setImage:[UIImage imageNamed:@"icon_more_white"] forState:(UIControlStateNormal)];
        [_moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _moreButton;
}

- (void)moreButtonClick:(UIButton *)button {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:nil message:nil];
    alertView.buttonDefaultBgColor = [UIColor colorWithHexString:MAIN_COLOR];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"#666666"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"设为地盘封面" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self thn_networkSetCoverDomainImage];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"删除图片" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        [self thn_networkDeleteDomainImage];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        //        NSLog(@"--- 取消 ---");
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 
- (NSMutableArray *)domainImagesMarr {
    if (!_domainImagesMarr) {
        _domainImagesMarr = [NSMutableArray array];
    }
    return _domainImagesMarr;
}

- (NSMutableArray *)imagesIdMarr {
    if (!_imagesIdMarr) {
        _imagesIdMarr = [NSMutableArray array];
    }
    return _imagesIdMarr;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
}

@end
