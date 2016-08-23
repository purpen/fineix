//
//	THNMallSubjectModelData.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNMallSubjectModelData.h"

NSString *const kTHNMallSubjectModelDataCurrentPage = @"current_page";
NSString *const kTHNMallSubjectModelDataCurrentUserId = @"current_user_id";
NSString *const kTHNMallSubjectModelDataNextPage = @"next_page";
NSString *const kTHNMallSubjectModelDataPager = @"pager";
NSString *const kTHNMallSubjectModelDataPrevPage = @"prev_page";
NSString *const kTHNMallSubjectModelDataRows = @"rows";
NSString *const kTHNMallSubjectModelDataTotalPage = @"total_page";
NSString *const kTHNMallSubjectModelDataTotalRows = @"total_rows";

@interface THNMallSubjectModelData ()
@end
@implementation THNMallSubjectModelData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNMallSubjectModelDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kTHNMallSubjectModelDataCurrentPage] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNMallSubjectModelDataCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kTHNMallSubjectModelDataNextPage] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kTHNMallSubjectModelDataPager];
	}	
	if(![dictionary[kTHNMallSubjectModelDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kTHNMallSubjectModelDataPrevPage] integerValue];
	}

	if(dictionary[kTHNMallSubjectModelDataRows] != nil && [dictionary[kTHNMallSubjectModelDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kTHNMallSubjectModelDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			THNMallSubjectModelRow * rowsItem = [[THNMallSubjectModelRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kTHNMallSubjectModelDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kTHNMallSubjectModelDataTotalPage] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kTHNMallSubjectModelDataTotalRows] integerValue];
	}

	return self;
}
@end