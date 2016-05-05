//
//  DeliveryAddressModel.h
//  parrot
//
//  Created by THN-Huangfei on 15/12/21.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryAddressModel : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSObject * area;
@property (nonatomic, assign) NSInteger city;
@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, assign) NSInteger isDefault;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, assign) NSInteger province;
@property (nonatomic, strong) NSString * provinceName;
@property (nonatomic, assign) NSInteger hasDefault;
//@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * zip;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
