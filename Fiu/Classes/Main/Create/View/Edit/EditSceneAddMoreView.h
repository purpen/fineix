//
//  EditSceneAddMoreView.h
//  Fiu
//
//  Created by FLYang on 16/6/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface EditSceneAddMoreView : UIView < UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout >

@pro_strong UIViewController    *   vc;
@pro_strong UIView              *   addLoacation;       //  添加地点
@pro_strong UIImageView         *   locationIcon;       //  地点图标
@pro_strong UIButton            *   addLoacationBtn;    //  添加位置按钮
@pro_strong UIView              *   locationView;       //  显示地理位置
@pro_strong UILabel             *   location;           //  地理位置
@pro_strong UIButton            *   removeLocation;     //  删除所选的位置
@pro_strong UIView              *   addTag;             //  添加标签
@pro_strong UIButton            *   addTagBtn;
@pro_strong UIView              *   addScene;           //  所属情景
@pro_strong UIButton            *   selectFSceneBtn;    //  所选情景
@pro_strong UIButton            *   addSceneBtn;
@pro_strong NSString            *   latitude;           //  纬度
@pro_strong NSString            *   longitude;          //  经度
@pro_strong NSString            *   fiuId;
@pro_strong UICollectionView    *   chooseTagView;      //  选择的标签列表
@pro_strong NSMutableArray      *   chooseTagMarr;
@pro_strong NSMutableArray      *   chooseTagIdMarr;

- (void)changeTagFrame;

- (void)changeSceneFrame:(NSString *)title;

@end
