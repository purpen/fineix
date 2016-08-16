//
//	FBSubjectModelRow.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FBSubjectModelRow.h"

NSString *const kFBSubjectModelRowIdField = @"_id";
NSString *const kFBSubjectModelRowAttendCount = @"attend_count";
NSString *const kFBSubjectModelRowBannerId = @"banner_id";
NSString *const kFBSubjectModelRowCategoryId = @"category_id";
NSString *const kFBSubjectModelRowCommentCount = @"comment_count";
NSString *const kFBSubjectModelRowCoverId = @"cover_id";
NSString *const kFBSubjectModelRowCoverUrl = @"cover_url";
NSString *const kFBSubjectModelRowFavoriteCount = @"favorite_count";
NSString *const kFBSubjectModelRowFine = @"fine";
NSString *const kFBSubjectModelRowFineOn = @"fine_on";
NSString *const kFBSubjectModelRowKind = @"kind";
NSString *const kFBSubjectModelRowLoveCount = @"love_count";
NSString *const kFBSubjectModelRowPublish = @"publish";
NSString *const kFBSubjectModelRowShareCount = @"share_count";
NSString *const kFBSubjectModelRowStatus = @"status";
NSString *const kFBSubjectModelRowStick = @"stick";
NSString *const kFBSubjectModelRowStickOn = @"stick_on";
NSString *const kFBSubjectModelRowSummary = @"summary";
NSString *const kFBSubjectModelRowTags = @"tags";
NSString *const kFBSubjectModelRowTitle = @"title";
NSString *const kFBSubjectModelRowType = @"type";
NSString *const kFBSubjectModelRowUserId = @"user_id";
NSString *const kFBSubjectModelRowViewCount = @"view_count";

@interface FBSubjectModelRow ()
@end
@implementation FBSubjectModelRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFBSubjectModelRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kFBSubjectModelRowIdField] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowAttendCount] isKindOfClass:[NSNull class]]){
		self.attendCount = [dictionary[kFBSubjectModelRowAttendCount] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowBannerId] isKindOfClass:[NSNull class]]){
		self.bannerId = dictionary[kFBSubjectModelRowBannerId];
	}	
	if(![dictionary[kFBSubjectModelRowCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[kFBSubjectModelRowCategoryId] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowCommentCount] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[kFBSubjectModelRowCommentCount] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kFBSubjectModelRowCoverId];
	}	
	if(![dictionary[kFBSubjectModelRowCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kFBSubjectModelRowCoverUrl];
	}	
	if(![dictionary[kFBSubjectModelRowFavoriteCount] isKindOfClass:[NSNull class]]){
		self.favoriteCount = [dictionary[kFBSubjectModelRowFavoriteCount] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowFine] isKindOfClass:[NSNull class]]){
		self.fine = [dictionary[kFBSubjectModelRowFine] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowFineOn] isKindOfClass:[NSNull class]]){
		self.fineOn = [dictionary[kFBSubjectModelRowFineOn] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowKind] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[kFBSubjectModelRowKind] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowLoveCount] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[kFBSubjectModelRowLoveCount] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowPublish] isKindOfClass:[NSNull class]]){
		self.publish = [dictionary[kFBSubjectModelRowPublish] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowShareCount] isKindOfClass:[NSNull class]]){
		self.shareCount = [dictionary[kFBSubjectModelRowShareCount] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kFBSubjectModelRowStatus] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowStick] isKindOfClass:[NSNull class]]){
		self.stick = [dictionary[kFBSubjectModelRowStick] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowStickOn] isKindOfClass:[NSNull class]]){
		self.stickOn = [dictionary[kFBSubjectModelRowStickOn] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kFBSubjectModelRowSummary];
	}	
	if(![dictionary[kFBSubjectModelRowTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kFBSubjectModelRowTags];
	}	
	if(![dictionary[kFBSubjectModelRowTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kFBSubjectModelRowTitle];
	}	
	if(![dictionary[kFBSubjectModelRowType] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[kFBSubjectModelRowType] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kFBSubjectModelRowUserId] integerValue];
	}

	if(![dictionary[kFBSubjectModelRowViewCount] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[kFBSubjectModelRowViewCount] integerValue];
	}

	return self;
}
@end