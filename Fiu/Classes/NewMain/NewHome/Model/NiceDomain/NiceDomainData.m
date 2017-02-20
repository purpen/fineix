//
//	NiceDomainData.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NiceDomainData.h"

NSString *const kNiceDomainDataCurrentPage = @"current_page";
NSString *const kNiceDomainDataCurrentUserId = @"current_user_id";
NSString *const kNiceDomainDataNextPage = @"next_page";
NSString *const kNiceDomainDataPager = @"pager";
NSString *const kNiceDomainDataPrevPage = @"prev_page";
NSString *const kNiceDomainDataRows = @"rows";
NSString *const kNiceDomainDataTotalPage = @"total_page";
NSString *const kNiceDomainDataTotalRows = @"total_rows";

@interface NiceDomainData ()
@end
@implementation NiceDomainData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNiceDomainDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kNiceDomainDataCurrentPage] integerValue];
	}

	if(![dictionary[kNiceDomainDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kNiceDomainDataCurrentUserId] integerValue];
	}

	if(![dictionary[kNiceDomainDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kNiceDomainDataNextPage] integerValue];
	}

	if(![dictionary[kNiceDomainDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kNiceDomainDataPager];
	}	
	if(![dictionary[kNiceDomainDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kNiceDomainDataPrevPage] integerValue];
	}

	if(dictionary[kNiceDomainDataRows] != nil && [dictionary[kNiceDomainDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kNiceDomainDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			NiceDomainRow * rowsItem = [[NiceDomainRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kNiceDomainDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kNiceDomainDataTotalPage] integerValue];
	}

	if(![dictionary[kNiceDomainDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kNiceDomainDataTotalRows] integerValue];
	}

	return self;
}
@end
