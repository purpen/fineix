//
//	HomeSubjectData.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HomeSubjectData.h"

NSString *const kHomeSubjectDataCurrentUserId = @"current_user_id";
NSString *const kHomeSubjectDataRows = @"rows";
NSString *const kHomeSubjectDataTotalPage = @"total_page";
NSString *const kHomeSubjectDataTotalRows = @"total_rows";

@interface HomeSubjectData ()
@end
@implementation HomeSubjectData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHomeSubjectDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kHomeSubjectDataCurrentUserId] integerValue];
	}

	if(dictionary[kHomeSubjectDataRows] != nil && [dictionary[kHomeSubjectDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kHomeSubjectDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			HomeSubjectRow * rowsItem = [[HomeSubjectRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kHomeSubjectDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kHomeSubjectDataTotalPage] integerValue];
	}

	if(![dictionary[kHomeSubjectDataTotalRows] isKindOfClass:[NSNull class]]){
		self.totalRows = [dictionary[kHomeSubjectDataTotalRows] integerValue];
	}

	return self;
}
@end