//
//	THNRemindModelRow.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNRemindModelRow.h"

NSString *const kTHNRemindModelRowIdField = @"_id";
NSString *const kTHNRemindModelRowCommentTargetObj = @"comment_target_obj";
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
NSString *const kTHNRemindModelRowReviceUser = @"revice_user";
NSString *const kTHNRemindModelRowSUserId = @"s_user_id";
NSString *const kTHNRemindModelRowSendUser = @"send_user";
NSString *const kTHNRemindModelRowTargetObj = @"target_obj";
NSString *const kTHNRemindModelRowUpdatedOn = @"updated_on";
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

	if(![dictionary[kTHNRemindModelRowReviceUser] isKindOfClass:[NSNull class]]){
		self.reviceUser = [[THNRemindModelReviceUser alloc] initWithDictionary:dictionary[kTHNRemindModelRowReviceUser]];
	}
    if(![dictionary[kTHNRemindModelRowCommentTargetObj] isKindOfClass:[NSNull class]]){
        self.commentTargetObj = [[THNRemindModelCommentObj alloc] initWithDictionary:dictionary[kTHNRemindModelRowCommentTargetObj]];
    }
	if(![dictionary[kTHNRemindModelRowSUserId] isKindOfClass:[NSNull class]]){
		self.sUserId = [dictionary[kTHNRemindModelRowSUserId] integerValue];
	}

	if(![dictionary[kTHNRemindModelRowSendUser] isKindOfClass:[NSNull class]]){
		self.sendUser = [[THNRemindModelReviceUser alloc] initWithDictionary:dictionary[kTHNRemindModelRowSendUser]];
	}

	if(![dictionary[kTHNRemindModelRowTargetObj] isKindOfClass:[NSNull class]]){
		self.targetObj = [[THNRemindModelTargetObj alloc] initWithDictionary:dictionary[kTHNRemindModelRowTargetObj]];
	}
    
	if(![dictionary[kTHNRemindModelRowUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kTHNRemindModelRowUpdatedOn] integerValue];
	}

	if(![dictionary[kTHNRemindModelRowUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kTHNRemindModelRowUserId] integerValue];
	}

	return self;
}
@end
