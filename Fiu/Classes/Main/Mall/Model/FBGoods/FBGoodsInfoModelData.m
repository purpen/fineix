//
//	FBGoodsInfoModelData.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FBGoodsInfoModelData.h"

NSString *const kFBGoodsInfoModelDataIdField = @"_id";
NSString *const kFBGoodsInfoModelDataAdvantage = @"advantage";
NSString *const kFBGoodsInfoModelDataAppAppointCount = @"app_appoint_count";
NSString *const kFBGoodsInfoModelDataAppSnatched = @"app_snatched";
NSString *const kFBGoodsInfoModelDataAppSnatchedCount = @"app_snatched_count";
NSString *const kFBGoodsInfoModelDataAppSnatchedEndTime = @"app_snatched_end_time";
NSString *const kFBGoodsInfoModelDataAppSnatchedLimitCount = @"app_snatched_limit_count";
NSString *const kFBGoodsInfoModelDataAppSnatchedPrice = @"app_snatched_price";
NSString *const kFBGoodsInfoModelDataAppSnatchedRestCount = @"app_snatched_rest_count";
NSString *const kFBGoodsInfoModelDataAppSnatchedStat = @"app_snatched_stat";
NSString *const kFBGoodsInfoModelDataAppSnatchedTime = @"app_snatched_time";
NSString *const kFBGoodsInfoModelDataAppSnatchedTimeLag = @"app_snatched_time_lag";
NSString *const kFBGoodsInfoModelDataAppSnatchedTotalCount = @"app_snatched_total_count";
NSString *const kFBGoodsInfoModelDataAsset = @"asset";
NSString *const kFBGoodsInfoModelDataBrand = @"brand";
NSString *const kFBGoodsInfoModelDataBrandId = @"brand_id";
NSString *const kFBGoodsInfoModelDataCanSaled = @"can_saled";
NSString *const kFBGoodsInfoModelDataCategoryId = @"category_id";
NSString *const kFBGoodsInfoModelDataCategoryTags = @"category_tags";
NSString *const kFBGoodsInfoModelDataCommentCount = @"comment_count";
NSString *const kFBGoodsInfoModelDataCommentStar = @"comment_star";
NSString *const kFBGoodsInfoModelDataContentViewUrl = @"content_view_url";
NSString *const kFBGoodsInfoModelDataCoverId = @"cover_id";
NSString *const kFBGoodsInfoModelDataCoverUrl = @"cover_url";
NSString *const kFBGoodsInfoModelDataCurrentUserId = @"current_user_id";
NSString *const kFBGoodsInfoModelDataExtraInfo = @"extra_info";
NSString *const kFBGoodsInfoModelDataFavoriteCount = @"favorite_count";
NSString *const kFBGoodsInfoModelDataInventory = @"inventory";
NSString *const kFBGoodsInfoModelDataIsAppSnatched = @"is_app_snatched";
NSString *const kFBGoodsInfoModelDataIsAppSnatchedAlert = @"is_app_snatched_alert";
NSString *const kFBGoodsInfoModelDataIsFavorite = @"is_favorite";
NSString *const kFBGoodsInfoModelDataIsLove = @"is_love";
NSString *const kFBGoodsInfoModelDataIsTry = @"is_try";
NSString *const kFBGoodsInfoModelDataLoveCount = @"love_count";
NSString *const kFBGoodsInfoModelDataMarketPrice = @"market_price";
NSString *const kFBGoodsInfoModelDataPngAsset = @"png_asset";
NSString *const kFBGoodsInfoModelDataRelationProducts = @"relation_products";
NSString *const kFBGoodsInfoModelDataSalePrice = @"sale_price";
NSString *const kFBGoodsInfoModelDataShareDesc = @"share_desc";
NSString *const kFBGoodsInfoModelDataShareViewUrl = @"share_view_url";
NSString *const kFBGoodsInfoModelDataShortTitle = @"short_title";
NSString *const kFBGoodsInfoModelDataSkus = @"skus";
NSString *const kFBGoodsInfoModelDataSkusCount = @"skus_count";
NSString *const kFBGoodsInfoModelDataSnatched = @"snatched";
NSString *const kFBGoodsInfoModelDataSnatchedCount = @"snatched_count";
NSString *const kFBGoodsInfoModelDataSnatchedEndTime = @"snatched_end_time";
NSString *const kFBGoodsInfoModelDataSnatchedPrice = @"snatched_price";
NSString *const kFBGoodsInfoModelDataSnatchedTime = @"snatched_time";
NSString *const kFBGoodsInfoModelDataStage = @"stage";
NSString *const kFBGoodsInfoModelDataStick = @"stick";
NSString *const kFBGoodsInfoModelDataSummary = @"summary";
NSString *const kFBGoodsInfoModelDataTags = @"tags";
NSString *const kFBGoodsInfoModelDataTagsS = @"tags_s";
NSString *const kFBGoodsInfoModelDataTitle = @"title";
NSString *const kFBGoodsInfoModelDataViewCount = @"view_count";
NSString *const kFBGoodsInfoModelDataWapViewUrl = @"wap_view_url";

