//
//	THNRemindModelData.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNRemindModelData.h"

NSString *const kTHNRemindModelDataCurrentPage = @"current_page";
NSString *const kTHNRemindModelDataCurrentUserId = @"current_user_id";
NSString *const kTHNRemindModelDataNextPage = @"next_page";
NSString *const kTHNRemindModelDataPager = @"pager";
NSString *const kTHNRemindModelDataPrevPage = @"prev_page";
NSString *const kTHNRemindModelDataRows = @"rows";
NSString *const kTHNRemindModelDataTotalPage = @"total_page";
NSString *const kTHNRemindModelDataTotalRows = @"total_rows";

@interface THNRemindModelData ()
@end
@implementation THNRemindModelData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNRemindModelDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kTHNRemindModelDataCurrentPage] integerValue];
	}

	if(![dictionary[kTHNRemindModelDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNRemindModelDataCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNRemindModelDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kTHNRemindModelDataNextPage] integerValue];
	}

	if(![dictionary[kTHNRemindModelDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kTHNRemindModelDataPager];
	}	
	if(![dictionary[kTHNRemindModelDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kTHNRemindModelDataPrevPage] integerValue];
	}

	if(dictionary[kTHNRemindModelDataRows] != nil && [dictionary[kTHNRemindModelDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kTHNRemindModelDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			THNRemindModelRow * rowsItem = [[THNRemindModelRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kTHNRemindModelDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kTHNRemindModelDataTotalPage] integerValue];
	}

	if(![dictionary[kTHNRemindModelDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kTHNRemindModelDataTotalRows] integerValue];
	}

	return self;
}
@end