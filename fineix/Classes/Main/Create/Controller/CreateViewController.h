//
//  CreateViewController.h
//  fineix
//
//  Created by FLYang on 16/2/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBFootView.h"
#import "FBCameraView.h"

@interface CreateViewController : FBPictureViewController

@pro_strong UIView              *   createView;         //  创建场景页面
@pro_strong FBFootView          *   footView;           //  底部功能选择视图
@pro_strong UICollectionView    *   pictureView;        //  照片列表
@pro_strong UIImageView         *   photoImgView;       //  选中显示的照片
//@pro_strong UITableView         *   photoAlbumView;     //  相薄列表
@pro_strong FBCameraView        *   cameraView;         //  相机页面

@pro_strong NSMutableArray      *   titleArr;           //  页面标题
@pro_strong NSArray             *   photosArr;          //  全部的相片
@pro_strong NSArray             *   photoAlbumArr;      //  全部的相薄

@end
