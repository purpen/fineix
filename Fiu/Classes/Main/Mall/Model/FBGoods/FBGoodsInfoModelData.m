//
//	FBGoodsInfoModelData.m
// on 14/7/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FBGoodsInfoModelData.h"

@interface FBGoodsInfoModelData ()
@end
@implementation FBGoodsInfoModelData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[@"_id"] integerValue];
	}

	if(![dictionary[@"advantage"] isKindOfClass:[NSNull class]]){
		self.advantage = dictionary[@"advantage"];
	}	
	if(![dictionary[@"app_appoint_count"] isKindOfClass:[NSNull class]]){
		self.appAppointCount = [dictionary[@"app_appoint_count"] integerValue];
	}

	if(![dictionary[@"app_snatched"] isKindOfClass:[NSNull class]]){
		self.appSnatched = [dictionary[@"app_snatched"] integerValue];
	}

	if(![dictionary[@"app_snatched_count"] isKindOfClass:[NSNull class]]){
		self.appSnatchedCount = [dictionary[@"app_snatched_count"] integerValue];
	}

	if(![dictionary[@"app_snatched_end_time"] isKindOfClass:[NSNull class]]){
		self.appSnatchedEndTime = [dictionary[@"app_snatched_end_time"] integerValue];
	}

	if(![dictionary[@"app_snatched_limit_count"] isKindOfClass:[NSNull class]]){
		self.appSnatchedLimitCount = [dictionary[@"app_snatched_limit_count"] integerValue];
	}

	if(![dictionary[@"app_snatched_price"] isKindOfClass:[NSNull class]]){
		self.appSnatchedPrice = [dictionary[@"app_snatched_price"] integerValue];
	}

	if(![dictionary[@"app_snatched_rest_count"] isKindOfClass:[NSNull class]]){
		self.appSnatchedRestCount = [dictionary[@"app_snatched_rest_count"] integerValue];
	}

	if(![dictionary[@"app_snatched_stat"] isKindOfClass:[NSNull class]]){
		self.appSnatchedStat = [dictionary[@"app_snatched_stat"] integerValue];
	}

	if(![dictionary[@"app_snatched_time"] isKindOfClass:[NSNull class]]){
		self.appSnatchedTime = [dictionary[@"app_snatched_time"] integerValue];
	}

	if(![dictionary[@"app_snatched_time_lag"] isKindOfClass:[NSNull class]]){
		self.appSnatchedTimeLag = [dictionary[@"app_snatched_time_lag"] integerValue];
	}

	if(![dictionary[@"app_snatched_total_count"] isKindOfClass:[NSNull class]]){
		self.appSnatchedTotalCount = [dictionary[@"app_snatched_total_count"] integerValue];
	}

	if(![dictionary[@"asset"] isKindOfClass:[NSNull class]]){
		self.asset = dictionary[@"asset"];
	}	
	if(![dictionary[@"brand"] isKindOfClass:[NSNull class]]){
		self.brand = dictionary[@"brand"];
	}	
	if(![dictionary[@"brand_id"] isKindOfClass:[NSNull class]]){
		self.brandId = dictionary[@"brand_id"];
	}	
	if(![dictionary[@"can_saled"] isKindOfClass:[NSNull class]]){
		self.canSaled = dictionary[@"can_saled"];
	}	
	if(![dictionary[@"category_id"] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[@"category_id"] integerValue];
	}

	if(![dictionary[@"category_tags"] isKindOfClass:[NSNull class]]){
		self.categoryTags = dictionary[@"category_tags"];
	}	
	if(![dictionary[@"comment_count"] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[@"comment_count"] integerValue];
	}

	if(![dictionary[@"comment_star"] isKindOfClass:[NSNull class]]){
		self.commentStar = [dictionary[@"comment_star"] integerValue];
	}

	if(![dictionary[@"content_view_url"] isKindOfClass:[NSNull class]]){
		self.contentViewUrl = dictionary[@"content_view_url"];
	}	
	if(![dictionary[@"cover_id"] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[@"cover_id"];
	}	
	if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[@"cover_url"];
	}	
	if(![dictionary[@"current_user_id"] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[@"current_user_id"] integerValue];
	}

	if(![dictionary[@"extra_info"] isKindOfClass:[NSNull class]]){
		self.extraInfo = dictionary[@"extra_info"];
	}	
	if(![dictionary[@"favorite_count"] isKindOfClass:[NSNull class]]){
		self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
	}

	if(![dictionary[@"inventory"] isKindOfClass:[NSNull class]]){
		self.inventory = [dictionary[@"inventory"] integerValue];
	}

	if(![dictionary[@"is_app_snatched"] isKindOfClass:[NSNull class]]){
		self.isAppSnatched = [dictionary[@"is_app_snatched"] integerValue];
	}

	if(![dictionary[@"is_app_snatched_alert"] isKindOfClass:[NSNull class]]){
		self.isAppSnatchedAlert = [dictionary[@"is_app_snatched_alert"] integerValue];
	}

	if(![dictionary[@"is_favorite"] isKindOfClass:[NSNull class]]){
		self.isFavorite = [dictionary[@"is_favorite"] integerValue];
	}

	if(![dictionary[@"is_love"] isKindOfClass:[NSNull class]]){
		self.isLove = [dictionary[@"is_love"] integerValue];
	}

	if(![dictionary[@"is_try"] isKindOfClass:[NSNull class]]){
		self.isTry = [dictionary[@"is_try"] integerValue];
	}

	if(![dictionary[@"love_count"] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[@"love_count"] integerValue];
	}

	if(![dictionary[@"market_price"] isKindOfClass:[NSNull class]]){
		self.marketPrice = [dictionary[@"market_price"] integerValue];
	}

	if(dictionary[@"relation_products"] != nil && [dictionary[@"relation_products"] isKindOfClass:[NSArray class]]){
		NSArray * relationProductsDictionaries = dictionary[@"relation_products"];
		NSMutableArray * relationProductsItems = [NSMutableArray array];
		for(NSDictionary * relationProductsDictionary in relationProductsDictionaries){
			FBGoodsInfoModelRelationProduct * relationProductsItem = [[FBGoodsInfoModelRelationProduct alloc] initWithDictionary:relationProductsDictionary];
			[relationProductsItems addObject:relationProductsItem];
		}
		self.relationProducts = relationProductsItems;
	}
	if(![dictionary[@"sale_price"] isKindOfClass:[NSNull class]]){
		self.salePrice = [dictionary[@"sale_price"] floatValue];
	}

	if(![dictionary[@"share_desc"] isKindOfClass:[NSNull class]]){
		self.shareDesc = dictionary[@"share_desc"];
	}	
	if(![dictionary[@"share_view_url"] isKindOfClass:[NSNull class]]){
		self.shareViewUrl = dictionary[@"share_view_url"];
	}	
	if(![dictionary[@"short_title"] isKindOfClass:[NSNull class]]){
		self.shortTitle = dictionary[@"short_title"];
	}	
	if(![dictionary[@"skus"] isKindOfClass:[NSNull class]]){
		self.skus = dictionary[@"skus"];
	}	
	if(![dictionary[@"skus_count"] isKindOfClass:[NSNull class]]){
		self.skusCount = [dictionary[@"skus_count"] integerValue];
	}

	if(![dictionary[@"snatched"] isKindOfClass:[NSNull class]]){
		self.snatched = [dictionary[@"snatched"] integerValue];
	}

	if(![dictionary[@"snatched_count"] isKindOfClass:[NSNull class]]){
		self.snatchedCount = [dictionary[@"snatched_count"] integerValue];
	}

	if(![dictionary[@"snatched_end_time"] isKindOfClass:[NSNull class]]){
		self.snatchedEndTime = [dictionary[@"snatched_end_time"] boolValue];
	}

	if(![dictionary[@"snatched_price"] isKindOfClass:[NSNull class]]){
		self.snatchedPrice = [dictionary[@"snatched_price"] integerValue];
	}

	if(![dictionary[@"snatched_time"] isKindOfClass:[NSNull class]]){
		self.snatchedTime = [dictionary[@"snatched_time"] boolValue];
	}

	if(![dictionary[@"stage"] isKindOfClass:[NSNull class]]){
		self.stage = [dictionary[@"stage"] integerValue];
	}

	if(![dictionary[@"stick"] isKindOfClass:[NSNull class]]){
		self.stick = [dictionary[@"stick"] integerValue];
	}

	if(![dictionary[@"summary"] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[@"summary"];
	}	
	if(![dictionary[@"tags"] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[@"tags"];
	}	
	if(![dictionary[@"tags_s"] isKindOfClass:[NSNull class]]){
		self.tagsS = dictionary[@"tags_s"];
	}	
	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	if(![dictionary[@"view_count"] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[@"view_count"] integerValue];
	}

	if(![dictionary[@"wap_view_url"] isKindOfClass:[NSNull class]]){
		self.wapViewUrl = dictionary[@"wap_view_url"];
	}	
	return self;
}
@end