//
//  OrderItems.m
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "OrderItems.h"

@implementation OrderItems

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"cover"] isKindOfClass:[NSNull class]]){
        self.cover = dictionary[@"cover"];
    }
    if(![dictionary[@"price"] isKindOfClass:[NSNull class]]){
        self.price = [dictionary[@"price"] integerValue];
    }
    
    if(![dictionary[@"product_id"] isKindOfClass:[NSNull class]]){
        self.productId = [dictionary[@"product_id"] integerValue];
    }
    
    if(![dictionary[@"quantity"] isKindOfClass:[NSNull class]]){
        self.quantity = [dictionary[@"quantity"] integerValue];
    }
    
    if(![dictionary[@"sale_price"] isKindOfClass:[NSNull class]]){
        self.salePrice = [dictionary[@"sale_price"] floatValue];
    }
    
    if(![dictionary[@"sku"] isKindOfClass:[NSNull class]]){
        self.sku = [dictionary[@"sku"] integerValue];
    }
    
    if(![dictionary[@"subtotal"] isKindOfClass:[NSNull class]]){
        self.subtotal = [dictionary[@"subtotal"] floatValue];
    }
    
    if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
        self.title = dictionary[@"title"];
    }
    if(![dictionary[@"view_url"] isKindOfClass:[NSNull class]]){
        self.viewUrl = dictionary[@"view_url"];
    }if(![dictionary[@"sku_name"] isKindOfClass:[NSNull class]]){
        self.skuMode = dictionary[@"sku_mode"];
    }
    return self;
}


@end
