//
//	FBGoodsInfoModelRelationProduct.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FBGoodsInfoModelRelationProduct.h"

NSString *const kFBGoodsInfoModelRelationProductIdField = @"_id";
NSString *const kFBGoodsInfoModelRelationProductAdvantage = @"advantage";
NSString *const kFBGoodsInfoModelRelationProductAppAppointCount = @"app_appoint_count";
NSString *const kFBGoodsInfoModelRelationProductAppSnatched = @"app_snatched";
NSString *const kFBGoodsInfoModelRelationProductAppSnatchedCount = @"app_snatched_count";
NSString *const kFBGoodsInfoModelRelationProductAppSnatchedEndTime = @"app_snatched_end_time";
NSString *const kFBGoodsInfoModelRelationProductAppSnatchedLimitCount = @"app_snatched_limit_count";
NSString *const kFBGoodsInfoModelRelationProductAppSnatchedPrice = @"app_snatched_price";
NSString *const kFBGoodsInfoModelRelationProductAppSnatchedTime = @"app_snatched_time";
NSString *const kFBGoodsInfoModelRelationProductAppSnatchedTotalCount = @"app_snatched_total_count";
NSString *const kFBGoodsInfoModelRelationProductBrandId = @"brand_id";
NSString *const kFBGoodsInfoModelRelationProductCategoryId = @"category_id";
NSString *const kFBGoodsInfoModelRelationProductCategoryTags = @"category_tags";
NSString *const kFBGoodsInfoModelRelationProductCommentCount = @"comment_count";
NSString *const kFBGoodsInfoModelRelationProductCommentStar = @"comment_star";
NSString *const kFBGoodsInfoModelRelationProductCoverId = @"cover_id";
NSString *const kFBGoodsInfoModelRelationProductCoverUrl = @"cover_url";
NSString *const kFBGoodsInfoModelRelationProductExtraInfo = @"extra_info";
NSString *const kFBGoodsInfoModelRelationProductFavoriteCount = @"favorite_count";
NSString *const kFBGoodsInfoModelRelationProductInventory = @"inventory";
NSString *const kFBGoodsInfoModelRelationProductLoveCount = @"love_count";
NSString *const kFBGoodsInfoModelRelationProductMarketPrice = @"market_price";
NSString *const kFBGoodsInfoModelRelationProductSalePrice = @"sale_price";
NSString *const kFBGoodsInfoModelRelationProductShortTitle = @"short_title";
NSString *const kFBGoodsInfoModelRelationProductSnatched = @"snatched";
NSString *const kFBGoodsInfoModelRelationProductSnatchedCount = @"snatched_count";
NSString *const kFBGoodsInfoModelRelationProductSnatchedEndTime = @"snatched_end_time";
NSString *const kFBGoodsInfoModelRelationProductSnatchedPrice = @"snatched_price";
NSString *const kFBGoodsInfoModelRelationProductSnatchedTime = @"snatched_time";
NSString *const kFBGoodsInfoModelRelationProductStage = @"stage";
NSString *const kFBGoodsInfoModelRelationProductStick = @"stick";
NSString *const kFBGoodsInfoModelRelationProductSummary = @"summary";
NSString *const kFBGoodsInfoModelRelationProductTags = @"tags";
NSString *const kFBGoodsInfoModelRelationProductTagsS = @"tags_s";
NSString *const kFBGoodsInfoModelRelationProductTitle = @"title";
NSString *const kFBGoodsInfoModelRelationProductViewCount = @"view_count";
NSString *const kFBGoodsInfoModelRelationProductWapViewUrl = @"wap_view_url";

