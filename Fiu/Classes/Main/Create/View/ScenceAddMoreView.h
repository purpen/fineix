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

@interface ScenceAddMoreView : UIView <BMKGeoCodeSearchDelegate> {
    
    BMKGeoCodeSearch    *   _geoCodeSearch;
    NSMutableArray      *   _cityMarr;
    NSMutableArray      *   _nameMarr;
}

@pro_strong UINavigationController  *   nav;

@pro_strong UIView          *   addLoacation;       //  添加地点
@pro_strong UIImageView     *   locationIcon;       //  地点图标
@pro_strong UIButton        *   addLoacationBtn;    //  添加位置按钮
@pro_strong UIView          *   locationView;       //  显示地理位置
@pro_strong UILabel         *   location;           //  地理位置
@pro_strong UIButton        *   removeLocation;     //  删除所选的位置
@pro_strong UIScrollView    *   locationScrollView; //  推荐的地理位置附近
@pro_strong UIView          *   addTag;             //  添加标签
@pro_strong UIButton        *   addTagBtn;
@pro_strong UIView          *   addScene;           //  所属情景
@pro_strong UIButton        *   addSceneBtn;


- (void)changeLocationFrame:(NSArray *)locationArr;

@end
