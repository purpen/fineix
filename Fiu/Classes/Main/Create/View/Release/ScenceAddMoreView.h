//
//  ScenceAddMoreView.h
//  fineix
//
//  Created by FLYang on 16/3/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "SearchLocationViewController.h"

@interface ScenceAddMoreView : UIView <BMKGeoCodeSearchDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SearDelaget> {
    
    BMKGeoCodeSearch    *   _geoCodeSearch;
    NSMutableArray      *   _cityMarr;
    NSMutableArray      *   _nameMarr;
}

@pro_strong UIViewController        *   vc;
@pro_strong UINavigationController  *   nav;

@pro_strong UIView          *   addLoacation;       //  添加地点
@pro_strong UIImageView     *   locationIcon;       //  地点图标
@pro_strong UIImageView     *   tagIcon;       //  地点图标
@pro_strong UIButton        *   addLoacationBtn;    //  添加位置按钮
@pro_strong UIView          *   locationView;       //  显示地理位置
@pro_strong UILabel         *   location;           //  地理位置
@pro_strong UIButton        *   removeLocation;     //  删除所选的位置
@pro_strong UIScrollView    *   locationScrollView; //  推荐的地理位置附近
@pro_strong UIView          *   addTag;             //  添加标签
@pro_strong UIButton        *   addTagBtn;
@pro_strong UIView          *   addScene;           //  所属情景
@pro_strong UIButton        *   selectFSceneBtn;    //  所选情景
@pro_strong UIButton        *   addSceneBtn;
@pro_strong NSString        *   latitude;           //  纬度
@pro_strong NSString        *   longitude;          //  经度
@pro_strong NSString        *   fiuId;

@pro_strong UIView              *   recommendView;
@pro_strong UILabel             *   addTagLab;
@pro_strong UICollectionView    *   recommendTagView;      //  推荐的标签列表
@pro_strong NSMutableArray      *   recommendTagMarr;
@pro_strong UICollectionView    *   chooseTagView;         //  选择的标签列表
@pro_strong NSMutableArray      *   chooseTagMarr;

- (void)getRecommendTagS:(NSMutableArray *)tags;

- (void)changeLocationFrame:(NSArray *)locationArr;

- (void)changeSceneFrame:(NSString *)title;

@end
