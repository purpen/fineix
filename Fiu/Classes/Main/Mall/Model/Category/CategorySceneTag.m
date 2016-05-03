//
//	CategorySceneTag.m
// on 28/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CategorySceneTag.h"

@interface CategorySceneTag ()
@end
@implementation CategorySceneTag




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