//
//  ClipImageViewController.h
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVMediaFormat.h>
#import "Fiu.h"
#import "FBFootView.h"
#import "CameraView.h"
#import "FBImageScrollView.h"
#import "FBLoadPhoto.h"
#import "FBPictureViewController.h"
#import "PhotoAlbumsView.h"

@class CropImageView;

@interface ClipImageViewController : FBPictureViewController <
    FBFootViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@property (nonatomic, strong) FBImageScrollView *clipImageView;   //  裁剪图片视图
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UIImageView *gripView;
@property (nonatomic, strong) FBFootView *footView;               //  底部功能选择视图
@property (nonatomic, strong) CameraView *cameraView;             //  相机页面
@property (nonatomic, strong) UIView *pictureView;
@property (nonatomic, strong) UICollectionView *photosView;       //  照片列表
@property (nonatomic, strong) NSMutableArray *sortPhotosArr;      //  排序的相片
@property (nonatomic, strong) NSMutableArray *photoAlbumArr;      //  全部的相薄
@property (nonatomic, strong) PhotoAlbumsView *photoAlbumsView;   //  相薄页面
/** 活动ID */
@property (nonatomic, strong) NSString *actionId;
/** 活动标题 */
@property (nonatomic, strong) NSString *activeTitle;
/**
 所属地盘id
 */
@property (nonatomic, strong) NSString *domainId;

@end
