//
//	CommentModelRow.m
// on 28/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CommentModelRow.h"

@interface CommentModelRow ()
@end
@implementation CommentModelRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"__extend__"] isKindOfClass:[NSNull class]]){
		self.extend = [dictionary[@"__extend__"] boolValue];
	}

	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = [[CommentModelId alloc] initWithDictionary:dictionary[@"_id"]];
	}

	if(![dictionary[@"content"] isKindOfClass:[NSNull class]]){
		self.content = dictionary[@"content"];
	}	
	if(![dictionary[@"content_original"] isKindOfClass:[NSNull class]]){
		self.contentOriginal = dictionary[@"content_original"];
	}	
	if(![dictionary[@"created_on"] isKindOfClass:[NSNull class]]){
		self.createdOn = dictionary[@"created_on"];
	}	
	if(![dictionary[@"deleted"] isKindOfClass:[NSNull class]]){
		self.deleted = [dictionary[@"deleted"] integerValue];
	}

	if(![dictionary[@"floor"] isKindOfClass:[NSNull class]]){
		self.floor = [dictionary[@"floor"] integerValue];
	}

	if(![dictionary[@"invented_love_count"] isKindOfClass:[NSNull class]]){
		self.inventedLoveCount = [dictionary[@"invented_love_count"] integerValue];
	}

	if(![dictionary[@"is_reply"] isKindOfClass:[NSNull class]]){
		self.isReply = [dictionary[@"is_reply"] integerValue];
	}

	if(![dictionary[@"love_count"] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[@"love_count"] integerValue];
	}

	if(![dictionary[@"reply"] isKindOfClass:[NSNull class]]){
		self.reply = dictionary[@"reply"];
	}	
	if(![dictionary[@"reply_id"] isKindOfClass:[NSNull class]]){
		self.replyId = dictionary[@"reply_id"];
	}	
	if(![dictionary[@"reply_user_id"] isKindOfClass:[NSNull class]]){
		self.replyUserId = [dictionary[@"reply_user_id"] integerValue];
	}

	if(![dictionary[@"sku_id"] isKindOfClass:[NSNull class]]){
		self.skuId = [dictionary[@"sku_id"] integerValue];
	}

	if(![dictionary[@"star"] isKindOfClass:[NSNull class]]){
		self.star = [dictionary[@"star"] integerValue];
	}

	if(![dictionary[@"sub_type"] isKindOfClass:[NSNull class]]){
		self.subType = [dictionary[@"sub_type"] integerValue];
	}

	if(![dictionary[@"target_id"] isKindOfClass:[NSNull class]]){
		self.targetId = dictionary[@"target_id"];
	}	
	if(![dictionary[@"target_user"] isKindOfClass:[NSNull class]]){
		self.targetUser = dictionary[@"target_user"];
	}	
	if(![dictionary[@"target_user_id"] isKindOfClass:[NSNull class]]){
		self.targetUserId = [dictionary[@"target_user_id"] integerValue];
	}

	if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[@"type"] integerValue];
	}

	if(![dictionary[@"updated_on"] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[@"updated_on"] integerValue];
	}

	if(![dictionary[@"user"] isKindOfClass:[NSNull class]]){
		self.user = [[CommentModelUser alloc] initWithDictionary:dictionary[@"user"]];
	}

	if(![dictionary[@"user_id"] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[@"user_id"] integerValue];
	}

	return self;
}
@end