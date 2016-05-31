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
#import "ChangeAddUrlView.h"

@interface FiltersViewController : FBPictureViewController

@pro_strong FiltersView         *   filtersView;            //  滤镜视图
@pro_strong UIImageView         *   filtersImageView;       //  需要处理的图片视图
@pro_strong NSString            *   filterName;             //  选择的滤镜名字

@pro_strong UIImage             *   filtersImg;             //  需要处理的图片
@pro_strong NSString            *   createType;             //  创建类型（场景/情景）
@pro_strong NSString            *   goodsTitle;             //  商品标题
@pro_strong NSString            *   goodsId;                //  商品id
@pro_strong NSString            *   goodsPrice;             //  商品价格
@pro_strong NSString            *   goodsX;                 //  商品坐标
@pro_strong NSString            *   goodsY;                 //  商品坐标
@pro_strong NSString            *   tagS;                   //  标签
@pro_strong NSString            *   fSceneId;               //  情景id
@pro_strong NSString            *   fSceneTitle;
@pro_strong NSString            *   lat;                    //  经度
@pro_strong NSString            *   lng;                    //  纬度
@pro_strong NSArray             *   locationArr;            //  照片位置

/**
 *  添加标签
 *  标题／价格／坐标
 */
@pro_strong NSMutableArray      *   popData;

@end
