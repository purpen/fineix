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
    if(![dictionary[@"area"] isKindOfClass:[NSNull class]]){
        self.area = dictionary[@"area"];
    }
    if(![dictionary[@"city"] isKindOfClass:[NSNull class]]){
        self.city = [dictionary[@"city"] integerValue];
    }
    
    if(![dictionary[@"city_name"] isKindOfClass:[NSNull class]]){
        self.cityName = dictionary[@"city_name"];
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
    if(![dictionary[@"province"] isKindOfClass:[NSNull class]]){
        self.province = [dictionary[@"province"] integerValue];
    }
    
    if(![dictionary[@"province_name"] isKindOfClass:[NSNull class]]){
        self.provinceName = dictionary[@"province_name"];
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
