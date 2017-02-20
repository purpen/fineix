//
//	HomeGoodsData.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HomeGoodsData.h"

NSString *const kHomeGoodsDataCurrentPage = @"current_page";
NSString *const kHomeGoodsDataCurrentUserId = @"current_user_id";
NSString *const kHomeGoodsDataNextPage = @"next_page";
NSString *const kHomeGoodsDataPager = @"pager";
NSString *const kHomeGoodsDataPrevPage = @"prev_page";
NSString *const kHomeGoodsDataRows = @"rows";
NSString *const kHomeGoodsDataTotalPage = @"total_page";
NSString *const kHomeGoodsDataTotalRows = @"total_rows";

@interface HomeGoodsData ()
@end
@implementation HomeGoodsData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHomeGoodsDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kHomeGoodsDataCurrentPage] integerValue];
	}

	if(![dictionary[kHomeGoodsDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kHomeGoodsDataCurrentUserId] integerValue];
	}

	if(![dictionary[kHomeGoodsDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kHomeGoodsDataNextPage] integerValue];
	}

	if(![dictionary[kHomeGoodsDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kHomeGoodsDataPager];
	}	
	if(![dictionary[kHomeGoodsDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kHomeGoodsDataPrevPage] integerValue];
	}

	if(dictionary[kHomeGoodsDataRows] != nil && [dictionary[kHomeGoodsDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kHomeGoodsDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			HomeGoodsRow * rowsItem = [[HomeGoodsRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kHomeGoodsDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kHomeGoodsDataTotalPage] integerValue];
	}

	if(![dictionary[kHomeGoodsDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kHomeGoodsDataTotalRows] integerValue];
	}

	return self;
}
@end
