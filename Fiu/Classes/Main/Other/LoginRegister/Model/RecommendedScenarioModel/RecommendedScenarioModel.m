//
//  RecommendedScenarioModel.m
//  Fiu
//
//  Created by THN-Dong on 16/4/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "RecommendedScenarioModel.h"

@implementation RecommendedScenarioModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.covers = dict[@"covers"];
        self.title = dict[@"title"];
        self.address = dict[@"address"];
        self.subscription_count = [dict[@"subscription_count"] intValue];
        self.id = [[dict objectForKey:@"id"] intValue];
    }
    return self;
}

@end
