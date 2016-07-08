//
//  FiuPeopleListRow.m
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuPeopleListRow.h"

@interface FiuPeopleListRow ()

@end


@implementation FiuPeopleListRow

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.idField = [dictionary[@"_id"] integerValue];
    }
    
    if(![dictionary[@"avatar_url"] isKindOfClass:[NSNull class]]){
        self.avatarUrl = dictionary[@"avatar_url"];
    }
    
    if(![dictionary[@"nickname"] isKindOfClass:[NSNull class]]){
        self.nickname = dictionary[@"nickname"];
    }
    
    if(![dictionary[@"summary"] isKindOfClass:[NSNull class]]){
        self.summary = dictionary[@"summary"];
    }
    
    if(![dictionary[@"is_expert"] isKindOfClass:[NSNull class]]){
        self.isExpert = [dictionary[@"is_expert"] integerValue];
    }
    
    if(![dictionary[@"label"] isKindOfClass:[NSNull class]]){
        self.userLable = dictionary[@"label"];
    }
    
    if(![dictionary[@"expert_label"] isKindOfClass:[NSNull class]]){
        self.expertLabel = dictionary[@"expert_label"];
    }
    
    if(![dictionary[@"expert_info"] isKindOfClass:[NSNull class]]){
        self.expertInfo = dictionary[@"expert_info"];
    }
    
    if(![dictionary[@"rank_id"] isKindOfClass:[NSNull class]]){
        self.userRank = [dictionary[@"rank_id"] integerValue];
    }
    
    return self;
}

@end
