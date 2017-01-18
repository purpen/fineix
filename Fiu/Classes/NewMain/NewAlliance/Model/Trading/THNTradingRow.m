//
//	THNTradingRow.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNTradingRow.h"

NSString *const kTHNTradingRowIdField = @"_id";
NSString *const kTHNTradingRowAllianceId = @"alliance_id";
NSString *const kTHNTradingRowBalanceOn = @"balance_on";
NSString *const kTHNTradingRowCode = @"code";
NSString *const kTHNTradingRowCommisionPercent = @"commision_percent";
NSString *const kTHNTradingRowCreatedAt = @"created_at";
NSString *const kTHNTradingRowCreatedOn = @"created_on";
NSString *const kTHNTradingRowFromSite = @"from_site";
NSString *const kTHNTradingRowKind = @"kind";
NSString *const kTHNTradingRowOrderRid = @"order_rid";
NSString *const kTHNTradingRowProductId = @"product_id";
NSString *const kTHNTradingRowQuantity = @"quantity";
NSString *const kTHNTradingRowSkuId = @"sku_id";
NSString *const kTHNTradingRowStage = @"stage";
NSString *const kTHNTradingRowStatus = @"status";
NSString *const kTHNTradingRowStatusLabel = @"status_label";
NSString *const kTHNTradingRowSubOrderId = @"sub_order_id";
NSString *const kTHNTradingRowSummary = @"summary";
NSString *const kTHNTradingRowTotalPrice = @"total_price";
NSString *const kTHNTradingRowType = @"type";
NSString *const kTHNTradingRowUnitPrice = @"unit_price";
NSString *const kTHNTradingRowUpdatedOn = @"updated_on";
NSString *const kTHNTradingRowUserId = @"user_id";

@interface THNTradingRow ()
@end
@implementation THNTradingRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNTradingRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kTHNTradingRowIdField];
	}	
	if(![dictionary[kTHNTradingRowAllianceId] isKindOfClass:[NSNull class]]){
		self.allianceId = dictionary[kTHNTradingRowAllianceId];
	}	
	if(![dictionary[kTHNTradingRowBalanceOn] isKindOfClass:[NSNull class]]){
		self.balanceOn = [dictionary[kTHNTradingRowBalanceOn] integerValue];
	}

	if(![dictionary[kTHNTradingRowCode] isKindOfClass:[NSNull class]]){
		self.code = dictionary[kTHNTradingRowCode];
	}	
	if(![dictionary[kTHNTradingRowCommisionPercent] isKindOfClass:[NSNull class]]){
		self.commisionPercent = [dictionary[kTHNTradingRowCommisionPercent] floatValue];
	}

	if(![dictionary[kTHNTradingRowCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = dictionary[kTHNTradingRowCreatedAt];
	}	
	if(![dictionary[kTHNTradingRowCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kTHNTradingRowCreatedOn] integerValue];
	}

	if(![dictionary[kTHNTradingRowFromSite] isKindOfClass:[NSNull class]]){
		self.fromSite = [dictionary[kTHNTradingRowFromSite] integerValue];
	}

	if(![dictionary[kTHNTradingRowKind] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[kTHNTradingRowKind] integerValue];
	}

	if(![dictionary[kTHNTradingRowOrderRid] isKindOfClass:[NSNull class]]){
		self.orderRid = dictionary[kTHNTradingRowOrderRid];
	}	
	if(![dictionary[kTHNTradingRowProductId] isKindOfClass:[NSNull class]]){
		self.productId = [dictionary[kTHNTradingRowProductId] integerValue];
	}

	if(![dictionary[kTHNTradingRowQuantity] isKindOfClass:[NSNull class]]){
		self.quantity = [dictionary[kTHNTradingRowQuantity] integerValue];
	}

	if(![dictionary[kTHNTradingRowSkuId] isKindOfClass:[NSNull class]]){
		self.skuId = [dictionary[kTHNTradingRowSkuId] integerValue];
	}

	if(![dictionary[kTHNTradingRowStage] isKindOfClass:[NSNull class]]){
		self.stage = [dictionary[kTHNTradingRowStage] integerValue];
	}

	if(![dictionary[kTHNTradingRowStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNTradingRowStatus] integerValue];
	}

	if(![dictionary[kTHNTradingRowStatusLabel] isKindOfClass:[NSNull class]]){
		self.statusLabel = dictionary[kTHNTradingRowStatusLabel];
	}	
	if(![dictionary[kTHNTradingRowSubOrderId] isKindOfClass:[NSNull class]]){
		self.subOrderId = [dictionary[kTHNTradingRowSubOrderId] integerValue];
	}

	if(![dictionary[kTHNTradingRowSummary] isKindOfClass:[NSNull class]]){
		self.summary = [dictionary[kTHNTradingRowSummary] integerValue];
	}

	if(![dictionary[kTHNTradingRowTotalPrice] isKindOfClass:[NSNull class]]){
		self.totalPrice = [dictionary[kTHNTradingRowTotalPrice] floatValue];
	}

	if(![dictionary[kTHNTradingRowType] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[kTHNTradingRowType] integerValue];
	}

	if(![dictionary[kTHNTradingRowUnitPrice] isKindOfClass:[NSNull class]]){
		self.unitPrice = [dictionary[kTHNTradingRowUnitPrice] floatValue];
	}

	if(![dictionary[kTHNTradingRowUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kTHNTradingRowUpdatedOn] integerValue];
	}

	if(![dictionary[kTHNTradingRowUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kTHNTradingRowUserId] integerValue];
	}

	return self;
}
@end