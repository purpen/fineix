//
//	DomainCategoryData.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "DomainCategoryData.h"

NSString *const kDomainCategoryDataCurrentPage = @"current_page";
NSString *const kDomainCategoryDataCurrentUserId = @"current_user_id";
NSString *const kDomainCategoryDataNextPage = @"next_page";
NSString *const kDomainCategoryDataPager = @"pager";
NSString *const kDomainCategoryDataPrevPage = @"prev_page";
NSString *const kDomainCategoryDataRows = @"rows";
NSString *const kDomainCategoryDataTotalPage = @"total_page";
NSString *const kDomainCategoryDataTotalRows = @"total_rows";

@interface DomainCategoryData ()
@end
@implementation DomainCategoryData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kDomainCategoryDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kDomainCategoryDataCurrentPage] integerValue];
	}

	if(![dictionary[kDomainCategoryDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kDomainCategoryDataCurrentUserId] integerValue];
	}

	if(![dictionary[kDomainCategoryDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kDomainCategoryDataNextPage] integerValue];
	}

	if(![dictionary[kDomainCategoryDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kDomainCategoryDataPager];
	}	
	if(![dictionary[kDomainCategoryDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kDomainCategoryDataPrevPage] integerValue];
	}

	if(dictionary[kDomainCategoryDataRows] != nil && [dictionary[kDomainCategoryDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kDomainCategoryDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			DomainCategoryRow * rowsItem = [[DomainCategoryRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kDomainCategoryDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kDomainCategoryDataTotalPage] integerValue];
	}

	if(![dictionary[kDomainCategoryDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kDomainCategoryDataTotalRows] integerValue];
	}

	return self;
}
@end
