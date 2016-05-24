//
//  OrderInfoModel.m
//  parrot
//
//  Created by THN-Huangfei on 15/12/24.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import "OrderInfoModel.h"

#import "ExpressInfoModel.h"

@implementation OrderInfoModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[@"_id"];
    }
    if(![dictionary[@"addbook_id"] isKindOfClass:[NSNull class]]){
        self.addbookId = dictionary[@"addbook_id"];
    }
    if(![dictionary[@"bird_coin_count"] isKindOfClass:[NSNull class]]){
        self.birdCoinCount = [dictionary[@"bird_coin_count"] integerValue];
    }
    
    if(![dictionary[@"bird_coin_money"] isKindOfClass:[NSNull class]]){
        self.birdCoinMoney = dictionary[@"bird_coin_money"];
    }
    
    if(![dictionary[@"card_code"] isKindOfClass:[NSNull class]]){
        self.cardCode = dictionary[@"card_code"];
    }
    if(![dictionary[@"card_money"] isKindOfClass:[NSNull class]]){
        self.cardMoney = dictionary[@"card_money"];
    }
    
    if(![dictionary[@"coin_money"] isKindOfClass:[NSNull class]]){
        self.coinMoney = dictionary[@"coin_money"];
    }
    
    if(![dictionary[@"created_at"] isKindOfClass:[NSNull class]]){
        self.createdAt = dictionary[@"created_at"];
    }
    
    if(![dictionary[@"discount"] isKindOfClass:[NSNull class]]){
        self.discount = dictionary[@"discount"];
    }
    
    if(![dictionary[@"expired_time"] isKindOfClass:[NSNull class]]){
        self.expiredTime = [dictionary[@"expired_time"] integerValue];
    }
    
    if(![dictionary[@"express_caty"] isKindOfClass:[NSNull class]]){
        self.expressCaty = dictionary[@"express_caty"];
    }
    if(![dictionary[@"express_info"] isKindOfClass:[NSNull class]]){
        self.expressInfo = [[ExpressInfoModel alloc] initWithDictionary:dictionary[@"express_info"]];
    }
    
    if(![dictionary[@"express_no"] isKindOfClass:[NSNull class]]){
        self.expressNo = dictionary[@"express_no"];
    }
    if(![dictionary[@"freight"] isKindOfClass:[NSNull class]]){
        self.freight = dictionary[@"freight"];
    }
    
    if(![dictionary[@"from_site"] isKindOfClass:[NSNull class]]){
        self.fromSite = [dictionary[@"from_site"] integerValue];
    }
    
    if(![dictionary[@"gift_code"] isKindOfClass:[NSNull class]]){
        self.giftCode = dictionary[@"gift_code"];
    }
    if(![dictionary[@"gift_money"] isKindOfClass:[NSNull class]]){
        self.giftMoney = dictionary[@"gift_money"];
    }
    
    if(![dictionary[@"invoice_caty"] isKindOfClass:[NSNull class]]){
        self.invoiceCaty = dictionary[@"invoice_caty"];
    }
    if(![dictionary[@"invoice_content"] isKindOfClass:[NSNull class]]){
        self.invoiceContent = dictionary[@"invoice_content"];
    }
    if(![dictionary[@"invoice_title"] isKindOfClass:[NSNull class]]){
        self.invoiceTitle = dictionary[@"invoice_title"];
    }
    if(![dictionary[@"invoice_type"] isKindOfClass:[NSNull class]]){
        self.invoiceType = [dictionary[@"invoice_type"] integerValue];
    }
    
    if(![dictionary[@"is_presaled"] isKindOfClass:[NSNull class]]){
        self.isPresaled = [dictionary[@"is_presaled"] integerValue];
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
    if(![dictionary[@"items_count"] isKindOfClass:[NSNull class]]){
        self.itemsCount = [dictionary[@"items_count"] integerValue];
    }
    
    if(![dictionary[@"pay_money"] isKindOfClass:[NSNull class]]){
        self.payMoney = dictionary[@"pay_money"];
    }
    
    if(![dictionary[@"payment_method"] isKindOfClass:[NSNull class]]){
        self.paymentMethod = dictionary[@"payment_method"];
    }
    
    if(![dictionary[@"rid"] isKindOfClass:[NSNull class]]){
        self.rid = dictionary[@"rid"];
    }
    
    if(![dictionary[@"sended_date"] isKindOfClass:[NSNull class]]){
        self.sendedDate = [dictionary[@"sended_date"] integerValue];
    }
    
    if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
        self.status = OrderInfoState([dictionary[@"status"] integerValue]);
    }
    
    if(![dictionary[@"status_label"] isKindOfClass:[NSNull class]]){
        self.statusLabel = dictionary[@"status_label"];
    }
    
    if(![dictionary[@"total_money"] isKindOfClass:[NSNull class]]){
        self.totalMoney = dictionary[@"total_money"];
    }
    
    if(![dictionary[@"user_id"] isKindOfClass:[NSNull class]]){
        self.userId = [dictionary[@"user_id"] integerValue];
    }
    
    return self;
}


@end
