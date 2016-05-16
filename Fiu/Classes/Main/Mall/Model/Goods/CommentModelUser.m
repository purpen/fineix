//
//	CommentModelUser.m
// on 28/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CommentModelUser.h"

@interface CommentModelUser ()
@end
@implementation CommentModelUser




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[@"_id"] integerValue];
	}

	if(![dictionary[@"big_avatar_url"] isKindOfClass:[NSNull class]]){
		self.bigAvatarUrl = dictionary[@"big_avatar_url"];
	}	
	if(![dictionary[@"home_url"] isKindOfClass:[NSNull class]]){
		self.homeUrl = dictionary[@"home_url"];
	}	
	if(![dictionary[@"medium_avatar_url"] isKindOfClass:[NSNull class]]){
		self.mediumAvatarUrl = dictionary[@"medium_avatar_url"];
	}	
	if(![dictionary[@"mini_avatar_url"] isKindOfClass:[NSNull class]]){
		self.miniAvatarUrl = dictionary[@"mini_avatar_url"];
	}	
	if(![dictionary[@"nickname"] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[@"nickname"];
	}	
	if(![dictionary[@"small_avatar_url"] isKindOfClass:[NSNull class]]){
		self.smallAvatarUrl = dictionary[@"small_avatar_url"];
	}	
	if(![dictionary[@"symbol"] isKindOfClass:[NSNull class]]){
		self.symbol = [dictionary[@"symbol"] integerValue];
	}

	return self;
}
@end