//
//  PhotoAlbumsView.h
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "FBPhoto.h"

@interface PhotoAlbumsView : UIView <UITableViewDataSource, UITableViewDelegate>

@pro_strong UITableView         *   photoAlbumsTableView;    //     相册列表
@pro_strong NSMutableArray      *   photoAlbums;             //     相薄

@pro_strong UIButton            *   photoAlbumsBtn;          //     相薄的相册按钮
@pro_strong UIButton            *   nextBtn;                 //     下一步的按钮
@pro_strong UICollectionView    *   collectionView;          //     相册列表
@pro_strong UIImageView         *   showImageView;           //     展示的图片视图
@pro_strong NSMutableArray      *   photosMarr;

@end
