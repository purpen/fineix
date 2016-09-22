//
//	THNRemindModelRow.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNRemindModelRow.h"

NSString *const kTHNRemindModelRowIdField = @"_id";
NSString *const kTHNRemindModelRowCommentTypeStr = @"comment_type_str";
NSString *const kTHNRemindModelRowContent = @"content";
NSString *const kTHNRemindModelRowCreatedAt = @"created_at";
NSString *const kTHNRemindModelRowCreatedOn = @"created_on";
NSString *const kTHNRemindModelRowEvt = @"evt";
NSString *const kTHNRemindModelRowFromTo = @"from_to";
NSString *const kTHNRemindModelRowInfo = @"info";
NSString *const kTHNRemindModelRowKind = @"kind";
NSString *const kTHNRemindModelRowKindStr = @"kind_str";
NSString *const kTHNRemindModelRowParentRelatedId = @"parent_related_id";
NSString *const kTHNRemindModelRowReaded = @"readed";
NSString *const kTHNRemindModelRowRelatedId = @"related_id";
NSString *const kTHNRemindModelRowSUser = @"s_user";
NSString *const kTHNRemindModelRowSUserId = @"s_user_id";
NSString *const kTHNRemindModelRowTarget = @"target";
NSString *const kTHNRemindModelRowUpdatedOn = @"updated_on";
NSString *const kTHNRemindModelRowUser = @"user";
NSString *const kTHNRemindModelRowUserId = @"user_id";

@interface THNRemindModelRow ()
@end
@implementation THNRemindModelRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNRemindModelRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kTHNRemindModelRowIdField];
	}	
	if(![dictionary[kTHNRemindModelRowCommentTypeStr] isKindOfClass:[NSNull class]]){
		self.commentTypeStr = dictionary[kTHNRemindModelRowCommentTypeStr];
	}	
	if(![dictionary[kTHNRemindModelRowContent] isKindOfClass:[NSNull class]]){
		self.content = dictionary[kTHNRemindModelRowContent];
	}	
	if(![dictionary[kTHNRemindModelRowCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = dictionary[kTHNRemindModelRowCreatedAt];
	}	
	if(![dictionary[kTHNRemindModelRowCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kTHNRemindModelRowCreatedOn] integerValue];
	}

	if(![dictionary[kTHNRemindModelRowEvt] isKindOfClass:[NSNull class]]){
		self.evt = [dictionary[kTHNRemindModelRowEvt] integerValue];
	}

	if(![dictionary[kTHNRemindModelRowFromTo] isKindOfClass:[NSNull class]]){
		self.fromTo = [dictionary[kTHNRemindModelRowFromTo] integerValue];
	}

	if(![dictionary[kTHNRemindModelRowInfo] isKindOfClass:[NSNull class]]){
		self.info = dictionary[kTHNRemindModelRowInfo];
	}	
	if(![dictionary[kTHNRemindModelRowKind] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[kTHNRemindModelRowKind] integerValue];
	}

	if(![dictionary[kTHNRemindModelRowKindStr] isKindOfClass:[NSNull class]]){
		self.kindStr = dictionary[kTHNRemindModelRowKindStr];
	}	
	if(![dictionary[kTHNRemindModelRowParentRelatedId] isKindOfClass:[NSNull class]]){
		self.parentRelatedId = dictionary[kTHNRemindModelRowParentRelatedId];
	}	
	if(![dictionary[kTHNRemindModelRowReaded] isKindOfClass:[NSNull class]]){
		self.readed = [dictionary[kTHNRemindModelRowReaded] integerValue];
	}

	if(![dictionary[kTHNRemindModelRowRelatedId] isKindOfClass:[NSNull class]]){
		self.relatedId = [dictionary[kTHNRemindModelRowRelatedId] integerValue];
	}

	if(![dictionary[kTHNRemindModelRowSUser] isKindOfClass:[NSNull class]]){
		self.sUser = [[THNRemindModelSUser alloc] initWithDictionary:dictionary[kTHNRemindModelRowSUser]];
	}

	if(![dictionary[kTHNRemindModelRowSUserId] isKindOfClass:[NSNull class]]){
		self.sUserId = [dictionary[kTHNRemindModelRowSUserId] integerValue];
	}

	if(![dictionary[kTHNRemindModelRowTarget] isKindOfClass:[NSNull class]]){
		self.target = [[THNRemindModelTarget alloc] initWithDictionary:dictionary[kTHNRemindModelRowTarget]];
	}

	if(![dictionary[kTHNRemindModelRowUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kTHNRemindModelRowUpdatedOn] integerValue];
	}

	if(![dictionary[kTHNRemindModelRowUser] isKindOfClass:[NSNull class]]){
		self.user = [[THNRemindModelSUser alloc] initWithDictionary:dictionary[kTHNRemindModelRowUser]];
	}

	if(![dictionary[kTHNRemindModelRowUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kTHNRemindModelRowUserId] integerValue];
	}

	return self;
}
@end