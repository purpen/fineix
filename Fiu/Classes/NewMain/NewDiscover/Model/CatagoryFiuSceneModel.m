//
//  CatagoryFiuSceneModel.m
//  Fiu
//
//  Created by FLYang on 16/7/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CatagoryFiuSceneModel.h"

@implementation CatagoryFiuSceneModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
        self.categoryTitle = dictionary[@"title"];
    }
    
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.categoryId = [dictionary[@"_id"] integerValue];
    }
    
    if(![dictionary[@"app_cover_url"] isKindOfClass:[NSNull class]]){
        self.appCoverUrl = dictionary[@"app_cover_url"];
    }
    
    return self;
}

@end
