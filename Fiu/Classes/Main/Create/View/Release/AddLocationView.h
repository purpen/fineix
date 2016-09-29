//
//  AddLocationView.h
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface AddLocationView : UIView

@pro_strong UIViewController    *   vc;
@pro_strong UIButton            *   locationIcon;
@pro_strong UIButton            *   addLocation;
@pro_strong UIView              *   locationView;
@pro_strong UILabel             *   locationLab;
@pro_strong UILabel             *   cityLab;
@pro_strong UIButton            *   clearBtn;
@pro_strong NSString            *   latitude;           //  纬度
@pro_strong NSString            *   longitude;          //  经度


/**
 编辑情境改变地点

 @param latitude  纬度
 @param longitude 经度
 @param city      城市
 @param address   地址
 */
- (void)setEditSceneLocationLat:(NSString *)latitude lng:(NSString *)longitude city:(NSString *)city address:(NSString *)address;

@end
