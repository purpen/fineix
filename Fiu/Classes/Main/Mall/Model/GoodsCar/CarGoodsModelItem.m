//
//  CarGoodsModelItem.m
//  Fiu
//
//  Created by FLYang on 16/5/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CarGoodsModelItem.h"

@implementation CarGoodsModelItem

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"cover"] isKindOfClass:[NSNull class]]){
        self.cover = dictionary[@"cover"];
    }
    if (![dictionary[@"product_id"] isKindOfClass:[NSNull class]]) {
        self.productId = [dictionary[@"product_id" ] integerValue];
    }
    
    if(![dictionary[@"n"] isKindOfClass:[NSNull class]]){
        self.n = [dictionary[@"n"] integerValue];
    }
    
    if(![dictionary[@"price"] isKindOfClass:[NSNull class]]){
        self.price = [dictionary[@"price"] floatValue];
    }
    
    if(![dictionary[@"sku_mode"] isKindOfClass:[NSNull class]]){
        self.skuMode = dictionary[@"sku_mode"];
    }
    
    if(![dictionary[@"target_id"] isKindOfClass:[NSNull class]]){
        self.targetId = [dictionary[@"target_id"] integerValue];
    }
    
    if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
        self.title = dictionary[@"title"];
    }
    if(![dictionary[@"total_price"] isKindOfClass:[NSNull class]]){
        self.totalPrice = [dictionary[@"total_price"] floatValue];
    }
    
    if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
        self.type = [dictionary[@"type"] integerValue];
    }
    
    return self;
}

@end
