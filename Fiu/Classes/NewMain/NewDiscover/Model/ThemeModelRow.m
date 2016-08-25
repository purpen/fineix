//
//	ThemeModelRow.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ThemeModelRow.h"

NSString *const kThemeModelRowIdField = @"_id";
NSString *const kThemeModelRowAssetType = @"asset_type";
NSString *const kThemeModelRowAttendCount = @"attend_count";
NSString *const kThemeModelRowBeginTimeAt = @"begin_time_at";
NSString *const kThemeModelRowCid = @"cid";
NSString *const kThemeModelRowContent = @"content";
NSString *const kThemeModelRowCoverId = @"cover_id";
NSString *const kThemeModelRowCoverUrl = @"cover_url";
NSString *const kThemeModelRowCreatedOn = @"created_on";
NSString *const kThemeModelRowEndTimeAt = @"end_time_at";
NSString *const kThemeModelRowHighContent = @"high_content";
NSString *const kThemeModelRowHighTitle = @"high_title";
NSString *const kThemeModelRowKind = @"kind";
NSString *const kThemeModelRowKindName = @"kind_name";
NSString *const kThemeModelRowOid = @"oid";
NSString *const kThemeModelRowPid = @"pid";
NSString *const kThemeModelRowShortTitle = @"short_title";
NSString *const kThemeModelRowTags = @"tags";
NSString *const kThemeModelRowTid = @"tid";
NSString *const kThemeModelRowTitle = @"title";
NSString *const kThemeModelRowType = @"type";
NSString *const kThemeModelRowUpdatedOn = @"updated_on";
NSString *const kThemeModelRowUserId = @"user_id";
NSString *const kThemeModelRowViewCount = @"view_count";

@interface ThemeModelRow ()
@end
@implementation ThemeModelRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kThemeModelRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kThemeModelRowIdField];
	}	
	if(![dictionary[kThemeModelRowAssetType] isKindOfClass:[NSNull class]]){
		self.assetType = [dictionary[kThemeModelRowAssetType] integerValue];
	}

	if(![dictionary[kThemeModelRowAttendCount] isKindOfClass:[NSNull class]]){
		self.attendCount = dictionary[kThemeModelRowAttendCount];
	}	
	if(![dictionary[kThemeModelRowBeginTimeAt] isKindOfClass:[NSNull class]]){
		self.beginTimeAt = dictionary[kThemeModelRowBeginTimeAt];
	}	
	if(![dictionary[kThemeModelRowCid] isKindOfClass:[NSNull class]]){
		self.cid = dictionary[kThemeModelRowCid];
	}	
	if(![dictionary[kThemeModelRowContent] isKindOfClass:[NSNull class]]){
		self.content = dictionary[kThemeModelRowContent];
	}	
	if(![dictionary[kThemeModelRowCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kThemeModelRowCoverId];
	}	
	if(![dictionary[kThemeModelRowCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kThemeModelRowCoverUrl];
	}	
	if(![dictionary[kThemeModelRowCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = dictionary[kThemeModelRowCreatedOn];
	}	
	if(![dictionary[kThemeModelRowEndTimeAt] isKindOfClass:[NSNull class]]){
		self.endTimeAt = dictionary[kThemeModelRowEndTimeAt];
	}	
	if(![dictionary[kThemeModelRowHighContent] isKindOfClass:[NSNull class]]){
		self.highContent = dictionary[kThemeModelRowHighContent];
	}	
	if(![dictionary[kThemeModelRowHighTitle] isKindOfClass:[NSNull class]]){
		self.highTitle = dictionary[kThemeModelRowHighTitle];
	}	
	if(![dictionary[kThemeModelRowKind] isKindOfClass:[NSNull class]]){
		self.kind = dictionary[kThemeModelRowKind];
	}	
	if(![dictionary[kThemeModelRowKindName] isKindOfClass:[NSNull class]]){
		self.kindName = dictionary[kThemeModelRowKindName];
	}	
	if(![dictionary[kThemeModelRowOid] isKindOfClass:[NSNull class]]){
		self.oid = dictionary[kThemeModelRowOid];
	}	
	if(![dictionary[kThemeModelRowPid] isKindOfClass:[NSNull class]]){
		self.pid = dictionary[kThemeModelRowPid];
	}	
	if(![dictionary[kThemeModelRowShortTitle] isKindOfClass:[NSNull class]]){
		self.shortTitle = dictionary[kThemeModelRowShortTitle];
	}	
	if(![dictionary[kThemeModelRowTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kThemeModelRowTags];
	}	
	if(![dictionary[kThemeModelRowTid] isKindOfClass:[NSNull class]]){
		self.tid = dictionary[kThemeModelRowTid];
	}	
	if(![dictionary[kThemeModelRowTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kThemeModelRowTitle];
	}	
	if(![dictionary[kThemeModelRowType] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[kThemeModelRowType] integerValue];
	}

	if(![dictionary[kThemeModelRowUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = dictionary[kThemeModelRowUpdatedOn];
	}	
	if(![dictionary[kThemeModelRowUserId] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[kThemeModelRowUserId];
	}	
	if(![dictionary[kThemeModelRowViewCount] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[kThemeModelRowViewCount] integerValue];
	}

	return self;
}
@end