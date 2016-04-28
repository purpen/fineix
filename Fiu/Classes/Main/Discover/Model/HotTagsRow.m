//
//	HotTagsRow.m
// on 27/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HotTagsRow.h"

@interface HotTagsRow ()
@end
@implementation HotTagsRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[@"_id"] integerValue];
	}

	if(![dictionary[@"children_count"] isKindOfClass:[NSNull class]]){
		self.childrenCount = [dictionary[@"children_count"] integerValue];
	}

	if(![dictionary[@"cover_id"] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[@"cover_id"];
	}	
	if(![dictionary[@"left_ref"] isKindOfClass:[NSNull class]]){
		self.leftRef = [dictionary[@"left_ref"] integerValue];
	}

	if(![dictionary[@"parent_id"] isKindOfClass:[NSNull class]]){
		self.parentId = [dictionary[@"parent_id"] integerValue];
	}

	if(![dictionary[@"right_ref"] isKindOfClass:[NSNull class]]){
		self.rightRef = [dictionary[@"right_ref"] integerValue];
	}

	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[@"status"] integerValue];
	}

	if(![dictionary[@"stick"] isKindOfClass:[NSNull class]]){
		self.stick = [dictionary[@"stick"] integerValue];
	}

	if(![dictionary[@"title_cn"] isKindOfClass:[NSNull class]]){
		self.titleCn = dictionary[@"title_cn"];
	}	
	if(![dictionary[@"title_en"] isKindOfClass:[NSNull class]]){
		self.titleEn = dictionary[@"title_en"];
	}	
	if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[@"type"] integerValue];
	}

	if(![dictionary[@"type_str"] isKindOfClass:[NSNull class]]){
		self.typeStr = dictionary[@"type_str"];
	}	
	if(![dictionary[@"used_count"] isKindOfClass:[NSNull class]]){
		self.usedCount = [dictionary[@"used_count"] integerValue];
	}

	return self;
}
@end