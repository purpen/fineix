//
//	UserModelRow.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "UserModelRow.h"

NSString *const kUserModelRowIdField = @"_id";
NSString *const kUserModelRowAssetType = @"asset_type";
NSString *const kUserModelRowAvatarUrl = @"avatar_url";
NSString *const kUserModelRowCid = @"cid";
NSString *const kUserModelRowContent = @"content";
NSString *const kUserModelRowCoverId = @"cover_id";
NSString *const kUserModelRowCreatedOn = @"created_on";
NSString *const kUserModelRowExpertInfo = @"expert_info";
NSString *const kUserModelRowExpertLabel = @"expert_label";
NSString *const kUserModelRowHighContent = @"high_content";
NSString *const kUserModelRowHighTitle = @"high_title";
NSString *const kUserModelRowIsExport = @"is_export";
NSString *const kUserModelRowIsFollow = @"is_follow";
NSString *const kUserModelRowKind = @"kind";
NSString *const kUserModelRowKindName = @"kind_name";
NSString *const kUserModelRowLabel = @"label";
NSString *const kUserModelRowNickname = @"nickname";
NSString *const kUserModelRowOid = @"oid";
NSString *const kUserModelRowPid = @"pid";
NSString *const kUserModelRowSummary = @"summary";
NSString *const kUserModelRowTags = @"tags";
NSString *const kUserModelRowTid = @"tid";
NSString *const kUserModelRowTitle = @"title";
NSString *const kUserModelRowUpdatedOn = @"updated_on";
NSString *const kUserModelRowUserId = @"user_id";

@interface UserModelRow ()
@end
@implementation UserModelRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kUserModelRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kUserModelRowIdField];
	}	
	if(![dictionary[kUserModelRowAssetType] isKindOfClass:[NSNull class]]){
		self.assetType = [dictionary[kUserModelRowAssetType] integerValue];
	}

	if(![dictionary[kUserModelRowAvatarUrl] isKindOfClass:[NSNull class]]){
		self.avatarUrl = dictionary[kUserModelRowAvatarUrl];
	}	
	if(![dictionary[kUserModelRowCid] isKindOfClass:[NSNull class]]){
		self.cid = dictionary[kUserModelRowCid];
	}	
	if(![dictionary[kUserModelRowContent] isKindOfClass:[NSNull class]]){
		self.content = dictionary[kUserModelRowContent];
	}	
	if(![dictionary[kUserModelRowCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kUserModelRowCoverId];
	}	
	if(![dictionary[kUserModelRowCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = dictionary[kUserModelRowCreatedOn];
	}	
	if(![dictionary[kUserModelRowExpertInfo] isKindOfClass:[NSNull class]]){
		self.expertInfo = dictionary[kUserModelRowExpertInfo];
	}	
	if(![dictionary[kUserModelRowExpertLabel] isKindOfClass:[NSNull class]]){
		self.expertLabel = dictionary[kUserModelRowExpertLabel];
	}	
	if(![dictionary[kUserModelRowHighContent] isKindOfClass:[NSNull class]]){
		self.highContent = dictionary[kUserModelRowHighContent];
	}	
	if(![dictionary[kUserModelRowHighTitle] isKindOfClass:[NSNull class]]){
		self.highTitle = dictionary[kUserModelRowHighTitle];
	}	
	if(![dictionary[kUserModelRowIsExport] isKindOfClass:[NSNull class]]){
		self.isExport = [dictionary[kUserModelRowIsExport] integerValue];
	}

	if(![dictionary[kUserModelRowIsFollow] isKindOfClass:[NSNull class]]){
		self.isFollow = [dictionary[kUserModelRowIsFollow] integerValue];
	}

	if(![dictionary[kUserModelRowKind] isKindOfClass:[NSNull class]]){
		self.kind = dictionary[kUserModelRowKind];
	}	
	if(![dictionary[kUserModelRowKindName] isKindOfClass:[NSNull class]]){
		self.kindName = dictionary[kUserModelRowKindName];
	}	
	if(![dictionary[kUserModelRowLabel] isKindOfClass:[NSNull class]]){
		self.label = dictionary[kUserModelRowLabel];
	}	
	if(![dictionary[kUserModelRowNickname] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[kUserModelRowNickname];
	}	
	if(![dictionary[kUserModelRowOid] isKindOfClass:[NSNull class]]){
		self.oid = dictionary[kUserModelRowOid];
	}	
	if(![dictionary[kUserModelRowPid] isKindOfClass:[NSNull class]]){
		self.pid = dictionary[kUserModelRowPid];
	}	
	if(![dictionary[kUserModelRowSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kUserModelRowSummary];
	}	
	if(![dictionary[kUserModelRowTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kUserModelRowTags];
	}	
	if(![dictionary[kUserModelRowTid] isKindOfClass:[NSNull class]]){
		self.tid = dictionary[kUserModelRowTid];
	}	
	if(![dictionary[kUserModelRowTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kUserModelRowTitle];
	}	
	if(![dictionary[kUserModelRowUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = dictionary[kUserModelRowUpdatedOn];
	}	
	if(![dictionary[kUserModelRowUserId] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[kUserModelRowUserId];
	}	
	return self;
}
@end