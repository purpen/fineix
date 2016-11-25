//
//  SubOrderModel.m
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SubOrderModel.h"

@implementation SubOrderModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];

    if(![dictionary[@"is_sended"] isKindOfClass:[NSNull class]]){
        self.isSended = [dictionary[@"is_sended"] integerValue];
    }
    
    if(![dictionary[@"express_company"] isKindOfClass:[NSNull class]]){
        self.expressCompany = dictionary[@"express_company"];
    }
    
    if(![dictionary[@"express_caty"] isKindOfClass:[NSNull class]]){
        self.expressCaty = dictionary[@"express_caty"];
    }
    
    if(![dictionary[@"express_no"] isKindOfClass:[NSNull class]]){
        self.expressNo = dictionary[@"express_no"];
    }
    
    if(dictionary[@"items"] != nil && [dictionary[@"items"] isKindOfClass:[NSArray class]]){
        NSArray * itemsDictionaries = dictionary[@"items"];
        NSMutableArray * itemsItems = [NSMutableArray array];
        for(NSDictionary * itemsDictionary in itemsDictionaries){
            ProductInfoModel * productInfo = [[ProductInfoModel alloc] initWithDictionary:itemsDictionary];
            [itemsItems addObject:productInfo];
        }
        self.productInfos = itemsItems;
    }

    if(![dictionary[@"id"] isKindOfClass:[NSNull class]]){
        self.rid = dictionary[@"id"];
    }

    return self;
}


@end
