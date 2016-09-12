//
//	FiuBrandRow.m
// on 14/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FiuBrandRow.h"

@interface FiuBrandRow ()
@end
@implementation FiuBrandRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
//	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
//		self.idField = [[FiuBrandId alloc] initWithDictionary:dictionary[@"_id"]];
//	}
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.idx = dictionary[@"_id"];
    }
    
	if(![dictionary[@"brands_size_type"] isKindOfClass:[NSNull class]]){
		self.brandsSizeType = [dictionary[@"brands_size_type"] integerValue];
	}

	if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[@"cover_url"];
	}	
	if(![dictionary[@"created_on"] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[@"created_on"] integerValue];
	}

	if(![dictionary[@"des"] isKindOfClass:[NSNull class]]){
		self.des = dictionary[@"des"];
	}	
	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[@"status"] integerValue];
	}

	if(![dictionary[@"stick"] isKindOfClass:[NSNull class]]){
		self.stick = dictionary[@"stick"];
	}	
	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	if(![dictionary[@"updated_on"] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[@"updated_on"] integerValue];
	}

	if(![dictionary[@"used_count"] isKindOfClass:[NSNull class]]){
		self.usedCount = [dictionary[@"used_count"] integerValue];
	}

	return self;
}
@end