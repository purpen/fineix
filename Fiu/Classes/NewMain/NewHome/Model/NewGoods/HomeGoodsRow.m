//
//	HomeGoodsRow.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HomeGoodsRow.h"

NSString *const kHomeGoodsRowIdField = @"_id";
NSString *const kHomeGoodsRowAdvantage = @"advantage";
NSString *const kHomeGoodsRowAppAppointCount = @"app_appoint_count";
NSString *const kHomeGoodsRowAppSnatched = @"app_snatched";
NSString *const kHomeGoodsRowAppSnatchedCount = @"app_snatched_count";
NSString *const kHomeGoodsRowAppSnatchedEndTime = @"app_snatched_end_time";
NSString *const kHomeGoodsRowAppSnatchedPrice = @"app_snatched_price";
NSString *const kHomeGoodsRowAppSnatchedTime = @"app_snatched_time";
NSString *const kHomeGoodsRowAppSnatchedTotalCount = @"app_snatched_total_count";
NSString *const kHomeGoodsRowBrandId = @"brand_id";
NSString *const kHomeGoodsRowCategoryId = @"category_id";
NSString *const kHomeGoodsRowCategoryIds = @"category_ids";
NSString *const kHomeGoodsRowCategoryTags = @"category_tags";
NSString *const kHomeGoodsRowCommentCount = @"comment_count";
NSString *const kHomeGoodsRowCommentStar = @"comment_star";
NSString *const kHomeGoodsRowContentViewUrl = @"content_view_url";
NSString *const kHomeGoodsRowCoverId = @"cover_id";
NSString *const kHomeGoodsRowCoverUrl = @"cover_url";
NSString *const kHomeGoodsRowCreatedOn = @"created_on";
NSString *const kHomeGoodsRowDeleted = @"deleted";
NSString *const kHomeGoodsRowFavoriteCount = @"favorite_count";
NSString *const kHomeGoodsRowFeatured = @"featured";
NSString *const kHomeGoodsRowInventory = @"inventory";
NSString *const kHomeGoodsRowIsAppSnatched = @"is_app_snatched";
NSString *const kHomeGoodsRowLoveCount = @"love_count";
NSString *const kHomeGoodsRowMarketPrice = @"market_price";
NSString *const kHomeGoodsRowPresaleFinishTime = @"presale_finish_time";
NSString *const kHomeGoodsRowPresaleGoals = @"presale_goals";
NSString *const kHomeGoodsRowPresaleMoney = @"presale_money";
NSString *const kHomeGoodsRowPresalePeople = @"presale_people";
NSString *const kHomeGoodsRowPresalePercent = @"presale_percent";
NSString *const kHomeGoodsRowSalePrice = @"sale_price";
NSString *const kHomeGoodsRowShortTitle = @"short_title";
NSString *const kHomeGoodsRowSnatched = @"snatched";
NSString *const kHomeGoodsRowSnatchedCount = @"snatched_count";
NSString *const kHomeGoodsRowSnatchedEndTime = @"snatched_end_time";
NSString *const kHomeGoodsRowSnatchedPrice = @"snatched_price";
NSString *const kHomeGoodsRowSnatchedTime = @"snatched_time";
NSString *const kHomeGoodsRowStage = @"stage";
NSString *const kHomeGoodsRowStick = @"stick";
NSString *const kHomeGoodsRowSucceed = @"succeed";
NSString *const kHomeGoodsRowSummary = @"summary";
NSString *const kHomeGoodsRowTags = @"tags";
NSString *const kHomeGoodsRowTagsS = @"tags_s";
NSString *const kHomeGoodsRowTipsLabel = @"tips_label";
NSString *const kHomeGoodsRowTitle = @"title";
NSString *const kHomeGoodsRowTopicCount = @"topic_count";
NSString *const kHomeGoodsRowUpdatedOn = @"updated_on";
NSString *const kHomeGoodsRowViewCount = @"view_count";
NSString *const kHomeGoodsRowVoteFavorCount = @"vote_favor_count";
NSString *const kHomeGoodsRowVoteOpposeCount = @"vote_oppose_count";
NSString *const kHomeGoodsRowVotedFinishTime = @"voted_finish_time";

