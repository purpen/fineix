//
//  DeliveryAddressModel.m
//  parrot
//
//  Created by THN-Huangfei on 15/12/21.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "DeliveryAddressModel.h"

@implementation DeliveryAddressModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[@"_id"];
    }
    if(![dictionary[@"address"] isKindOfClass:[NSNull class]]){
        self.address = dictionary[@"address"];
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
    
    if(![dictionary[@"is_default"] isKindOfClass:[NSNull class]]){
        self.isDefault = [dictionary[@"is_default"] integerValue];
    }
    if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
        self.name = dictionary[@"name"];
    }
    if(![dictionary[@"phone"] isKindOfClass:[NSNull class]]){
        self.phone = dictionary[@"phone"];
    }
//    if(![dictionary[@"user_id"] isKindOfClass:[NSNull class]]){
//        self.userId = [dictionary[@"user_id"] integerValue];
//    }
    
    if(![dictionary[@"zip"] isKindOfClass:[NSNull class]]){
        self.zip = dictionary[@"zip"];
    }
    
    if (![dictionary[@"has_default"] isKindOfClass:[NSNull class]]) {
        self.hasDefault = [dictionary[@"has_default"] integerValue];
    }
    
    return self;
}

@end
