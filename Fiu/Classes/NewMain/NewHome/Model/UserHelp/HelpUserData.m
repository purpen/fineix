//
//	HelpUserData.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HelpUserData.h"

NSString *const kHelpUserDataCurrentPage = @"current_page";
NSString *const kHelpUserDataCurrentUserId = @"current_user_id";
NSString *const kHelpUserDataNextPage = @"next_page";
NSString *const kHelpUserDataPager = @"pager";
NSString *const kHelpUserDataPrevPage = @"prev_page";
NSString *const kHelpUserDataRows = @"rows";
NSString *const kHelpUserDataTotalPage = @"total_page";
NSString *const kHelpUserDataTotalRows = @"total_rows";

@interface HelpUserData ()
@end
@implementation HelpUserData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHelpUserDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kHelpUserDataCurrentPage] integerValue];
	}

	if(![dictionary[kHelpUserDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kHelpUserDataCurrentUserId] integerValue];
	}

	if(![dictionary[kHelpUserDataNextPage] isKindOfClass:[NSNull class]]){
		self.nextPage = [dictionary[kHelpUserDataNextPage] integerValue];
	}

	if(![dictionary[kHelpUserDataPager] isKindOfClass:[NSNull class]]){
		self.pager = dictionary[kHelpUserDataPager];
	}	
	if(![dictionary[kHelpUserDataPrevPage] isKindOfClass:[NSNull class]]){
		self.prevPage = [dictionary[kHelpUserDataPrevPage] integerValue];
	}

	if(dictionary[kHelpUserDataRows] != nil && [dictionary[kHelpUserDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kHelpUserDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			HelpUserRow * rowsItem = [[HelpUserRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kHelpUserDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kHelpUserDataTotalPage] integerValue];
	}

	if(![dictionary[kHelpUserDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kHelpUserDataTotalRows] integerValue];
	}

	return self;
}
@end
