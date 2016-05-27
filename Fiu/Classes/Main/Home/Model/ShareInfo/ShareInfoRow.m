//
//	ShareInfoRow.m
// on 26/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ShareInfoRow.h"

@interface ShareInfoRow ()
@end
@implementation ShareInfoRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[@"_id"];
	}	
	if(![dictionary[@"asset_type"] isKindOfClass:[NSNull class]]){
		self.assetType = [dictionary[@"asset_type"] integerValue];
	}

	if(![dictionary[@"cid"] isKindOfClass:[NSNull class]]){
		self.cid = dictionary[@"cid"];
	}	
	if(![dictionary[@"content"] isKindOfClass:[NSNull class]]){
		self.content = dictionary[@"content"];
	}
    if(![dictionary[@"des"] isKindOfClass:[NSNull class]]){
        self.des = dictionary[@"des"];
    }
	if(![dictionary[@"cover_id"] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[@"cover_id"];
	}	
	if(![dictionary[@"created_on"] isKindOfClass:[NSNull class]]){
		self.createdOn = dictionary[@"created_on"];
	}	
	if(![dictionary[@"high_content"] isKindOfClass:[NSNull class]]){
		self.highContent = dictionary[@"high_content"];
	}	
	if(![dictionary[@"high_title"] isKindOfClass:[NSNull class]]){
		self.highTitle = dictionary[@"high_title"];
	}	
	if(![dictionary[@"kind"] isKindOfClass:[NSNull class]]){
		self.kind = dictionary[@"kind"];
	}	
	if(![dictionary[@"kind_name"] isKindOfClass:[NSNull class]]){
		self.kindName = dictionary[@"kind_name"];
	}	
	if(![dictionary[@"oid"] isKindOfClass:[NSNull class]]){
		self.oid = dictionary[@"oid"];
	}	
	if(![dictionary[@"pid"] isKindOfClass:[NSNull class]]){
		self.pid = dictionary[@"pid"];
	}	
	if(![dictionary[@"tags"] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[@"tags"];
	}	
	if(![dictionary[@"tid"] isKindOfClass:[NSNull class]]){
		self.tid = dictionary[@"tid"];
	}	
	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	if(![dictionary[@"updated_on"] isKindOfClass:[NSNull class]]){
		self.updatedOn = dictionary[@"updated_on"];
	}	
	if(![dictionary[@"user_id"] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[@"user_id"];
	}	
	return self;
}
@end