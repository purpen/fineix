//
//  ProductModel.m
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
        self.coverUrl = dictionary[@"cover_url"];
    }
    if(![dictionary[@"quantity"] isKindOfClass:[NSNull class]]){
        self.quantity = [dictionary[@"quantity"] integerValue];
    }
    
    if(![dictionary[@"sale_price"] isKindOfClass:[NSNull class]]){
        self.salePrice = [dictionary[@"sale_price"] floatValue];
    }
    
    if(![dictionary[@"sku_name"] isKindOfClass:[NSNull class]]){
        self.skuName = dictionary[@"sku_name"];
    }

    if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
        self.title = dictionary[@"title"];
    }

    return self;
}

@end
