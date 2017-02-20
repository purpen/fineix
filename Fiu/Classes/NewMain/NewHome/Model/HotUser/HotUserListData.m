//
//	HotUserListData.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HotUserListData.h"

NSString *const kHotUserListDataCurrentUserId = @"current_user_id";
NSString *const kHotUserListDataUsers = @"users";

@interface HotUserListData ()
@end
@implementation HotUserListData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHotUserListDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kHotUserListDataCurrentUserId] integerValue];
	}

	if(dictionary[kHotUserListDataUsers] != nil && [dictionary[kHotUserListDataUsers] isKindOfClass:[NSArray class]]){
		NSArray * usersDictionaries = dictionary[kHotUserListDataUsers];
		NSMutableArray * usersItems = [NSMutableArray array];
		for(NSDictionary * usersDictionary in usersDictionaries){
			HotUserListUser * usersItem = [[HotUserListUser alloc] initWithDictionary:usersDictionary];
			[usersItems addObject:usersItem];
		}
		self.users = usersItems;
	}
	return self;
}
@end