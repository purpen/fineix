//
//	THNWithdrawData.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNWithdrawData.h"

NSString *const kTHNWithdrawDataCurrentPage = @"current_page";
NSString *const kTHNWithdrawDataCurrentUserId = @"current_user_id";
NSString *const kTHNWithdrawDataNextPage = @"next_page";
NSString *const kTHNWithdrawDataPager = @"pager";
NSString *const kTHNWithdrawDataPrevPage = @"prev_page";
NSString *const kTHNWithdrawDataRows = @"rows";
NSString *const kTHNWithdrawDataTotalPage = @"total_page";
NSString *const kTHNWithdrawDataTotalRows = @"total_rows";

@interface THNWithdrawData ()
@end
@implementation THNWithdrawData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNWithdrawDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kTHNWithdrawDataCurrentPage] integerValue];
	}

	if(![dictionary[kTHNWithdrawDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNWithdrawDataCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNWithdrawDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kTHNWithdrawDataNextPage] integerValue];
	}

	if(![dictionary[kTHNWithdrawDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kTHNWithdrawDataPager];
	}	
	if(![dictionary[kTHNWithdrawDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kTHNWithdrawDataPrevPage] integerValue];
	}

	if(dictionary[kTHNWithdrawDataRows] != nil && [dictionary[kTHNWithdrawDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kTHNWithdrawDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			THNWithdrawRow * rowsItem = [[THNWithdrawRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kTHNWithdrawDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kTHNWithdrawDataTotalPage] integerValue];
	}

	if(![dictionary[kTHNWithdrawDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kTHNWithdrawDataTotalRows] integerValue];
	}

	return self;
}
@end