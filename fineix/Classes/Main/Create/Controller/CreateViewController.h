//
//  CreateViewController.h
//  fineix
//
//  Created by FLYang on 16/2/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBFootView.h"

@interface CreateViewController : FBPictureViewController

@pro_strong FBFootView          *   footView;       //  底部功能选择视图
@pro_strong UICollectionView    *   pictureView;    //  照片列表

@pro_strong NSArray             *   photosArr;      //  全部的相片

@end
