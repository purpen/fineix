//
//  THNChildUserModel.m
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNChildUserModel.h"

NSString *const kTHNChildUserModelIdField = @"_id";
NSString *const kTHNChildUserModelCid = @"cid";
NSString *const kTHNChildUserModelName = @"username";
NSString *const kTHNChildUserModelPhone = @"account";
NSString *const kTHNChildUserModelMoney = @"amount";
NSString *const kTHNChildUserModelAddition = @"addition";

@implementation THNChildUserModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kTHNChildUserModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kTHNChildUserModelIdField];
    }
    if(![dictionary[kTHNChildUserModelCid] isKindOfClass:[NSNull class]]){
        self.cid = dictionary[kTHNChildUserModelCid];
    }
    if(![dictionary[kTHNChildUserModelName] isKindOfClass:[NSNull class]]){
        self.name = dictionary[kTHNChildUserModelName];
    }
    if(![dictionary[kTHNChildUserModelPhone] isKindOfClass:[NSNull class]]){
        self.phone = dictionary[kTHNChildUserModelPhone];
    }
    if(![dictionary[kTHNChildUserModelMoney] isKindOfClass:[NSNull class]]){
        self.money = [dictionary[kTHNChildUserModelMoney] floatValue];
    }
    if(![dictionary[kTHNChildUserModelAddition] isKindOfClass:[NSNull class]]){
        self.addition = [dictionary[kTHNChildUserModelAddition] floatValue];
    }
    return self;
}


@end
