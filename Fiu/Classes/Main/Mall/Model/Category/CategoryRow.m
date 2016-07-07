//
//	CategoryRow.m
// on 5/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CategoryRow.h"

@interface CategoryRow ()
@end
@implementation CategoryRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[@"_id"] integerValue];
	}

	if(![dictionary[@"app_cover_s_url"] isKindOfClass:[NSNull class]]){
		self.appCoverSUrl = dictionary[@"app_cover_s_url"];
	}	
	if(![dictionary[@"app_cover_url"] isKindOfClass:[NSNull class]]){
		self.appCoverUrl = dictionary[@"app_cover_url"];
	}
    if(![dictionary[@"back_url"] isKindOfClass:[NSNull class]]){
        self.backUrl = dictionary[@"back_url"];
    }
	if(![dictionary[@"domain"] isKindOfClass:[NSNull class]]){
		self.domain = [dictionary[@"domain"] integerValue];
	}

	if(![dictionary[@"gid"] isKindOfClass:[NSNull class]]){
		self.gid = [dictionary[@"gid"] integerValue];
	}

	if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}	
	if(![dictionary[@"order_by"] isKindOfClass:[NSNull class]]){
		self.orderBy = [dictionary[@"order_by"] integerValue];
	}

	if(![dictionary[@"pid"] isKindOfClass:[NSNull class]]){
		self.pid = [dictionary[@"pid"] integerValue];
	}

	if(![dictionary[@"reply_count"] isKindOfClass:[NSNull class]]){
		self.replyCount = [dictionary[@"reply_count"] integerValue];
	}

	if(![dictionary[@"sub_count"] isKindOfClass:[NSNull class]]){
		self.subCount = [dictionary[@"sub_count"] integerValue];
	}

	if(![dictionary[@"tag_id"] isKindOfClass:[NSNull class]]){
		self.tagId = [dictionary[@"tag_id"] integerValue];
	}

	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	if(![dictionary[@"total_count"] isKindOfClass:[NSNull class]]){
		self.totalCount = [dictionary[@"total_count"] integerValue];
	}

	return self;
}
@end