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
//    if(![dictionary[@"area"] isKindOfClass:[NSNull class]]){
//        self.area = dictionary[@"area"];
//    }
    if(![dictionary[@"city"] isKindOfClass:[NSNull class]]){
        self.city = dictionary[@"city"];
    }
//    if(![dictionary[@"email"] isKindOfClass:[NSNull class]]){
//        self.email = dictionary[@"email"];
//    }
    if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
        self.name = dictionary[@"name"];
    }
    if(![dictionary[@"phone"] isKindOfClass:[NSNull class]]){
        self.phone = dictionary[@"phone"];
    }
    if(![dictionary[@"province"] isKindOfClass:[NSNull class]]){
        self.province = dictionary[@"province"];
    }
    if(![dictionary[@"zip"] isKindOfClass:[NSNull class]]){
        self.zip = [dictionary[@"zip"] integerValue];
    }
    
    return self;
}

@end
