//
//  FiltersViewController.h
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBFootView.h"
#import "FiltersView.h"

@interface FiltersViewController : FBPictureViewController

@pro_strong NSString            *   createType;             //  创建类型（场景/情景）
@pro_strong NSArray             *   locationArr;            //  照片位置
@pro_strong FiltersView         *   filtersView;            //  滤镜视图
@pro_strong FBFootView          *   footView;               //  底部工具栏
@pro_strong UIImageView         *   filtersImageView;       //  需要处理的图片视图
@pro_strong UIImage             *   filtersImg;             //  需要处理的图片
@pro_strong NSString            *   filterName;             //  选择的滤镜名字

@end
