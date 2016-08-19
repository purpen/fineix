//
//  SceneAddViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/30.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBPictureViewController.h"
#import <pop/POP.h>
#import "FiltersView.h"
#import "ChangeAddUrlView.h"
#import "FBFootView.h"
#import "THNMarkGoodsView.h"

@interface SceneAddViewController : FBPictureViewController <
    FBFootViewDelegate,
    THNMarkGoodsViewDelegate
>

@pro_strong NSArray             *locationArr;            //  照片位置
@pro_strong UIButton            *bottomBtn;
@pro_strong UIImageView         *filtersImageView;       //  需要处理的图片视图
@pro_strong UIImage             *filtersImg;             //  需要处理的图片
@pro_strong NSString            *filterName;             //  选择的滤镜名字
@pro_strong NSString            *fSceneId;
@pro_strong NSString            *fSceneTitle;
@pro_strong ChangeAddUrlView    *changeGoodsView;        //  编辑产品
@pro_strong FBRequest           *addUserGoods;
@pro_strong FBRequest           *deleteUserGoods;
@pro_assign NSInteger            seleIndex;
@pro_strong FBFootView          *footView;               //  底部功能选择视图
@pro_strong FiltersView         *filtersView;            //  滤镜视图
@pro_strong THNMarkGoodsView    *markGoodsView;
/**
 *  添加标签
 *  标题／价格／坐标
 */
@pro_strong NSMutableArray      *   popData;

@end
