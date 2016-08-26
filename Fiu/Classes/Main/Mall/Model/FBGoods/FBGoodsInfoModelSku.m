//
//	FBGoodsInfoModelSku.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FBGoodsInfoModelSku.h"

NSString *const kFBGoodsInfoModelSkuIdField = @"_id";
NSString *const kFBGoodsInfoModelSkuBadCount = @"bad_count";
NSString *const kFBGoodsInfoModelSkuBadTag = @"bad_tag";
NSString *const kFBGoodsInfoModelSkuCreatedOn = @"created_on";
NSString *const kFBGoodsInfoModelSkuLimitedCount = @"limited_count";
NSString *const kFBGoodsInfoModelSkuMode = @"mode";
NSString *const kFBGoodsInfoModelSkuName = @"name";
NSString *const kFBGoodsInfoModelSkuPrice = @"price";
NSString *const kFBGoodsInfoModelSkuProductId = @"product_id";
NSString *const kFBGoodsInfoModelSkuQuantity = @"quantity";
NSString *const kFBGoodsInfoModelSkuRevokeCount = @"revoke_count";
NSString *const kFBGoodsInfoModelSkuShelf = @"shelf";
NSString *const kFBGoodsInfoModelSkuSold = @"sold";
NSString *const kFBGoodsInfoModelSkuStage = @"stage";
NSString *const kFBGoodsInfoModelSkuStatus = @"status";
NSString *const kFBGoodsInfoModelSkuSummary = @"summary";
NSString *const kFBGoodsInfoModelSkuSyncCount = @"sync_count";
NSString *const kFBGoodsInfoModelSkuUpdatedOn = @"updated_on";

@interface FBGoodsInfoModelSku ()
@end
@implementation FBGoodsInfoModelSku




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFBGoodsInfoModelSkuIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kFBGoodsInfoModelSkuIdField] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuBadCount] isKindOfClass:[NSNull class]]){
		self.badCount = [dictionary[kFBGoodsInfoModelSkuBadCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuBadTag] isKindOfClass:[NSNull class]]){
		self.badTag = dictionary[kFBGoodsInfoModelSkuBadTag];
	}	
	if(![dictionary[kFBGoodsInfoModelSkuCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kFBGoodsInfoModelSkuCreatedOn] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuLimitedCount] isKindOfClass:[NSNull class]]){
		self.limitedCount = [dictionary[kFBGoodsInfoModelSkuLimitedCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuMode] isKindOfClass:[NSNull class]]){
		self.mode = dictionary[kFBGoodsInfoModelSkuMode];
	}	
	if(![dictionary[kFBGoodsInfoModelSkuName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kFBGoodsInfoModelSkuName];
	}	
	if(![dictionary[kFBGoodsInfoModelSkuPrice] isKindOfClass:[NSNull class]]){
		self.price = [dictionary[kFBGoodsInfoModelSkuPrice] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuProductId] isKindOfClass:[NSNull class]]){
		self.productId = [dictionary[kFBGoodsInfoModelSkuProductId] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuQuantity] isKindOfClass:[NSNull class]]){
		self.quantity = [dictionary[kFBGoodsInfoModelSkuQuantity] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuRevokeCount] isKindOfClass:[NSNull class]]){
		self.revokeCount = [dictionary[kFBGoodsInfoModelSkuRevokeCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuShelf] isKindOfClass:[NSNull class]]){
		self.shelf = [dictionary[kFBGoodsInfoModelSkuShelf] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuSold] isKindOfClass:[NSNull class]]){
		self.sold = [dictionary[kFBGoodsInfoModelSkuSold] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuStage] isKindOfClass:[NSNull class]]){
		self.stage = [dictionary[kFBGoodsInfoModelSkuStage] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kFBGoodsInfoModelSkuStatus] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kFBGoodsInfoModelSkuSummary];
	}	
	if(![dictionary[kFBGoodsInfoModelSkuSyncCount] isKindOfClass:[NSNull class]]){
		self.syncCount = [dictionary[kFBGoodsInfoModelSkuSyncCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelSkuUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kFBGoodsInfoModelSkuUpdatedOn] integerValue];
	}

	return self;
}
@end