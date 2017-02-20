//
//	UserModelData.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "UserModelData.h"

NSString *const kUserModelDataCurrentPage = @"current_page";
NSString *const kUserModelDataCurrentUserId = @"current_user_id";
NSString *const kUserModelDataMsg = @"msg";
NSString *const kUserModelDataRows = @"rows";
NSString *const kUserModelDataSuccess = @"success";
NSString *const kUserModelDataTotalCount = @"total_count";
NSString *const kUserModelDataTotalPage = @"total_page";

@interface UserModelData ()
@end
@implementation UserModelData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kUserModelDataCurrentPage] isKindOfClass:[NSNull class]]){
		self.currentPage = [dictionary[kUserModelDataCurrentPage] integerValue];
	}

	if(![dictionary[kUserModelDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kUserModelDataCurrentUserId] integerValue];
	}

	if(![dictionary[kUserModelDataMsg] isKindOfClass:[NSNull class]]){
		self.msg = dictionary[kUserModelDataMsg];
	}	
	if(dictionary[kUserModelDataRows] != nil && [dictionary[kUserModelDataRows] isKindOfClass:[NSArray class]]){
		NSArray * rowsDictionaries = dictionary[kUserModelDataRows];
		NSMutableArray * rowsItems = [NSMutableArray array];
		for(NSDictionary * rowsDictionary in rowsDictionaries){
			UserModelRow * rowsItem = [[UserModelRow alloc] initWithDictionary:rowsDictionary];
			[rowsItems addObject:rowsItem];
		}
		self.rows = rowsItems;
	}
	if(![dictionary[kUserModelDataSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kUserModelDataSuccess] boolValue];
	}

	if(![dictionary[kUserModelDataTotalCount] isKindOfClass:[NSNull class]]){
		self.totalCount = [dictionary[kUserModelDataTotalCount] integerValue];
	}

	if(![dictionary[kUserModelDataTotalPage] isKindOfClass:[NSNull class]]){
		self.totalPage = [dictionary[kUserModelDataTotalPage] integerValue];
	}

	return self;
}
@end