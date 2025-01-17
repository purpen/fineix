//
//  ProductInfoModel.m
//  parrot
//
//  Created by THN-Huangfei on 15/12/24.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "ProductInfoModel.h"

@implementation ProductInfoModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
        self.coverUrl = dictionary[@"cover_url"];
    }
    
    if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
        self.name = dictionary[@"name"];
    }
    
    if(![dictionary[@"sku_name"] isKindOfClass:[NSNull class]]){
        self.skuName = dictionary[@"sku_name"];
    }
    
    if(![dictionary[@"refund_label"] isKindOfClass:[NSNull class]]){
        self.refundLabel= dictionary[@"refund_label"];
    }
    
    if(![dictionary[@"price"] isKindOfClass:[NSNull class]]){
        self.price = dictionary[@"price"];
    }
    
    if(![dictionary[@"product_id"] isKindOfClass:[NSNull class]]){
        self.productId = dictionary[@"product_id"];
    }
    
    if(![dictionary[@"refund_status"] isKindOfClass:[NSNull class]]){
        self.refundStatus = [dictionary[@"refund_status"] integerValue];
    }
    
    if(![dictionary[@"refund_type"] isKindOfClass:[NSNull class]]){
        self.refundType = [dictionary[@"refund_type"] integerValue];
    }
    
    if(![dictionary[@"refund_button"] isKindOfClass:[NSNull class]]){
        self.refundButton = [dictionary[@"refund_button"] integerValue];
    }
    
    if(![dictionary[@"vop_id"] isKindOfClass:[NSNull class]]){
        self.vopId = [dictionary[@"vop_id"] integerValue];
    }
    
    if(![dictionary[@"quantity"] isKindOfClass:[NSNull class]]){
        self.quantity = [dictionary[@"quantity"] integerValue];
    }
    
    if(![dictionary[@"sale_price"] isKindOfClass:[NSNull class]]){
        self.salePrice = dictionary[@"sale_price"];
    }
    
    if(![dictionary[@"sku"] isKindOfClass:[NSNull class]]){
        self.sku = [dictionary[@"sku"] integerValue];
    }
    
    return self;
}

@end
