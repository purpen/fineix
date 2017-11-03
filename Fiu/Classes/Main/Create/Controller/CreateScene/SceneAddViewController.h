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
#import "FSImageFilterManager.h"
#import "FSFliterImage.h"
#import "THNFilterValueView.h"

@interface SceneAddViewController : FBPictureViewController <
    FBFootViewDelegate,
    THNMarkGoodsViewDelegate,
    FBUserGoodsTagDelegaet,
    FiltersViewDelegate,
    THNAdjustFilterValueDelegate,
    ChangeFilterValueDelegate
>

@property (nonatomic, strong) NSArray             *locationArr;            //  照片位置
@property (nonatomic, strong) UIImageView         *filtersImageView;       //  需要处理的图片视图
@property (nonatomic, strong) UIImage             *filtersImg;             //  需要处理的原始图片
@property (nonatomic, strong) NSString            *filterName;             //  选择的滤镜名字
@property (nonatomic, strong) NSString            *fSceneId;
@property (nonatomic, strong) NSString            *fSceneTitle;
@property (nonatomic, strong) FBRequest           *addUserGoods;
@property (nonatomic, strong) FBRequest           *addUserBrand;
@property (nonatomic, strong) FBRequest           *deleteUserGoods;
@property (nonatomic, strong) FBRequest           *userAddRequest;
@property (nonatomic, assign) NSInteger            seleIndex;
@property (nonatomic, strong) FBFootView          *footView;               //  底部功能选择视图
@property (nonatomic, strong) UIScrollView        *functionView;
@property (nonatomic, strong) FiltersView         *filtersView;            //  滤镜视图
@property (nonatomic, strong) THNAdjustView       *adjustView;             //  调整视图
@property (nonatomic, strong) UIButton            *bottomBtn;
@property (nonatomic, strong) THNMarkGoodsView    *markGoodsView;
@property (nonatomic, strong) NSArray             *footTitleArr;
@property (nonatomic, strong) FSImageFilterManager *filterManager;
@property (nonatomic, strong) THNFilterValueView  *filterValueView;
@property (nonatomic, strong) FSFliterImage       *editFilterImage;

///
@property (nonatomic, strong) UserGoodsTag           *userGoodsTag;
@property (nonatomic, strong) NSMutableDictionary    *userAddGoodsDict;
@property (nonatomic, strong) NSMutableArray         *tagBtnMarr;
@property (nonatomic, strong) NSMutableArray         *userAddGoodsMarr;
@property (nonatomic, strong) NSMutableArray         *goodsIdData;
@property (nonatomic, strong) NSMutableArray         *goodsTitleData;
@property (nonatomic, strong) NSMutableArray         *goodsPriceData;
@property (nonatomic, strong) NSMutableArray         *goodsTypeData;
@property (nonatomic, strong) NSMutableArray         *stickersContainer;

/**
 *  添加标签
 *  标题／价格／坐标
 */
@property (nonatomic, strong) NSMutableArray *popData;

/** 活动ID */
@property (nonatomic, strong) NSString *actionId;
/** 活动标题 */
@property (nonatomic, strong) NSString *activeTitle;
/**
 所属地盘id
 */
@property (nonatomic, strong) NSString *domainId;

@end
