//
//  PictureView.h
//  fineix
//
//  Created by FLYang on 16/3/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "PhotoAlbumsView.h"

@interface PictureView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@pro_strong UIView  * navView;
@pro_strong UIView              *   createView;         //  创建场景页面
@pro_strong UICollectionView    *   pictureView;        //  照片列表
@pro_strong UIImageView         *   photoImgView;       //  选中显示的照片
@pro_strong UIButton            *   recoveryFrameBtn;   //  恢复视图位置
@pro_strong PhotoAlbumsView     *   photoAlbumsView;    //  相薄页面
@pro_strong NSMutableArray      *   sortPhotosArr;      //  排序的相片
@pro_strong NSMutableArray      *   photoAlbumArr;      //  全部的相薄
@pro_strong NSString            *   locationStr;        //  地理位置
@pro_strong NSArray             *   locationArr;        //  存储经纬度的数组

@end
