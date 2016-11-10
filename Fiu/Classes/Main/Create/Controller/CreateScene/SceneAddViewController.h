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
#import "THNAdjustView.h"
#import "FBFootView.h"
#import "THNMarkGoodsView.h"
#import "UserGoodsTag.h"

@interface SceneAddViewController : FBPictureViewController <
    FBFootViewDelegate,
    THNMarkGoodsViewDelegate,
    FBUserGoodsTagDelegaet
>

@pro_strong NSArray             *locationArr;            //  照片位置
@pro_strong UIImageView         *filtersImageView;       //  需要处理的图片视图
@pro_strong UIImage             *filtersImg;             //  需要处理的图片
@pro_strong NSString            *filterName;             //  选择的滤镜名字
@pro_strong NSString            *fSceneId;
@pro_strong NSString            *fSceneTitle;
@pro_strong FBRequest           *addUserGoods;
@pro_strong FBRequest           *addUserBrand;
@pro_strong FBRequest           *deleteUserGoods;
@pro_strong FBRequest           *userAddRequest;
@pro_assign NSInteger            seleIndex;
@pro_strong FBFootView          *footView;               //  底部功能选择视图
@pro_strong UIScrollView        *functionView;
@pro_strong FiltersView         *filtersView;            //  滤镜视图
@pro_strong THNAdjustView       *adjustView;             //  调整视图
@pro_strong UIButton            *bottomBtn;
@pro_strong THNMarkGoodsView    *markGoodsView;
@pro_strong NSArray             *footTitleArr;

///
@pro_strong UserGoodsTag           *userGoodsTag;
@pro_strong NSMutableDictionary    *userAddGoodsDict;
@pro_strong NSMutableArray         *tagBtnMarr;
@pro_strong NSMutableArray         *userAddGoodsMarr;
@pro_strong NSMutableArray         *goodsIdData;
@pro_strong NSMutableArray         *goodsTitleData;
@pro_strong NSMutableArray         *goodsPriceData;
@pro_strong NSMutableArray         *goodsTypeData;
@pro_strong NSMutableArray         *stickersContainer;

/**
 *  添加标签
 *  标题／价格／坐标
 */
@pro_strong NSMutableArray *popData;

/** 活动ID */
@pro_strong NSString *actionId;
/** 活动标题 */
@pro_strong NSString *activeTitle;

@end
