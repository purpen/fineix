//
//	FBSubjectModelData.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FBSubjectModelData.h"

NSString *const kFBSubjectModelDataCurrentPage = @"current_page";
NSString *const kFBSubjectModelDataCurrentUserId = @"current_user_id";
NSString *const kFBSubjectModelDataNextPage = @"next_page";
NSString *const kFBSubjectModelDataPager = @"pager";
NSString *const kFBSubjectModelDataPrevPage = @"prev_page";
NSString *const kFBSubjectModelDataRows = @"rows";
NSString *const kFBSubjectModelDataTotalPage = @"total_page";
NSString *const kFBSubjectModelDataTotalRows = @"total_rows";

@interface FBSubjectModelData ()
@end
@implementation FBSubjectModelData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFBSubjectModelDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kFBSubjectModelDataCurrentPage] integerValue];
	}

	if(![dictionary[kFBSubjectModelDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kFBSubjectModelDataCurrentUserId] integerValue];
	}

	if(![dictionary[kFBSubjectModelDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kFBSubjectModelDataNextPage] integerValue];
	}

	if(![dictionary[kFBSubjectModelDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kFBSubjectModelDataPager];
	}	
	if(![dictionary[kFBSubjectModelDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kFBSubjectModelDataPrevPage] integerValue];
	}

	if(dictionary[kFBSubjectModelDataRows] != nil && [dictionary[kFBSubjectModelDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kFBSubjectModelDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			FBSubjectModelRow * rowsItem = [[FBSubjectModelRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kFBSubjectModelDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kFBSubjectModelDataTotalPage] integerValue];
	}

	if(![dictionary[kFBSubjectModelDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kFBSubjectModelDataTotalRows] integerValue];
	}

	return self;
}
@end