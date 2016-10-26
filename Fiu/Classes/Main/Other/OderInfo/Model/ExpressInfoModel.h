//
//  ExpressInfoModel.h
//  parrot
//
//  Created by THN-Huangfei on 15/12/25.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressInfoModel : NSObject

@property (nonatomic, strong) NSString * address;       //详细地址
@property (nonatomic, strong) NSString * name;          //姓名
@property (nonatomic, strong) NSString * phone;         //手机
@property (nonatomic, assign) NSInteger zip;            //邮编
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, strong) NSString * provinceName;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, assign) NSInteger countyId;
@property (nonatomic, strong) NSString * countyName;
@property (nonatomic, assign) NSInteger townId;
@property (nonatomic, strong) NSString * townName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
