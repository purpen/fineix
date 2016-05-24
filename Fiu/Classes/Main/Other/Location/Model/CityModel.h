//
//  CityModel.h
//  Fiu
//
//  Created by THN-Dong on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *image_url;
@property(nonatomic,strong) NSNumber *lng;
@property(nonatomic,strong) NSNumber *lat;

@end
