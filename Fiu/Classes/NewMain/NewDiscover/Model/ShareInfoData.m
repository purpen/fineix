//
//	ShareInfoData.m
// on 26/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ShareInfoData.h"

@interface ShareInfoData ()
@end
@implementation ShareInfoData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"current_user_id"] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[@"current_user_id"] integerValue];
	}

	if(![dictionary[@"msg"] isKindOfClass:[NSNull class]]){
		self.msg = dictionary[@"msg"];
	}	
	if(dictionary[@"rows"] != nil && [dictionary[@"rows"] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[@"rows"];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			ShareInfoRow * rowsItem = [[ShareInfoRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[@"success"] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[@"success"] boolValue];
	}

	if(![dictionary[@"total_count"] isKindOfClass:[NSNull class]]){
		self.totalCount = [dictionary[@"total_count"] integerValue];
	}

	if(![dictionary[@"total_page"] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[@"total_page"] integerValue];
	}

	return self;
}
@end