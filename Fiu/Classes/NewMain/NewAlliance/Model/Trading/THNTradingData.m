//
//	THNTradingData.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNTradingData.h"

NSString *const kTHNTradingDataCurrentPage = @"current_page";
NSString *const kTHNTradingDataCurrentUserId = @"current_user_id";
NSString *const kTHNTradingDataNextPage = @"next_page";
NSString *const kTHNTradingDataPager = @"pager";
NSString *const kTHNTradingDataPrevPage = @"prev_page";
NSString *const kTHNTradingDataRows = @"rows";
NSString *const kTHNTradingDataTotalPage = @"total_page";
NSString *const kTHNTradingDataTotalRows = @"total_rows";

@interface THNTradingData ()
@end
@implementation THNTradingData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNTradingDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kTHNTradingDataCurrentPage] integerValue];
	}

	if(![dictionary[kTHNTradingDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNTradingDataCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNTradingDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kTHNTradingDataNextPage] integerValue];
	}

	if(![dictionary[kTHNTradingDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kTHNTradingDataPager];
	}	
	if(![dictionary[kTHNTradingDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kTHNTradingDataPrevPage] integerValue];
	}

	if(dictionary[kTHNTradingDataRows] != nil && [dictionary[kTHNTradingDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kTHNTradingDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			THNTradingRow * rowsItem = [[THNTradingRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kTHNTradingDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kTHNTradingDataTotalPage] integerValue];
	}

	if(![dictionary[kTHNTradingDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kTHNTradingDataTotalRows] integerValue];
	}

	return self;
}
@end