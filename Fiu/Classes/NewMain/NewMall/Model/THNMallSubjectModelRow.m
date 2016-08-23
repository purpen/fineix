//
//	THNMallSubjectModelRow.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNMallSubjectModelRow.h"

NSString *const kTHNMallSubjectModelRowIdField = @"_id";
NSString *const kTHNMallSubjectModelRowAttendCount = @"attend_count";
NSString *const kTHNMallSubjectModelRowBannerId = @"banner_id";
NSString *const kTHNMallSubjectModelRowBeginTime = @"begin_time";
NSString *const kTHNMallSubjectModelRowBeginTimeAt = @"begin_time_at";
NSString *const kTHNMallSubjectModelRowCategoryId = @"category_id";
NSString *const kTHNMallSubjectModelRowCommentCount = @"comment_count";
NSString *const kTHNMallSubjectModelRowCoverId = @"cover_id";
NSString *const kTHNMallSubjectModelRowCoverUrl = @"cover_url";
NSString *const kTHNMallSubjectModelRowEndTime = @"end_time";
NSString *const kTHNMallSubjectModelRowEndTimeAt = @"end_time_at";
NSString *const kTHNMallSubjectModelRowEvt = @"evt";
NSString *const kTHNMallSubjectModelRowFavoriteCount = @"favorite_count";
NSString *const kTHNMallSubjectModelRowFine = @"fine";
NSString *const kTHNMallSubjectModelRowFineOn = @"fine_on";
NSString *const kTHNMallSubjectModelRowKind = @"kind";
NSString *const kTHNMallSubjectModelRowLoveCount = @"love_count";
NSString *const kTHNMallSubjectModelRowProductIds = @"product_ids";
NSString *const kTHNMallSubjectModelRowProducts = @"products";
NSString *const kTHNMallSubjectModelRowPublish = @"publish";
NSString *const kTHNMallSubjectModelRowShareCount = @"share_count";
NSString *const kTHNMallSubjectModelRowShortTitle = @"short_title";
NSString *const kTHNMallSubjectModelRowStatus = @"status";
NSString *const kTHNMallSubjectModelRowStick = @"stick";
NSString *const kTHNMallSubjectModelRowStickOn = @"stick_on";
NSString *const kTHNMallSubjectModelRowSummary = @"summary";
NSString *const kTHNMallSubjectModelRowTags = @"tags";
NSString *const kTHNMallSubjectModelRowTitle = @"title";
NSString *const kTHNMallSubjectModelRowType = @"type";
NSString *const kTHNMallSubjectModelRowUserId = @"user_id";
NSString *const kTHNMallSubjectModelRowViewCount = @"view_count";

@interface THNMallSubjectModelRow ()
@end
@implementation THNMallSubjectModelRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNMallSubjectModelRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNMallSubjectModelRowIdField] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowAttendCount] isKindOfClass:[NSNull class]]){
		self.attendCount = dictionary[kTHNMallSubjectModelRowAttendCount];
	}	
	if(![dictionary[kTHNMallSubjectModelRowBannerId] isKindOfClass:[NSNull class]]){
		self.bannerId = dictionary[kTHNMallSubjectModelRowBannerId];
	}	
	if(![dictionary[kTHNMallSubjectModelRowBeginTime] isKindOfClass:[NSNull class]]){
		self.beginTime = [dictionary[kTHNMallSubjectModelRowBeginTime] boolValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowBeginTimeAt] isKindOfClass:[NSNull class]]){
		self.beginTimeAt = dictionary[kTHNMallSubjectModelRowBeginTimeAt];
	}	
	if(![dictionary[kTHNMallSubjectModelRowCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[kTHNMallSubjectModelRowCategoryId] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowCommentCount] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[kTHNMallSubjectModelRowCommentCount] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kTHNMallSubjectModelRowCoverId];
	}	
	if(![dictionary[kTHNMallSubjectModelRowCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kTHNMallSubjectModelRowCoverUrl];
	}	
	if(![dictionary[kTHNMallSubjectModelRowEndTime] isKindOfClass:[NSNull class]]){
		self.endTime = [dictionary[kTHNMallSubjectModelRowEndTime] boolValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowEndTimeAt] isKindOfClass:[NSNull class]]){
		self.endTimeAt = dictionary[kTHNMallSubjectModelRowEndTimeAt];
	}	
	if(![dictionary[kTHNMallSubjectModelRowEvt] isKindOfClass:[NSNull class]]){
		self.evt = [dictionary[kTHNMallSubjectModelRowEvt] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowFavoriteCount] isKindOfClass:[NSNull class]]){
		self.favoriteCount = [dictionary[kTHNMallSubjectModelRowFavoriteCount] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowFine] isKindOfClass:[NSNull class]]){
		self.fine = [dictionary[kTHNMallSubjectModelRowFine] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowFineOn] isKindOfClass:[NSNull class]]){
		self.fineOn = [dictionary[kTHNMallSubjectModelRowFineOn] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowKind] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[kTHNMallSubjectModelRowKind] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowLoveCount] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[kTHNMallSubjectModelRowLoveCount] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowProductIds] isKindOfClass:[NSNull class]]){
		self.productIds = dictionary[kTHNMallSubjectModelRowProductIds];
	}	
	if(dictionary[kTHNMallSubjectModelRowProducts] != nil && [dictionary[kTHNMallSubjectModelRowProducts] isKindOfClass:[NSArray class]]){
		NSArray * productsDictionaries = dictionary[kTHNMallSubjectModelRowProducts];
		NSMutableArray * productsItems = [NSMutableArray array];
		for(NSDictionary * productsDictionary in productsDictionaries){
			THNMallSubjectModelProduct * productsItem = [[THNMallSubjectModelProduct alloc] initWithDictionary:productsDictionary];
			[productsItems addObject:productsItem];
		}
		self.products = productsItems;
	}
	if(![dictionary[kTHNMallSubjectModelRowPublish] isKindOfClass:[NSNull class]]){
		self.publish = [dictionary[kTHNMallSubjectModelRowPublish] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowShareCount] isKindOfClass:[NSNull class]]){
		self.shareCount = dictionary[kTHNMallSubjectModelRowShareCount];
	}	
	if(![dictionary[kTHNMallSubjectModelRowShortTitle] isKindOfClass:[NSNull class]]){
		self.shortTitle = dictionary[kTHNMallSubjectModelRowShortTitle];
	}	
	if(![dictionary[kTHNMallSubjectModelRowStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNMallSubjectModelRowStatus] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowStick] isKindOfClass:[NSNull class]]){
		self.stick = [dictionary[kTHNMallSubjectModelRowStick] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowStickOn] isKindOfClass:[NSNull class]]){
		self.stickOn = dictionary[kTHNMallSubjectModelRowStickOn];
	}	
	if(![dictionary[kTHNMallSubjectModelRowSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kTHNMallSubjectModelRowSummary];
	}	
	if(![dictionary[kTHNMallSubjectModelRowTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kTHNMallSubjectModelRowTags];
	}	
	if(![dictionary[kTHNMallSubjectModelRowTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kTHNMallSubjectModelRowTitle];
	}	
	if(![dictionary[kTHNMallSubjectModelRowType] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[kTHNMallSubjectModelRowType] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kTHNMallSubjectModelRowUserId] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelRowViewCount] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[kTHNMallSubjectModelRowViewCount] integerValue];
	}

	return self;
}
@end