@interface FBGoodsInfoModelRelationProduct ()
@end
@implementation FBGoodsInfoModelRelationProduct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFBGoodsInfoModelRelationProductIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kFBGoodsInfoModelRelationProductIdField] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductAdvantage] isKindOfClass:[NSNull class]]){
		self.advantage = dictionary[kFBGoodsInfoModelRelationProductAdvantage];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductAppAppointCount] isKindOfClass:[NSNull class]]){
		self.appAppointCount = [dictionary[kFBGoodsInfoModelRelationProductAppAppointCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductAppSnatched] isKindOfClass:[NSNull class]]){
		self.appSnatched = [dictionary[kFBGoodsInfoModelRelationProductAppSnatched] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductAppSnatchedCount] isKindOfClass:[NSNull class]]){
		self.appSnatchedCount = [dictionary[kFBGoodsInfoModelRelationProductAppSnatchedCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductAppSnatchedEndTime] isKindOfClass:[NSNull class]]){
		self.appSnatchedEndTime = [dictionary[kFBGoodsInfoModelRelationProductAppSnatchedEndTime] boolValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductAppSnatchedLimitCount] isKindOfClass:[NSNull class]]){
		self.appSnatchedLimitCount = [dictionary[kFBGoodsInfoModelRelationProductAppSnatchedLimitCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductAppSnatchedPrice] isKindOfClass:[NSNull class]]){
		self.appSnatchedPrice = [dictionary[kFBGoodsInfoModelRelationProductAppSnatchedPrice] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductAppSnatchedTime] isKindOfClass:[NSNull class]]){
		self.appSnatchedTime = [dictionary[kFBGoodsInfoModelRelationProductAppSnatchedTime] boolValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductAppSnatchedTotalCount] isKindOfClass:[NSNull class]]){
		self.appSnatchedTotalCount = [dictionary[kFBGoodsInfoModelRelationProductAppSnatchedTotalCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductBrandId] isKindOfClass:[NSNull class]]){
		self.brandId = dictionary[kFBGoodsInfoModelRelationProductBrandId];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[kFBGoodsInfoModelRelationProductCategoryId] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductCategoryTags] isKindOfClass:[NSNull class]]){
		self.categoryTags = dictionary[kFBGoodsInfoModelRelationProductCategoryTags];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductCommentCount] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[kFBGoodsInfoModelRelationProductCommentCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductCommentStar] isKindOfClass:[NSNull class]]){
		self.commentStar = [dictionary[kFBGoodsInfoModelRelationProductCommentStar] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kFBGoodsInfoModelRelationProductCoverId];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kFBGoodsInfoModelRelationProductCoverUrl];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductExtraInfo] isKindOfClass:[NSNull class]]){
		self.extraInfo = dictionary[kFBGoodsInfoModelRelationProductExtraInfo];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductFavoriteCount] isKindOfClass:[NSNull class]]){
		self.favoriteCount = [dictionary[kFBGoodsInfoModelRelationProductFavoriteCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductInventory] isKindOfClass:[NSNull class]]){
		self.inventory = [dictionary[kFBGoodsInfoModelRelationProductInventory] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductLoveCount] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[kFBGoodsInfoModelRelationProductLoveCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductMarketPrice] isKindOfClass:[NSNull class]]){
		self.marketPrice = [dictionary[kFBGoodsInfoModelRelationProductMarketPrice] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductSalePrice] isKindOfClass:[NSNull class]]){
		self.salePrice = [dictionary[kFBGoodsInfoModelRelationProductSalePrice] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductShortTitle] isKindOfClass:[NSNull class]]){
		self.shortTitle = dictionary[kFBGoodsInfoModelRelationProductShortTitle];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductSnatched] isKindOfClass:[NSNull class]]){
		self.snatched = [dictionary[kFBGoodsInfoModelRelationProductSnatched] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductSnatchedCount] isKindOfClass:[NSNull class]]){
		self.snatchedCount = [dictionary[kFBGoodsInfoModelRelationProductSnatchedCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductSnatchedEndTime] isKindOfClass:[NSNull class]]){
		self.snatchedEndTime = [dictionary[kFBGoodsInfoModelRelationProductSnatchedEndTime] boolValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductSnatchedPrice] isKindOfClass:[NSNull class]]){
		self.snatchedPrice = [dictionary[kFBGoodsInfoModelRelationProductSnatchedPrice] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductSnatchedTime] isKindOfClass:[NSNull class]]){
		self.snatchedTime = [dictionary[kFBGoodsInfoModelRelationProductSnatchedTime] boolValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductStage] isKindOfClass:[NSNull class]]){
		self.stage = [dictionary[kFBGoodsInfoModelRelationProductStage] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductStick] isKindOfClass:[NSNull class]]){
		self.stick = [dictionary[kFBGoodsInfoModelRelationProductStick] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kFBGoodsInfoModelRelationProductSummary];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kFBGoodsInfoModelRelationProductTags];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductTagsS] isKindOfClass:[NSNull class]]){
		self.tagsS = dictionary[kFBGoodsInfoModelRelationProductTagsS];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kFBGoodsInfoModelRelationProductTitle];
	}	
	if(![dictionary[kFBGoodsInfoModelRelationProductViewCount] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[kFBGoodsInfoModelRelationProductViewCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelRelationProductWapViewUrl] isKindOfClass:[NSNull class]]){
		self.wapViewUrl = dictionary[kFBGoodsInfoModelRelationProductWapViewUrl];
	}	
	return self;
}
@end