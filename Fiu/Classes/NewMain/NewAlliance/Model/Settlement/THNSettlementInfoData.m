//
//	THNSettlementInfoData.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNSettlementInfoData.h"

NSString *const kTHNSettlementInfoDataCurrentPage = @"current_page";
NSString *const kTHNSettlementInfoDataCurrentUserId = @"current_user_id";
NSString *const kTHNSettlementInfoDataNextPage = @"next_page";
NSString *const kTHNSettlementInfoDataPager = @"pager";
NSString *const kTHNSettlementInfoDataPrevPage = @"prev_page";
NSString *const kTHNSettlementInfoDataRows = @"rows";
NSString *const kTHNSettlementInfoDataTotalPage = @"total_page";
NSString *const kTHNSettlementInfoDataTotalRows = @"total_rows";

@interface THNSettlementInfoData ()
@end
@implementation THNSettlementInfoData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNSettlementInfoDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kTHNSettlementInfoDataCurrentPage] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNSettlementInfoDataCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kTHNSettlementInfoDataNextPage] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kTHNSettlementInfoDataPager];
	}	
	if(![dictionary[kTHNSettlementInfoDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kTHNSettlementInfoDataPrevPage] integerValue];
	}

	if(dictionary[kTHNSettlementInfoDataRows] != nil && [dictionary[kTHNSettlementInfoDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kTHNSettlementInfoDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			THNSettlementInfoRow * rowsItem = [[THNSettlementInfoRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kTHNSettlementInfoDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kTHNSettlementInfoDataTotalPage] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kTHNSettlementInfoDataTotalRows] integerValue];
	}

	return self;
}
@end