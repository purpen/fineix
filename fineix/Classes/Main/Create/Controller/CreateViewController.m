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
    
    [self addCancelBtn];
    
    [self addPhotoAlbumBtn];
    [self.photoAlbumBtn addTarget:self action:@selector(photoAlbumBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addNextBtn];
    
    [self setCreateControllerUI];
    
    [self loadAllPhotos];
}

- (void)photoAlbumBtnClick {
    NSLog(@"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊打开相册集");
}

#pragma mark 创建页面整体UI
- (void)setCreateControllerUI {
    
    //  底部选项栏
    [self.view addSubview:self.footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 55));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    //  相册列表
    [self.view addSubview:self.pictureView];
    [_pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 200));
        make.bottom.equalTo(self.footView.mas_top).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
    
}

#pragma mark - 相册的列表视图
- (UICollectionView *)pictureView {
    if (!_pictureView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 6) / 4, (SCREEN_WIDTH - 6) / 4);
        flowLayout.sectionInset = UIEdgeInsetsMake(2.0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 2.0;
        flowLayout.minimumLineSpacing = 2.0;
        
        _pictureView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        _pictureView.delegate = self;
        _pictureView.dataSource = self;
        _pictureView.backgroundColor = [UIColor blackColor];
        
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

#pragma mark 加载所有的相片
- (void)loadAllPhotos {
    [FBLoadPhoto loadAllPhotos:^(NSArray *photos, NSError *error) {
        if (!error) {
            self.photosArr = [NSArray arrayWithArray:photos];
            if (self.photosArr.count) {
                //  默认加载第一张照片
                FBPhoto * firstPhoto = [self.photosArr objectAtIndex:0];
                NSLog(@"－－－－－－－－－－－－ 默认选择第一张照片 %@", firstPhoto);
            }
            [self.pictureView reloadData];

        } else {
            NSLog(@"＝＝＝＝＝＝＝ 加载图片错误%@ ＝＝＝＝＝＝＝", error);
        }
    }];
}


#pragma mark - 底部选项工具栏
- (FBFootView *)footView {
    if (!_footView) {
        NSArray * arr = [NSArray arrayWithObjects:@"相册", @"照片", nil];
        
        _footView = [[FBFootView alloc] init];
        _footView.titleArr = arr;
        [_footView addFootViewButton];
        [_footView showLineWithButton];
        _footView.delegate = self;
        
    }
    return _footView;
}

#pragma mark 底部选项的点击事件
- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    NSLog(@"点击了第 %zi 个按钮", index);
}

@end
