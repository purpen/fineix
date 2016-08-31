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

@pro_strong FBImageScrollView *clipImageView;   //  裁剪图片视图
@pro_strong UIView *dragView;
@pro_strong UIImageView *gripView;
@pro_strong FBFootView *footView;               //  底部功能选择视图
@pro_strong CameraView *cameraView;             //  相机页面
@pro_strong UIView *pictureView;
@pro_strong UICollectionView *photosView;       //  照片列表
@pro_strong NSMutableArray *sortPhotosArr;      //  排序的相片
@pro_strong NSMutableArray *photoAlbumArr;      //  全部的相薄
@pro_strong PhotoAlbumsView *photoAlbumsView;   //  相薄页面
/** 活动ID */
@pro_strong NSString *actionId;
/** 活动标题 */
@pro_strong NSString *activeTitle;

@end
