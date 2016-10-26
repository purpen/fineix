//
//  ExpressInfoModel.m
//  parrot
//
//  Created by THN-Huangfei on 15/12/25.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "ExpressInfoModel.h"

@implementation ExpressInfoModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"address"] isKindOfClass:[NSNull class]]){
        self.address = dictionary[@"address"];
    }
    if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
        self.name = dictionary[@"name"];
    }
    if(![dictionary[@"phone"] isKindOfClass:[NSNull class]]){
        self.phone = dictionary[@"phone"];
    }
    if(![dictionary[@"zip"] isKindOfClass:[NSNull class]]){
        self.zip = [dictionary[@"zip"] integerValue];
    }
    
    if(![dictionary[@"province_id"] isKindOfClass:[NSNull class]]){
        self.provinceId = [dictionary[@"province_id"] integerValue];
    }
    if(![dictionary[@"province"] isKindOfClass:[NSNull class]]){
        self.provinceName = dictionary[@"province"];
    }
    if(![dictionary[@"city_id"] isKindOfClass:[NSNull class]]){
        self.cityId = [dictionary[@"city_id"] integerValue];
    }
    if(![dictionary[@"city"] isKindOfClass:[NSNull class]]){
        self.cityName = dictionary[@"city"];
    }
    if(![dictionary[@"county_id"] isKindOfClass:[NSNull class]]){
        self.countyId = [dictionary[@"county_id"] integerValue];
    }
    if(![dictionary[@"county"] isKindOfClass:[NSNull class]]){
        self.countyName = dictionary[@"county"];
    }
    if(![dictionary[@"town_id"] isKindOfClass:[NSNull class]]){
        self.townId = [dictionary[@"town_id"] integerValue];
    }
    if(![dictionary[@"town"] isKindOfClass:[NSNull class]]){
        self.townName = dictionary[@"town"];
    }
    
    return self;
}

@end
