//
//  BonusModel.m
//  Fiu
//
//  Created by THN-Dong on 16/5/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BonusModel.h"

@implementation BonusModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if(![dictionary[@"amount"] isKindOfClass:[NSNull class]]){
        self.amount = dictionary[@"amount"];
    }
    
    if(![dictionary[@"code"] isKindOfClass:[NSNull class]]){
        self.code = dictionary[@"code"];
    }

    if(![dictionary[@"expired_label"] isKindOfClass:[NSNull class]]){
        self.expiredLabel = dictionary[@"expired_label"];
    }
    
    if(![dictionary[@"min_amount"] isKindOfClass:[NSNull class]]){
        self.minAmount = dictionary[@"min_amount"];
    }

    return self;
}

@end