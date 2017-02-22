//
//	THNTradingInfoData.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNTradingInfoData.h"

NSString *const kTHNTradingInfoDataIdField = @"_id";
NSString *const kTHNTradingInfoDataAllianceId = @"alliance_id";
NSString *const kTHNTradingInfoDataBalanceOn = @"balance_on";
NSString *const kTHNTradingInfoDataCode = @"code";
NSString *const kTHNTradingInfoDataCommisionPercent = @"commision_percent";
NSString *const kTHNTradingInfoDataCreatedAt = @"created_at";
NSString *const kTHNTradingInfoDataCreatedOn = @"created_on";
NSString *const kTHNTradingInfoDataCurrentUserId = @"current_user_id";
NSString *const kTHNTradingInfoDataFromSite = @"from_site";
NSString *const kTHNTradingInfoDataKind = @"kind";
NSString *const kTHNTradingInfoDataOrderRid = @"order_rid";
NSString *const kTHNTradingInfoDataProduct = @"product";
NSString *const kTHNTradingInfoDataProductId = @"product_id";
NSString *const kTHNTradingInfoDataQuantity = @"quantity";
NSString *const kTHNTradingInfoDataSkuId = @"sku_id";
NSString *const kTHNTradingInfoDataSkuPrice = @"sku_price";
NSString *const kTHNTradingInfoDataStage = @"stage";
NSString *const kTHNTradingInfoDataStatus = @"status";
NSString *const kTHNTradingInfoDataStatusLabel = @"status_label";
NSString *const kTHNTradingInfoDataSubOrderId = @"sub_order_id";
NSString *const kTHNTradingInfoDataSummary = @"summary";
NSString *const kTHNTradingInfoDataTitle = @"title";
NSString *const kTHNTradingInfoDataTotalPrice = @"total_price";
NSString *const kTHNTradingInfoDataType = @"type";
NSString *const kTHNTradingInfoDataUnitPrice = @"unit_price";
NSString *const kTHNTradingInfoDataUpdatedOn = @"updated_on";
NSString *const kTHNTradingInfoDataUserId = @"user_id";

@interface THNTradingInfoData ()
@end
@implementation THNTradingInfoData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNTradingInfoDataIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kTHNTradingInfoDataIdField];
	}	
	if(![dictionary[kTHNTradingInfoDataAllianceId] isKindOfClass:[NSNull class]]){
		self.allianceId = dictionary[kTHNTradingInfoDataAllianceId];
	}	
	if(![dictionary[kTHNTradingInfoDataBalanceOn] isKindOfClass:[NSNull class]]){
		self.balanceOn = [dictionary[kTHNTradingInfoDataBalanceOn] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataCode] isKindOfClass:[NSNull class]]){
		self.code = dictionary[kTHNTradingInfoDataCode];
	}	
	if(![dictionary[kTHNTradingInfoDataCommisionPercent] isKindOfClass:[NSNull class]]){
		self.commisionPercent = [dictionary[kTHNTradingInfoDataCommisionPercent] floatValue];
	}

	if(![dictionary[kTHNTradingInfoDataCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = dictionary[kTHNTradingInfoDataCreatedAt];
	}	
	if(![dictionary[kTHNTradingInfoDataCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kTHNTradingInfoDataCreatedOn] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNTradingInfoDataCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataFromSite] isKindOfClass:[NSNull class]]){
		self.fromSite = [dictionary[kTHNTradingInfoDataFromSite] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataKind] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[kTHNTradingInfoDataKind] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataOrderRid] isKindOfClass:[NSNull class]]){
		self.orderRid = dictionary[kTHNTradingInfoDataOrderRid];
	}	
	if(![dictionary[kTHNTradingInfoDataProduct] isKindOfClass:[NSNull class]]){
		self.product = [[THNTradingInfoProduct alloc] initWithDictionary:dictionary[kTHNTradingInfoDataProduct]];
	}

	if(![dictionary[kTHNTradingInfoDataProductId] isKindOfClass:[NSNull class]]){
		self.productId = [dictionary[kTHNTradingInfoDataProductId] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataQuantity] isKindOfClass:[NSNull class]]){
		self.quantity = [dictionary[kTHNTradingInfoDataQuantity] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataSkuId] isKindOfClass:[NSNull class]]){
		self.skuId = [dictionary[kTHNTradingInfoDataSkuId] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataSkuPrice] isKindOfClass:[NSNull class]]){
		self.skuPrice = [dictionary[kTHNTradingInfoDataSkuPrice] floatValue];
	}

	if(![dictionary[kTHNTradingInfoDataStage] isKindOfClass:[NSNull class]]){
		self.stage = [dictionary[kTHNTradingInfoDataStage] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNTradingInfoDataStatus] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataStatusLabel] isKindOfClass:[NSNull class]]){
		self.statusLabel = dictionary[kTHNTradingInfoDataStatusLabel];
	}	
	if(![dictionary[kTHNTradingInfoDataSubOrderId] isKindOfClass:[NSNull class]]){
		self.subOrderId = dictionary[kTHNTradingInfoDataSubOrderId];
	}	
    if(![dictionary[kTHNTradingInfoDataSummary] isKindOfClass:[NSNull class]]){
        self.summary = dictionary[kTHNTradingInfoDataSummary];
    }
    if(![dictionary[kTHNTradingInfoDataTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kTHNTradingInfoDataTitle];
    }
	if(![dictionary[kTHNTradingInfoDataTotalPrice] isKindOfClass:[NSNull class]]){
		self.totalPrice = [dictionary[kTHNTradingInfoDataTotalPrice] floatValue];
	}

	if(![dictionary[kTHNTradingInfoDataType] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[kTHNTradingInfoDataType] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataUnitPrice] isKindOfClass:[NSNull class]]){
		self.unitPrice = [dictionary[kTHNTradingInfoDataUnitPrice] floatValue];
	}

	if(![dictionary[kTHNTradingInfoDataUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kTHNTradingInfoDataUpdatedOn] integerValue];
	}

	if(![dictionary[kTHNTradingInfoDataUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kTHNTradingInfoDataUserId] integerValue];
	}

	return self;
}
@end
