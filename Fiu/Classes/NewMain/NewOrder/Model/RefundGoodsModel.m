//
//  RefundGoodsModel.m
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "RefundGoodsModel.h"

@implementation RefundGoodsModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[@"_id"];
    }
    if (![dictionary[@"content"] isKindOfClass:[NSNull class]]) {
        self.content = dictionary[@"content"];
    }
    
    if(![dictionary[@"created_at"] isKindOfClass:[NSNull class]]){
        self.createdAt = dictionary[@"created_at"];
    }
    
    if(![dictionary[@"refund_price"] isKindOfClass:[NSNull class]]){
        self.refundPrice = [dictionary[@"refund_price"] floatValue];
    }
    
    if(![dictionary[@"stage"] isKindOfClass:[NSNull class]]){
        self.stage = [dictionary[@"stage"] integerValue];
    }
    
    if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
        self.status = [dictionary[@"status"] integerValue];
    }
    if(![dictionary[@"stage_label"] isKindOfClass:[NSNull class]]){
        self.stageLabel = dictionary[@"stage_label"];
    }
    
    if(![dictionary[@"order_rid"] isKindOfClass:[NSNull class]]){
        self.rid = dictionary[@"order_rid"];
    }
    
    if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
        self.type = [dictionary[@"type"] integerValue];
    }
    
    if(![dictionary[@"product_id"] isKindOfClass:[NSNull class]]){
        self.productId = dictionary[@"product_id"];
    }
    
    if(![dictionary[@"quantity"] isKindOfClass:[NSNull class]]){
        self.quantity = [dictionary[@"quantity"] floatValue];
    }
    
    if(![dictionary[@"deleted"] isKindOfClass:[NSNull class]]){
        self.deleted = [dictionary[@"deleted"] integerValue];
    }
    
    if(![dictionary[@"product"] isKindOfClass:[NSNull class]]){
        self.product = [[ProductModel alloc] initWithDictionary:dictionary[@"product"]];
    }
    
    return self;
}

@end
