//
//  PictureView.m
//  fineix
//
//  Created by FLYang on 16/3/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PictureView.h"
#import "FBPictureCollectionViewCell.h"
#import "FBLoadPhoto.h"
#import "SVProgressHUD.h"

@implementation PictureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadAllPhotos];
        
        [self addSubview:self.createView];
        
        [self addSubview:self.recoveryFrameBtn];
        self.recoveryFrameBtn.hidden = YES;
        
        [self pictureViewZoom];
    }
    
    return self;
}

#pragma mark - 页面UI
- (UIView *)createView {
    if (!_createView) {
        _createView = [[UIView alloc] initWithFrame:self.bounds];
        _createView.backgroundColor = [UIColor blackColor];
        
        //  相册列表
        [_createView addSubview:self.pictureView];
        [_pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 200));
            make.bottom.equalTo(self.createView.mas_bottom).with.offset(0);
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
        
        //  相册列表
        [_createView addSubview:self.photoAlbumsView];
        
    }
    return _createView;
}

#pragma mark - 加载所有的相片
- (void)loadAllPhotos {
    self.sortPhotosArr = [NSMutableArray array];
    self.photoAlbumArr = [NSMutableArray array];
    
    [FBLoadPhoto loadAllPhotos:^(NSArray *photos, NSArray *photoAlbums, NSError *error) {
        if (!error) {
            NSEnumerator * enumerator = [photos reverseObjectEnumerator];
            while (id object = [enumerator nextObject]) {
                [self.sortPhotosArr addObject:object];
            }
            
            [self.pictureView reloadData];
            
            [self.pictureView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                           animated:YES
                                     scrollPosition:(UICollectionViewScrollPositionNone)];
            
            if (photos.count) {
                [self showFirstPhoto];
            }
            
            self.photoAlbumArr = [photoAlbums copy];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"photoAlbums" object:self.photoAlbumArr];
            
        } else {
            NSLog(@"＝＝＝＝＝＝＝ 加载图片错误%@ ＝＝＝＝＝＝＝", error);
        }
    }];
}

#pragma mark - 显示的照片
- (UIImageView *)photoImgView {
    if (!_photoImgView) {
        _photoImgView = [[UIImageView alloc] init];
        _photoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgView.clipsToBounds  = YES;
        [_photoImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    }
    return _photoImgView;
}

- (void)showFirstPhoto {
    //  默认加载第一张照片
    FBPhoto * firstPhoto = [self.sortPhotosArr objectAtIndex:0];
    self.photoImgView.image = firstPhoto.originalImage;
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
    return self.sortPhotosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellIdentifier = @"FBPictureCollectionViewCell";
    
    FBPictureCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    FBPhoto * photo = [self.sortPhotosArr objectAtIndex:indexPath.row];
    cell.imageView.image = photo.thumbnailImage;
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBPhoto * photo = [self.sortPhotosArr objectAtIndex:indexPath.row];
    self.photoImgView.image = photo.originalImage;
    [self getPhotoLocation:photo.asset.defaultRepresentation.metadata];
    
    if (self.pictureView.frame.size.height > 200) {
        //  显示画布的frame
        CGRect photoViewRect = self.photoImgView.frame;
        photoViewRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 305);
        [UIView animateWithDuration:.5 animations:^{
            self.photoImgView.frame = photoViewRect;
            self.recoveryFrameBtn.hidden = YES;
        }];
        
        //  显示照片列表的frame
        CGRect pictureViewRect = self.pictureView.frame;
        pictureViewRect = CGRectMake(0, self.photoImgView.bounds.size.height + 2, SCREEN_WIDTH, 200);
        [UIView animateWithDuration:.5 animations:^{
            self.pictureView.frame = pictureViewRect;
        }];
        
        self.navView.hidden = NO;
    }
}

#pragma mark - 获取所选照片的经纬度
- (void)getPhotoLocation:(NSDictionary *)location {
    //  获取照片保存的地理信息
    NSDictionary * imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:location];
    NSDictionary * gpsDict = [imageMetadata objectForKey:@"{GPS}"];
    NSArray * locationArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",[[gpsDict valueForKey:@"Longitude"] floatValue]],
                             [NSString stringWithFormat:@"%f",[[gpsDict valueForKey:@"Latitude"] floatValue]], nil];
    
    NSLog(@"＝＝＝＝＝＝＝＝＝＝＝ 经纬度%@", locationArr);
    
    [self setPhotoLocation:locationArr];
}

