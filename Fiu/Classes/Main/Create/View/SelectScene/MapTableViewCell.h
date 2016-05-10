//
//  MapTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/5/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface MapTableViewCell : UITableViewCell

@property(nonatomic,strong) BMKMapView *mapView;
@property(nonatomic,strong) UIView *view;
@property(nonatomic,strong) NSArray *ary;

-(void)setUIWithAry:(NSArray*)ary;

@end
