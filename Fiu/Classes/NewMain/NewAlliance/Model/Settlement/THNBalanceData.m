//
//	THNBalanceData.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNBalanceData.h"

NSString *const kTHNBalanceDataCurrentPage = @"current_page";
NSString *const kTHNBalanceDataCurrentUserId = @"current_user_id";
NSString *const kTHNBalanceDataNextPage = @"next_page";
NSString *const kTHNBalanceDataPager = @"pager";
NSString *const kTHNBalanceDataPrevPage = @"prev_page";
NSString *const kTHNBalanceDataRows = @"rows";
NSString *const kTHNBalanceDataTotalPage = @"total_page";
NSString *const kTHNBalanceDataTotalRows = @"total_rows";

@interface THNBalanceData ()
@end
@implementation THNBalanceData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNBalanceDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kTHNBalanceDataCurrentPage] integerValue];
	}

	if(![dictionary[kTHNBalanceDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNBalanceDataCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNBalanceDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kTHNBalanceDataNextPage] integerValue];
	}

	if(![dictionary[kTHNBalanceDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kTHNBalanceDataPager];
	}	
	if(![dictionary[kTHNBalanceDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kTHNBalanceDataPrevPage] integerValue];
	}

	if(dictionary[kTHNBalanceDataRows] != nil && [dictionary[kTHNBalanceDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kTHNBalanceDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			THNBalanceRow * rowsItem = [[THNBalanceRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kTHNBalanceDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kTHNBalanceDataTotalPage] integerValue];
	}

	if(![dictionary[kTHNBalanceDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kTHNBalanceDataTotalRows] integerValue];
	}

	return self;
}
@end