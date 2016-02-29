//
//  CreateViewController.m
//  fineix
//
//  Created by FLYang on 16/2/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CreateViewController.h"
#import "FBLoadPhoto.h"
#import "FBPictureCollectionViewCell.h"

@interface CreateViewController () <FBFootViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavViewUI];
    
    [self setCreateControllerUI];
    
    [self loadAllPhotos];
}

#pragma mark - 设置顶部Nav
- (void)setNavViewUI {
    self.titleArr = [[NSMutableArray alloc] initWithObjects:@"照片胶卷",@"裁剪图片",@"标记产品",@"创建情景", nil];
    [self addNavView:self.titleArr];
}

#pragma mark - 创建页面UI
- (void)setCreateControllerUI {
    //  选择照片视图
    [self.view addSubview:self.createView];
    
    //  打开相机视图
    [self.view addSubview:self.cameraView];
    self.cameraView.hidden = YES;
}

- (UIView *)createView {
    if (!_createView) {
        _createView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
        _createView.backgroundColor = [UIColor blackColor];
        
        //  底部选项栏
        [_createView addSubview:self.footView];
        [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 55));
            make.bottom.equalTo(_createView.mas_bottom).with.offset(0);
            make.centerX.equalTo(_createView);
        }];
        
        //  相册列表
        [_createView addSubview:self.pictureView];
        [_pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 200));
            make.bottom.equalTo(self.footView.mas_top).with.offset(0);
            make.centerX.equalTo(_createView);
        }];
        
        //  显示的照片
        [_createView addSubview:self.photoImgView];
        [_photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.pictureView.mas_top).with.offset(-2);
            make.top.equalTo(_createView.mas_top).with.offset(0);
            make.left.equalTo(_createView.mas_left).with.offset(0);
            make.right.equalTo(_createView.mas_right).with.offset(0);
        }];
        
    }
    return _createView;
}

#pragma mark 底部选项工具栏
- (FBFootView *)footView {
    if (!_footView) {
        NSArray * arr = [NSArray arrayWithObjects:@"相册", @"照片", nil];
        _footView = [[FBFootView alloc] init];
        _footView.backgroundColor = [UIColor colorWithHexString:pictureNavColor alpha:1];
        _footView.titleArr = arr;
        [_footView addFootViewButton];
        [_footView showLineWithButton];
        _footView.delegate = self;
    }
    return _footView;
}

#pragma mark 底部选项的点击事件
- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    if (index == 1) {
        [UIView animateWithDuration:.3 animations:^{
            self.cameraView.hidden = NO;
        }];
        
    } else if (index == 0) {
        [UIView animateWithDuration:.3 animations:^{
            self.cameraView.hidden = YES;
        }];
    }
}

#pragma mak - 打开相机的页面
- (FBCameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[FBCameraView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 55)];
    }
    return _cameraView;
}

#pragma mark - 显示的照片
- (UIImageView *)photoImgView {
    if (!_photoImgView) {
        _photoImgView = [[UIImageView alloc] init];
    }
    return _photoImgView;
}

#pragma mark - 相册的列表视图
- (UICollectionView *)pictureView {
    if (!_pictureView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 6) / 4, (SCREEN_WIDTH - 6) / 4);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 2.0;
        flowLayout.minimumLineSpacing = 2.0;
        
        _pictureView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        _pictureView.delegate = self;
        _pictureView.dataSource = self;
        _pictureView.backgroundColor = [UIColor blackColor];
        _pictureView.showsHorizontalScrollIndicator = NO;
        _pictureView.showsVerticalScrollIndicator = NO;
        
        [_pictureView registerClass:[FBPictureCollectionViewCell class] forCellWithReuseIdentifier:@"FBPictureCollectionViewCell"];
    }
    return _pictureView;
}

#pragma mark  UICollectionViewDataSource(相册列表)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellIdentifier = @"FBPictureCollectionViewCell";
    
    FBPictureCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    FBPhoto * photo = [self.photosArr objectAtIndex:indexPath.row];
    cell.imageView.image = photo.thumbnailImage;
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBPhoto * photo = [self.photosArr objectAtIndex:indexPath.row];
    self.photoImgView.image = photo.originalImage;
}

#pragma mark - 加载所有的相片
- (void)loadAllPhotos {
    [FBLoadPhoto loadAllPhotos:^(NSArray *photos, NSError *error) {
        if (!error) {
            self.photosArr = [NSArray arrayWithArray:photos];
            if (self.photosArr.count) {
                //  默认加载第一张照片
                FBPhoto * firstPhoto = [self.photosArr objectAtIndex:0];
                self.photoImgView.image = firstPhoto.originalImage;
            }
            [self.pictureView reloadData];

        } else {
            NSLog(@"＝＝＝＝＝＝＝ 加载图片错误%@ ＝＝＝＝＝＝＝", error);
        }
    }];
}

#pragma mark - 获取所有的相薄
- (void)loadAllPhotoAlbum {
    [FBLoadPhoto loadAllPhotoAlbum:^(NSArray * photoAlbum, NSError *error) {
        if (!error) {
            self.photoAlbumArr = [NSArray arrayWithArray:photoAlbum];
            NSLog(@"相册相册相册相册相册相册");
        
        } else {
            NSLog(@"＝＝＝＝＝＝＝ 加载相册错误%@ ＝＝＝＝＝＝＝", error);
        }
    }];
}


@end
