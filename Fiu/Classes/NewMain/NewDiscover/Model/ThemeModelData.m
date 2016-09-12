//
//	ThemeModelData.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ThemeModelData.h"

NSString *const kThemeModelDataCurrentPage = @"current_page";
NSString *const kThemeModelDataCurrentUserId = @"current_user_id";
NSString *const kThemeModelDataMsg = @"msg";
NSString *const kThemeModelDataRows = @"rows";
NSString *const kThemeModelDataSuccess = @"success";
NSString *const kThemeModelDataTotalCount = @"total_count";
NSString *const kThemeModelDataTotalPage = @"total_page";

@interface ThemeModelData ()
@end
@implementation ThemeModelData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kThemeModelDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kThemeModelDataCurrentPage] integerValue];
	}

	if(![dictionary[kThemeModelDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kThemeModelDataCurrentUserId] integerValue];
	}

	if(![dictionary[kThemeModelDataMsg] isKindOfClass:[NSNull class]]){
		self.msg = dictionary[kThemeModelDataMsg];
	}	
	if(dictionary[kThemeModelDataRows] != nil && [dictionary[kThemeModelDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kThemeModelDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			ThemeModelRow * rowsItem = [[ThemeModelRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kThemeModelDataSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kThemeModelDataSuccess] boolValue];
	}

	if(![dictionary[kThemeModelDataTotalCount] isKindOfClass:[NSNull class]]){
		self.totalCount = [dictionary[kThemeModelDataTotalCount] integerValue];
	}

	if(![dictionary[kThemeModelDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kThemeModelDataTotalPage] integerValue];
	}

	return self;
}
@end