@interface FBGoodsInfoModelData ()
@end
@implementation FBGoodsInfoModelData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFBGoodsInfoModelDataIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kFBGoodsInfoModelDataIdField] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAdvantage] isKindOfClass:[NSNull class]]){
		self.advantage = dictionary[kFBGoodsInfoModelDataAdvantage];
	}	
	if(![dictionary[kFBGoodsInfoModelDataAppAppointCount] isKindOfClass:[NSNull class]]){
		self.appAppointCount = [dictionary[kFBGoodsInfoModelDataAppAppointCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAppSnatched] isKindOfClass:[NSNull class]]){
		self.appSnatched = [dictionary[kFBGoodsInfoModelDataAppSnatched] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAppSnatchedCount] isKindOfClass:[NSNull class]]){
		self.appSnatchedCount = [dictionary[kFBGoodsInfoModelDataAppSnatchedCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAppSnatchedEndTime] isKindOfClass:[NSNull class]]){
		self.appSnatchedEndTime = [dictionary[kFBGoodsInfoModelDataAppSnatchedEndTime] boolValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAppSnatchedLimitCount] isKindOfClass:[NSNull class]]){
		self.appSnatchedLimitCount = [dictionary[kFBGoodsInfoModelDataAppSnatchedLimitCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAppSnatchedPrice] isKindOfClass:[NSNull class]]){
		self.appSnatchedPrice = [dictionary[kFBGoodsInfoModelDataAppSnatchedPrice] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAppSnatchedRestCount] isKindOfClass:[NSNull class]]){
		self.appSnatchedRestCount = [dictionary[kFBGoodsInfoModelDataAppSnatchedRestCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAppSnatchedStat] isKindOfClass:[NSNull class]]){
		self.appSnatchedStat = [dictionary[kFBGoodsInfoModelDataAppSnatchedStat] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAppSnatchedTime] isKindOfClass:[NSNull class]]){
		self.appSnatchedTime = [dictionary[kFBGoodsInfoModelDataAppSnatchedTime] boolValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAppSnatchedTimeLag] isKindOfClass:[NSNull class]]){
		self.appSnatchedTimeLag = [dictionary[kFBGoodsInfoModelDataAppSnatchedTimeLag] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAppSnatchedTotalCount] isKindOfClass:[NSNull class]]){
		self.appSnatchedTotalCount = [dictionary[kFBGoodsInfoModelDataAppSnatchedTotalCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataAsset] isKindOfClass:[NSNull class]]){
		self.asset = dictionary[kFBGoodsInfoModelDataAsset];
	}	
	if(![dictionary[kFBGoodsInfoModelDataBrand] isKindOfClass:[NSNull class]]){
		self.brand = [[FBGoodsInfoModelBrand alloc] initWithDictionary:dictionary[kFBGoodsInfoModelDataBrand]];
	}

	if(![dictionary[kFBGoodsInfoModelDataBrandId] isKindOfClass:[NSNull class]]){
		self.brandId = dictionary[kFBGoodsInfoModelDataBrandId];
	}	
	if(![dictionary[kFBGoodsInfoModelDataCanSaled] isKindOfClass:[NSNull class]]){
		self.canSaled = dictionary[kFBGoodsInfoModelDataCanSaled];
	}	
	if(![dictionary[kFBGoodsInfoModelDataCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[kFBGoodsInfoModelDataCategoryId] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataCategoryTags] isKindOfClass:[NSNull class]]){
		self.categoryTags = dictionary[kFBGoodsInfoModelDataCategoryTags];
	}	
	if(![dictionary[kFBGoodsInfoModelDataCommentCount] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[kFBGoodsInfoModelDataCommentCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataCommentStar] isKindOfClass:[NSNull class]]){
		self.commentStar = [dictionary[kFBGoodsInfoModelDataCommentStar] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataContentViewUrl] isKindOfClass:[NSNull class]]){
		self.contentViewUrl = dictionary[kFBGoodsInfoModelDataContentViewUrl];
	}	
	if(![dictionary[kFBGoodsInfoModelDataCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kFBGoodsInfoModelDataCoverId];
	}	
	if(![dictionary[kFBGoodsInfoModelDataCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kFBGoodsInfoModelDataCoverUrl];
	}	
	if(![dictionary[kFBGoodsInfoModelDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kFBGoodsInfoModelDataCurrentUserId] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataExtraInfo] isKindOfClass:[NSNull class]]){
		self.extraInfo = dictionary[kFBGoodsInfoModelDataExtraInfo];
	}	
	if(![dictionary[kFBGoodsInfoModelDataFavoriteCount] isKindOfClass:[NSNull class]]){
		self.favoriteCount = [dictionary[kFBGoodsInfoModelDataFavoriteCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataInventory] isKindOfClass:[NSNull class]]){
		self.inventory = [dictionary[kFBGoodsInfoModelDataInventory] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataIsAppSnatched] isKindOfClass:[NSNull class]]){
		self.isAppSnatched = [dictionary[kFBGoodsInfoModelDataIsAppSnatched] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataIsAppSnatchedAlert] isKindOfClass:[NSNull class]]){
		self.isAppSnatchedAlert = [dictionary[kFBGoodsInfoModelDataIsAppSnatchedAlert] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataIsFavorite] isKindOfClass:[NSNull class]]){
		self.isFavorite = [dictionary[kFBGoodsInfoModelDataIsFavorite] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataIsLove] isKindOfClass:[NSNull class]]){
		self.isLove = [dictionary[kFBGoodsInfoModelDataIsLove] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataIsTry] isKindOfClass:[NSNull class]]){
		self.isTry = [dictionary[kFBGoodsInfoModelDataIsTry] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataLoveCount] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[kFBGoodsInfoModelDataLoveCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataMarketPrice] isKindOfClass:[NSNull class]]){
		self.marketPrice = [dictionary[kFBGoodsInfoModelDataMarketPrice] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataPngAsset] isKindOfClass:[NSNull class]]){
		self.pngAsset = dictionary[kFBGoodsInfoModelDataPngAsset];
	}	
	if(dictionary[kFBGoodsInfoModelDataRelationProducts] != nil && [dictionary[kFBGoodsInfoModelDataRelationProducts] isKindOfClass:[NSArray class]]){
		NSArray * relationProductsDictionaries = dictionary[kFBGoodsInfoModelDataRelationProducts];
		NSMutableArray * relationProductsItems = [NSMutableArray array];
		for(NSDictionary * relationProductsDictionary in relationProductsDictionaries){
			FBGoodsInfoModelRelationProduct * relationProductsItem = [[FBGoodsInfoModelRelationProduct alloc] initWithDictionary:relationProductsDictionary];
			[relationProductsItems addObject:relationProductsItem];
		}
		self.relationProducts = relationProductsItems;
	}
	if(![dictionary[kFBGoodsInfoModelDataSalePrice] isKindOfClass:[NSNull class]]){
		self.salePrice = [dictionary[kFBGoodsInfoModelDataSalePrice] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataShareDesc] isKindOfClass:[NSNull class]]){
		self.shareDesc = dictionary[kFBGoodsInfoModelDataShareDesc];
	}	
	if(![dictionary[kFBGoodsInfoModelDataShareViewUrl] isKindOfClass:[NSNull class]]){
		self.shareViewUrl = dictionary[kFBGoodsInfoModelDataShareViewUrl];
	}	
	if(![dictionary[kFBGoodsInfoModelDataShortTitle] isKindOfClass:[NSNull class]]){
		self.shortTitle = dictionary[kFBGoodsInfoModelDataShortTitle];
	}	
	if(dictionary[kFBGoodsInfoModelDataSkus] != nil && [dictionary[kFBGoodsInfoModelDataSkus] isKindOfClass:[NSArray class]]){
		NSArray * skusDictionaries = dictionary[kFBGoodsInfoModelDataSkus];
		NSMutableArray * skusItems = [NSMutableArray array];
		for(NSDictionary * skusDictionary in skusDictionaries){
			FBGoodsInfoModelSku * skusItem = [[FBGoodsInfoModelSku alloc] initWithDictionary:skusDictionary];
			[skusItems addObject:skusItem];
		}
		self.skus = skusItems;
	}
	if(![dictionary[kFBGoodsInfoModelDataSkusCount] isKindOfClass:[NSNull class]]){
		self.skusCount = [dictionary[kFBGoodsInfoModelDataSkusCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataSnatched] isKindOfClass:[NSNull class]]){
		self.snatched = [dictionary[kFBGoodsInfoModelDataSnatched] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataSnatchedCount] isKindOfClass:[NSNull class]]){
		self.snatchedCount = [dictionary[kFBGoodsInfoModelDataSnatchedCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataSnatchedEndTime] isKindOfClass:[NSNull class]]){
		self.snatchedEndTime = [dictionary[kFBGoodsInfoModelDataSnatchedEndTime] boolValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataSnatchedPrice] isKindOfClass:[NSNull class]]){
		self.snatchedPrice = [dictionary[kFBGoodsInfoModelDataSnatchedPrice] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataSnatchedTime] isKindOfClass:[NSNull class]]){
		self.snatchedTime = [dictionary[kFBGoodsInfoModelDataSnatchedTime] boolValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataStage] isKindOfClass:[NSNull class]]){
		self.stage = [dictionary[kFBGoodsInfoModelDataStage] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataStick] isKindOfClass:[NSNull class]]){
		self.stick = [dictionary[kFBGoodsInfoModelDataStick] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kFBGoodsInfoModelDataSummary];
	}	
	if(![dictionary[kFBGoodsInfoModelDataTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kFBGoodsInfoModelDataTags];
	}	
	if(![dictionary[kFBGoodsInfoModelDataTagsS] isKindOfClass:[NSNull class]]){
		self.tagsS = dictionary[kFBGoodsInfoModelDataTagsS];
	}	
	if(![dictionary[kFBGoodsInfoModelDataTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kFBGoodsInfoModelDataTitle];
	}	
	if(![dictionary[kFBGoodsInfoModelDataViewCount] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[kFBGoodsInfoModelDataViewCount] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelDataWapViewUrl] isKindOfClass:[NSNull class]]){
		self.wapViewUrl = dictionary[kFBGoodsInfoModelDataWapViewUrl];
	}	
	return self;
}
@end