#pragma mark - 获取照片所在位置
- (void)setPhotoLocation:(NSArray *)locationArr {
    
    CLLocationDegrees n = [locationArr[0] floatValue];
    CLLocationDegrees e = [locationArr[1] floatValue];
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    CLLocation * location = [[CLLocation alloc] initWithLatitude:e longitude:n];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            
            /** CLPlacemark         地标
             *  location            位置对象
             *  addressDictionary   地址字典
             *  name                地址详情
             *  locality            城市
             */
            
            CLPlacemark * placemark = [placemarks firstObject];
            self.locationStr = placemark.name;
            NSLog(@"＝＝＝＝ %@", self.locationStr);
            [SVProgressHUD showSuccessWithStatus:self.locationStr];
            
        } else {
            NSLog(@"照片没有地理位置");
            [SVProgressHUD showErrorWithStatus:@"照片没有地理位置"];
        }
        
    }];
}

#pragma mark - 上滑拉伸显示全部相片列表
- (void)pictureViewZoom{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pictureViewZoom:)];
    pan.delegate = self;
    [self.pictureView addGestureRecognizer:pan];
}

#pragma mark 相片列表上滑展示全部相片
- (void)pictureViewZoom:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged) {
        //  上滑的距离
        CGFloat panfloat = [pan translationInView:self.pictureView].y;
        //  相册列表的frame
        CGRect pictureViewRect = self.pictureView.frame;
        //  显示画布的frame
        CGRect photoViewRect = self.photoImgView.frame;
        
        if (panfloat < -200) {
            photoViewRect = CGRectMake(0, -(SCREEN_HEIGHT - 305), SCREEN_WIDTH, SCREEN_HEIGHT - 305);
            [UIView animateWithDuration:.5 animations:^{
                self.photoImgView.frame = photoViewRect;
            } completion:^(BOOL finished) {
                self.recoveryFrameBtn.hidden = NO;
                if (self.recoveryFrameBtn.hidden == NO) {
                    self.navView.hidden = YES;
                }
            }];
            
            pictureViewRect = CGRectMake(0, 0, SCREEN_WIDTH, self.createView.bounds.size.height);
            [UIView animateWithDuration:.5 animations:^{
                self.pictureView.frame = pictureViewRect;
            }];
            
        }
        
        //  照片列表的偏移量
        CGFloat pictureViewFloat = self.pictureView.contentOffset.y;
        
        if (pictureViewFloat < -50) {
            photoViewRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 305);
            [UIView animateWithDuration:.5 animations:^{
                self.photoImgView.frame = photoViewRect;
                self.recoveryFrameBtn.hidden = YES;
            }];
            
            pictureViewRect = CGRectMake(0, self.photoImgView.bounds.size.height + 2, SCREEN_WIDTH, 200);
            [UIView animateWithDuration:.5 animations:^{
                self.pictureView.frame = pictureViewRect;
            }];
            
            self.navView.hidden = NO;
        }
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:self.pictureView]) {
        return NO;
    }
    return YES;
}

#pragma mark 点击恢复初始位置的按钮
- (UIButton *)recoveryFrameBtn {
    if (!_recoveryFrameBtn) {
        _recoveryFrameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, 50)];
        _recoveryFrameBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
        
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 3)];
        lineLab.backgroundColor = [UIColor blackColor];
        lineLab.layer.shadowColor = [UIColor blackColor].CGColor;
        lineLab.layer.shadowOffset = CGSizeMake(0, 2);
        lineLab.layer.shadowOpacity = 1.0f;
        [_recoveryFrameBtn addSubview:lineLab];
        
    }
    return _recoveryFrameBtn;
}

#pragma mark - 加载相薄页面
- (PhotoAlbumsView *)photoAlbumsView {
    if (!_photoAlbumsView) {
        _photoAlbumsView = [[PhotoAlbumsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
        self.sortPhotosArr = _photoAlbumsView.photosMarr;
        _photoAlbumsView.collectionView = self.pictureView;
        _photoAlbumsView.showImageView = self.photoImgView;
    }
    return _photoAlbumsView;
}

@end
