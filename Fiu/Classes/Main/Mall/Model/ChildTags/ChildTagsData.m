//
//	ChildTagsData.m
// on 5/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ChildTagsData.h"

@interface ChildTagsData ()
@end
@implementation ChildTagsData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"current_user_id"] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[@"current_user_id"] integerValue];
	}

	if(dictionary[@"tags"] != nil && [dictionary[@"tags"] isKindOfClass:[NSArray class]]){
		NSArray * tagsDictionaries = dictionary[@"tags"];
		NSMutableArray * tagsItems = [NSMutableArray array];
		for(NSDictionary * tagsDictionary in tagsDictionaries){
			ChildTagsTag * tagsItem = [[ChildTagsTag alloc] initWithDictionary:tagsDictionary];
			[tagsItems addObject:tagsItem];
		}
		self.tags = tagsItems;
	}
	return self;
}
@end