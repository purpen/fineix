//
//	THNSettlementInfoBalance.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNSettlementInfoBalance.h"

NSString *const kTHNSettlementInfoBalanceExtend = @"__extend__";
NSString *const kTHNSettlementInfoBalanceIdField = @"_id";
NSString *const kTHNSettlementInfoBalanceAddition = @"addition";
NSString *const kTHNSettlementInfoBalanceAllianceId = @"alliance_id";
NSString *const kTHNSettlementInfoBalanceBalanceOn = @"balance_on";
NSString *const kTHNSettlementInfoBalanceCode = @"code";
NSString *const kTHNSettlementInfoBalanceCommisionPercent = @"commision_percent";
NSString *const kTHNSettlementInfoBalanceCommisionPercentP = @"commision_percent_p";
NSString *const kTHNSettlementInfoBalanceCreatedOn = @"created_on";
NSString *const kTHNSettlementInfoBalanceFromSite = @"from_site";
NSString *const kTHNSettlementInfoBalanceKind = @"kind";
NSString *const kTHNSettlementInfoBalanceKindLabel = @"kind_label";
NSString *const kTHNSettlementInfoBalanceOrderRid = @"order_rid";
NSString *const kTHNSettlementInfoBalanceProduct = @"product";
NSString *const kTHNSettlementInfoBalanceProductId = @"product_id";
NSString *const kTHNSettlementInfoBalanceQuantity = @"quantity";
NSString *const kTHNSettlementInfoBalanceSkuId = @"sku_id";
NSString *const kTHNSettlementInfoBalanceSkuPrice = @"sku_price";
NSString *const kTHNSettlementInfoBalanceStage = @"stage";
NSString *const kTHNSettlementInfoBalanceStageLabel = @"stage_label";
NSString *const kTHNSettlementInfoBalanceStatus = @"status";
NSString *const kTHNSettlementInfoBalanceStatusLabel = @"status_label";
NSString *const kTHNSettlementInfoBalanceSubOrderId = @"sub_order_id";
NSString *const kTHNSettlementInfoBalanceSummary = @"summary";
NSString *const kTHNSettlementInfoBalanceTotalPrice = @"total_price";
NSString *const kTHNSettlementInfoBalanceType = @"type";
NSString *const kTHNSettlementInfoBalanceTypeLabel = @"type_label";
NSString *const kTHNSettlementInfoBalanceUnitPrice = @"unit_price";
NSString *const kTHNSettlementInfoBalanceUpdatedOn = @"updated_on";
NSString *const kTHNSettlementInfoBalanceUserId = @"user_id";

@interface THNSettlementInfoBalance ()
@end
@implementation THNSettlementInfoBalance




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNSettlementInfoBalanceExtend] isKindOfClass:[NSNull class]]){
		self.extend = [dictionary[kTHNSettlementInfoBalanceExtend] boolValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kTHNSettlementInfoBalanceIdField];
	}	
	if(![dictionary[kTHNSettlementInfoBalanceAddition] isKindOfClass:[NSNull class]]){
		self.addition = [dictionary[kTHNSettlementInfoBalanceAddition] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceAllianceId] isKindOfClass:[NSNull class]]){
		self.allianceId = dictionary[kTHNSettlementInfoBalanceAllianceId];
	}	
	if(![dictionary[kTHNSettlementInfoBalanceBalanceOn] isKindOfClass:[NSNull class]]){
		self.balanceOn = [dictionary[kTHNSettlementInfoBalanceBalanceOn] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceCode] isKindOfClass:[NSNull class]]){
		self.code = dictionary[kTHNSettlementInfoBalanceCode];
	}	
	if(![dictionary[kTHNSettlementInfoBalanceCommisionPercent] isKindOfClass:[NSNull class]]){
		self.commisionPercent = [dictionary[kTHNSettlementInfoBalanceCommisionPercent] floatValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceCommisionPercentP] isKindOfClass:[NSNull class]]){
		self.commisionPercentP = [dictionary[kTHNSettlementInfoBalanceCommisionPercentP] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kTHNSettlementInfoBalanceCreatedOn] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceFromSite] isKindOfClass:[NSNull class]]){
		self.fromSite = [dictionary[kTHNSettlementInfoBalanceFromSite] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceKind] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[kTHNSettlementInfoBalanceKind] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceKindLabel] isKindOfClass:[NSNull class]]){
		self.kindLabel = dictionary[kTHNSettlementInfoBalanceKindLabel];
	}	
	if(![dictionary[kTHNSettlementInfoBalanceOrderRid] isKindOfClass:[NSNull class]]){
		self.orderRid = dictionary[kTHNSettlementInfoBalanceOrderRid];
	}	
	if(![dictionary[kTHNSettlementInfoBalanceProduct] isKindOfClass:[NSNull class]]){
		self.product = [[THNSettlementInfoProduct alloc] initWithDictionary:dictionary[kTHNSettlementInfoBalanceProduct]];
	}

	if(![dictionary[kTHNSettlementInfoBalanceProductId] isKindOfClass:[NSNull class]]){
		self.productId = [dictionary[kTHNSettlementInfoBalanceProductId] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceQuantity] isKindOfClass:[NSNull class]]){
		self.quantity = [dictionary[kTHNSettlementInfoBalanceQuantity] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceSkuId] isKindOfClass:[NSNull class]]){
		self.skuId = [dictionary[kTHNSettlementInfoBalanceSkuId] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceSkuPrice] isKindOfClass:[NSNull class]]){
		self.skuPrice = [dictionary[kTHNSettlementInfoBalanceSkuPrice] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceStage] isKindOfClass:[NSNull class]]){
		self.stage = [dictionary[kTHNSettlementInfoBalanceStage] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceStageLabel] isKindOfClass:[NSNull class]]){
		self.stageLabel = dictionary[kTHNSettlementInfoBalanceStageLabel];
	}	
	if(![dictionary[kTHNSettlementInfoBalanceStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNSettlementInfoBalanceStatus] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceStatusLabel] isKindOfClass:[NSNull class]]){
		self.statusLabel = dictionary[kTHNSettlementInfoBalanceStatusLabel];
	}	
	if(![dictionary[kTHNSettlementInfoBalanceSubOrderId] isKindOfClass:[NSNull class]]){
		self.subOrderId = dictionary[kTHNSettlementInfoBalanceSubOrderId];
	}	
	if(![dictionary[kTHNSettlementInfoBalanceSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kTHNSettlementInfoBalanceSummary];
	}	
	if(![dictionary[kTHNSettlementInfoBalanceTotalPrice] isKindOfClass:[NSNull class]]){
		self.totalPrice = [dictionary[kTHNSettlementInfoBalanceTotalPrice] floatValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceType] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[kTHNSettlementInfoBalanceType] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceTypeLabel] isKindOfClass:[NSNull class]]){
		self.typeLabel = dictionary[kTHNSettlementInfoBalanceTypeLabel];
	}	
	if(![dictionary[kTHNSettlementInfoBalanceUnitPrice] isKindOfClass:[NSNull class]]){
		self.unitPrice = [dictionary[kTHNSettlementInfoBalanceUnitPrice] floatValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kTHNSettlementInfoBalanceUpdatedOn] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoBalanceUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kTHNSettlementInfoBalanceUserId] integerValue];
	}

	return self;
}
@end
