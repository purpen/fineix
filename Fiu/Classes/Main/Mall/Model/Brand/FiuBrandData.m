//
//	FiuBrandData.m
// on 14/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FiuBrandData.h"

@interface FiuBrandData ()
@end
@implementation FiuBrandData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"current_page"] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[@"current_page"] integerValue];
	}

	if(![dictionary[@"current_user_id"] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[@"current_user_id"] integerValue];
	}

	if(![dictionary[@"next_page"] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[@"next_page"] integerValue];
	}

	if(![dictionary[@"pager"] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[@"pager"];
	}	
	if(![dictionary[@"prev_page"] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[@"prev_page"] integerValue];
	}

	if(dictionary[@"rows"] != nil && [dictionary[@"rows"] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[@"rows"];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			FiuBrandRow * rowsItem = [[FiuBrandRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[@"total_page"] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[@"total_page"] integerValue];
	}

	if(![dictionary[@"total_rows"] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[@"total_rows"] integerValue];
	}

	return self;
}
@end