//
//	FiuPeopleData.m
// on 14/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FiuPeopleData.h"

@interface FiuPeopleData ()
@end
@implementation FiuPeopleData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"current_user_id"] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[@"current_user_id"] integerValue];
	}

	if(dictionary[@"users"] != nil && [dictionary[@"users"] isKindOfClass:[NSArray class]]){
		NSArray * usersDictionaries = dictionary[@"users"];
		NSMutableArray * usersItems = [NSMutableArray array];
		for(NSDictionary * usersDictionary in usersDictionaries){
			FiuPeopleUser * usersItem = [[FiuPeopleUser alloc] initWithDictionary:usersDictionary];
			[usersItems addObject:usersItem];
		}
		self.users = usersItems;
	}
	return self;
}
@end