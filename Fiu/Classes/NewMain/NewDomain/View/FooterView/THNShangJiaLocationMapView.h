//
//  THNShangJiaLocationMapView.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/21.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@class DominInfoData;

@interface THNShangJiaLocationMapView : BMKMapView

/**  */
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
/**  */
@property (nonatomic, strong) UINavigationController *nav;
/**  */
@property (nonatomic, strong) DominInfoData *model;

-(void)setPoint;

@end