@interface HomeGoodsRow ()
@end
@implementation HomeGoodsRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHomeGoodsRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kHomeGoodsRowIdField] integerValue];
	}

	if(![dictionary[kHomeGoodsRowAdvantage] isKindOfClass:[NSNull class]]){
		self.advantage = dictionary[kHomeGoodsRowAdvantage];
	}	
	if(![dictionary[kHomeGoodsRowAppAppointCount] isKindOfClass:[NSNull class]]){
		self.appAppointCount = [dictionary[kHomeGoodsRowAppAppointCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowAppSnatched] isKindOfClass:[NSNull class]]){
		self.appSnatched = [dictionary[kHomeGoodsRowAppSnatched] integerValue];
	}

	if(![dictionary[kHomeGoodsRowAppSnatchedCount] isKindOfClass:[NSNull class]]){
		self.appSnatchedCount = [dictionary[kHomeGoodsRowAppSnatchedCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowAppSnatchedEndTime] isKindOfClass:[NSNull class]]){
		self.appSnatchedEndTime = [dictionary[kHomeGoodsRowAppSnatchedEndTime] boolValue];
	}

	if(![dictionary[kHomeGoodsRowAppSnatchedPrice] isKindOfClass:[NSNull class]]){
		self.appSnatchedPrice = [dictionary[kHomeGoodsRowAppSnatchedPrice] integerValue];
	}

	if(![dictionary[kHomeGoodsRowAppSnatchedTime] isKindOfClass:[NSNull class]]){
		self.appSnatchedTime = [dictionary[kHomeGoodsRowAppSnatchedTime] boolValue];
	}

	if(![dictionary[kHomeGoodsRowAppSnatchedTotalCount] isKindOfClass:[NSNull class]]){
		self.appSnatchedTotalCount = [dictionary[kHomeGoodsRowAppSnatchedTotalCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowBrandId] isKindOfClass:[NSNull class]]){
		self.brandId = dictionary[kHomeGoodsRowBrandId];
	}	
	if(![dictionary[kHomeGoodsRowCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[kHomeGoodsRowCategoryId] integerValue];
	}

	if(![dictionary[kHomeGoodsRowCategoryIds] isKindOfClass:[NSNull class]]){
		self.categoryIds = dictionary[kHomeGoodsRowCategoryIds];
	}	
	if(![dictionary[kHomeGoodsRowCategoryTags] isKindOfClass:[NSNull class]]){
		self.categoryTags = dictionary[kHomeGoodsRowCategoryTags];
	}	
	if(![dictionary[kHomeGoodsRowCommentCount] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[kHomeGoodsRowCommentCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowCommentStar] isKindOfClass:[NSNull class]]){
		self.commentStar = [dictionary[kHomeGoodsRowCommentStar] integerValue];
	}

	if(![dictionary[kHomeGoodsRowContentViewUrl] isKindOfClass:[NSNull class]]){
		self.contentViewUrl = dictionary[kHomeGoodsRowContentViewUrl];
	}	
	if(![dictionary[kHomeGoodsRowCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kHomeGoodsRowCoverId];
	}	
	if(![dictionary[kHomeGoodsRowCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kHomeGoodsRowCoverUrl];
	}	
	if(![dictionary[kHomeGoodsRowCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kHomeGoodsRowCreatedOn] integerValue];
	}

	if(![dictionary[kHomeGoodsRowDeleted] isKindOfClass:[NSNull class]]){
		self.deleted = [dictionary[kHomeGoodsRowDeleted] integerValue];
	}

	if(![dictionary[kHomeGoodsRowFavoriteCount] isKindOfClass:[NSNull class]]){
		self.favoriteCount = [dictionary[kHomeGoodsRowFavoriteCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowFeatured] isKindOfClass:[NSNull class]]){
		self.featured = [dictionary[kHomeGoodsRowFeatured] integerValue];
	}

	if(![dictionary[kHomeGoodsRowInventory] isKindOfClass:[NSNull class]]){
		self.inventory = [dictionary[kHomeGoodsRowInventory] integerValue];
	}

	if(![dictionary[kHomeGoodsRowIsAppSnatched] isKindOfClass:[NSNull class]]){
		self.isAppSnatched = [dictionary[kHomeGoodsRowIsAppSnatched] integerValue];
	}

	if(![dictionary[kHomeGoodsRowLoveCount] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[kHomeGoodsRowLoveCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowMarketPrice] isKindOfClass:[NSNull class]]){
		self.marketPrice = [dictionary[kHomeGoodsRowMarketPrice] integerValue];
	}

	if(![dictionary[kHomeGoodsRowPresaleFinishTime] isKindOfClass:[NSNull class]]){
		self.presaleFinishTime = [dictionary[kHomeGoodsRowPresaleFinishTime] integerValue];
	}

	if(![dictionary[kHomeGoodsRowPresaleGoals] isKindOfClass:[NSNull class]]){
		self.presaleGoals = [dictionary[kHomeGoodsRowPresaleGoals] integerValue];
	}

	if(![dictionary[kHomeGoodsRowPresaleMoney] isKindOfClass:[NSNull class]]){
		self.presaleMoney = [dictionary[kHomeGoodsRowPresaleMoney] integerValue];
	}

	if(![dictionary[kHomeGoodsRowPresalePeople] isKindOfClass:[NSNull class]]){
		self.presalePeople = [dictionary[kHomeGoodsRowPresalePeople] integerValue];
	}

	if(![dictionary[kHomeGoodsRowPresalePercent] isKindOfClass:[NSNull class]]){
		self.presalePercent = [dictionary[kHomeGoodsRowPresalePercent] integerValue];
	}

	if(![dictionary[kHomeGoodsRowSalePrice] isKindOfClass:[NSNull class]]){
        self.salePrice = [dictionary[kHomeGoodsRowSalePrice] floatValue];
	}	
	if(![dictionary[kHomeGoodsRowShortTitle] isKindOfClass:[NSNull class]]){
		self.shortTitle = dictionary[kHomeGoodsRowShortTitle];
	}	
	if(![dictionary[kHomeGoodsRowSnatched] isKindOfClass:[NSNull class]]){
		self.snatched = [dictionary[kHomeGoodsRowSnatched] integerValue];
	}

	if(![dictionary[kHomeGoodsRowSnatchedCount] isKindOfClass:[NSNull class]]){
		self.snatchedCount = [dictionary[kHomeGoodsRowSnatchedCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowSnatchedEndTime] isKindOfClass:[NSNull class]]){
		self.snatchedEndTime = [dictionary[kHomeGoodsRowSnatchedEndTime] boolValue];
	}

	if(![dictionary[kHomeGoodsRowSnatchedPrice] isKindOfClass:[NSNull class]]){
		self.snatchedPrice = [dictionary[kHomeGoodsRowSnatchedPrice] floatValue];
	}

	if(![dictionary[kHomeGoodsRowSnatchedTime] isKindOfClass:[NSNull class]]){
		self.snatchedTime = [dictionary[kHomeGoodsRowSnatchedTime] integerValue];
	}

	if(![dictionary[kHomeGoodsRowStage] isKindOfClass:[NSNull class]]){
		self.stage = [dictionary[kHomeGoodsRowStage] integerValue];
	}

	if(![dictionary[kHomeGoodsRowStick] isKindOfClass:[NSNull class]]){
		self.stick = [dictionary[kHomeGoodsRowStick] integerValue];
	}

	if(![dictionary[kHomeGoodsRowSucceed] isKindOfClass:[NSNull class]]){
		self.succeed = [dictionary[kHomeGoodsRowSucceed] integerValue];
	}

	if(![dictionary[kHomeGoodsRowSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kHomeGoodsRowSummary];
	}	
	if(![dictionary[kHomeGoodsRowTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kHomeGoodsRowTags];
	}	
	if(![dictionary[kHomeGoodsRowTagsS] isKindOfClass:[NSNull class]]){
		self.tagsS = dictionary[kHomeGoodsRowTagsS];
	}	
	if(![dictionary[kHomeGoodsRowTipsLabel] isKindOfClass:[NSNull class]]){
		self.tipsLabel = [dictionary[kHomeGoodsRowTipsLabel] integerValue];
	}

	if(![dictionary[kHomeGoodsRowTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kHomeGoodsRowTitle];
	}	
	if(![dictionary[kHomeGoodsRowTopicCount] isKindOfClass:[NSNull class]]){
		self.topicCount = [dictionary[kHomeGoodsRowTopicCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kHomeGoodsRowUpdatedOn] integerValue];
	}

	if(![dictionary[kHomeGoodsRowViewCount] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[kHomeGoodsRowViewCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowVoteFavorCount] isKindOfClass:[NSNull class]]){
		self.voteFavorCount = [dictionary[kHomeGoodsRowVoteFavorCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowVoteOpposeCount] isKindOfClass:[NSNull class]]){
		self.voteOpposeCount = [dictionary[kHomeGoodsRowVoteOpposeCount] integerValue];
	}

	if(![dictionary[kHomeGoodsRowVotedFinishTime] isKindOfClass:[NSNull class]]){
		self.votedFinishTime = [dictionary[kHomeGoodsRowVotedFinishTime] integerValue];
	}

	return self;
}
@end
