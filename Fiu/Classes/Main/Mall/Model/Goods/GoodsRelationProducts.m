//
//  GoodsRelationProducts.m
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsRelationProducts.h"

@interface GoodsRelationProducts ()
@end

@implementation GoodsRelationProducts

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[@"_id"];
    }
    if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
        self.coverUrl = dictionary[@"cover_url"];
    }
    
    if(![dictionary[@"sale_price"] isKindOfClass:[NSNull class]]){
        self.salePrice = [dictionary[@"sale_price"] floatValue];
    }
    if(![dictionary[@"advantage"] isKindOfClass:[NSNull class]]){
        self.title = dictionary[@"advantage"];
    }
    
    return self;
}


@end
