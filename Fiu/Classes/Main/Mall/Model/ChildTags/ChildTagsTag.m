//
//	ChildTagsTag.m
// on 5/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ChildTagsTag.h"

@interface ChildTagsTag ()
@end
@implementation ChildTagsTag




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[@"_id"] integerValue];
	}

	if(![dictionary[@"title_cn"] isKindOfClass:[NSNull class]]){
		self.titleCn = dictionary[@"title_cn"];
	}	
	return self;
}
@end